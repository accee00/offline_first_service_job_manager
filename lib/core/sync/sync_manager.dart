import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_service_job_manager/core/database/app_database.dart';
import 'package:offline_first_service_job_manager/core/di/riverpod_di.dart';
import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';
import 'package:offline_first_service_job_manager/core/sync/sync_status_provider.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';

class SyncManager {
  final AppDatabase _db;
  final Ref _ref;
  bool _isSyncing = false;

  SyncManager(this._db, this._ref);

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _ref.read(appSyncStatusProvider.notifier).setSyncing(true);

    try {
      // 1. Pull changes
      await pullRemoteChanges();

      // 2. Push local changes
      await processSyncQueue();

      _ref.read(appSyncStatusProvider.notifier).setLastSynced(DateTime.now());
    } catch (e) {
      _ref.read(appSyncStatusProvider.notifier).setError(e.toString());
    } finally {
      _isSyncing = false;
      _ref.read(appSyncStatusProvider.notifier).setSyncing(false);
    }
  }

  Future<void> pullRemoteChanges() async {
    try {
      final jobsRemote = _ref.read(jobsRemoteRepositoryProvider);
      final jobsLocal = _ref.read(jobsLocalRepositoryProvider);

      final remoteJobs = await jobsRemote.fetchJobs();
      for (final remoteJob in remoteJobs) {
        final localJob = await jobsLocal.getJobById(remoteJob.id!);

        if (localJob == null || remoteJob.version > localJob.version) {
          // Remote is newer or doesn't exist locally
          await jobsLocal.saveJob(
            remoteJob.copyWith(syncStatus: SyncStatus.clean),
          );
        } else if (remoteJob.version == localJob.version &&
            localJob.syncStatus == SyncStatus.dirty) {
          // Same version but local is dirty - potential collision or just local update not yet pushed
          // In this case, we prefer local dirty state to be resolved during push
        }
      }
    } catch (e) {
      debugPrint('Pull sync failed: $e');
    }
  }

  Future<void> processSyncQueue() async {
    try {
      final queue = await _db.select(_db.syncQueue).get();
      for (final item in queue) {
        await _processItem(item);
      }
    } catch (e) {
      debugPrint('Sync queue processing failed: $e');
    }
  }

  Future<void> _processItem(SyncQueueData item) async {
    try {
      if (item.targetTable == 'jobs') {
        await _syncJob(item);
      }
      // Add other tables here (e.g., users)

      // If successful, remove from queue
      await (_db.delete(
        _db.syncQueue,
      )..where((t) => t.id.equals(item.id))).go();
    } catch (e) {
      // Increment retry count and log error
      await (_db.update(
        _db.syncQueue,
      )..where((t) => t.id.equals(item.id))).write(
        SyncQueueCompanion(
          retryCount: Value(item.retryCount + 1),
          lastError: Value(e.toString()),
        ),
      );
    }
  }

  Future<void> _syncJob(SyncQueueData item) async {
    final jobsRemote = _ref.read(jobsRemoteRepositoryProvider);
    final jobsLocal = _ref.read(jobsLocalRepositoryProvider);
    final payload = jsonDecode(item.payload ?? '{}');
    final job = JobModel.fromMap(payload);

    try {
      if (item.operation == 'create') {
        final createdJob = await jobsRemote.createJob(job);
        await jobsLocal.saveJob(
          createdJob.copyWith(syncStatus: SyncStatus.clean),
        );
      } else if (item.operation == 'update') {
        // Fetch remote version first to check for conflict
        final remoteJob = await jobsRemote.fetchJobById(job.id!);
        if (remoteJob != null && remoteJob.version > job.version) {
          // Conflict detected!
          await _handleConflict(job, remoteJob);
        } else {
          await jobsRemote.updateJob(job);
          await jobsLocal.saveJob(
            job.copyWith(
              syncStatus: SyncStatus.clean,
              version: job.version + 1,
            ),
          );
        }
      } else if (item.operation == 'delete') {
        await jobsRemote.deleteJob(item.recordId);
      }
    } catch (e) {
      rethrow; // _processItem will handle retry logging
    }
  }

  Future<void> _handleConflict(JobModel localJob, JobModel remoteJob) async {
    final jobsLocal = _ref.read(jobsLocalRepositoryProvider);
    // Basic conflict resolution: Remote wins for now, but logs the conflict
    // In a real app, you might merge or ask the user
    debugPrint(
      'Conflict detected for job ${localJob.id}. Remote version is newer.',
    );
    await jobsLocal.saveJob(remoteJob.copyWith(syncStatus: SyncStatus.clean));
  }
}
