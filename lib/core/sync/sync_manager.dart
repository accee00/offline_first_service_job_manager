import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_service_job_manager/core/database/app_database.dart';
import 'package:offline_first_service_job_manager/core/di/riverpod_di.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';

class SyncManager {
  final AppDatabase _db;
  final Ref _ref;
  bool _isSyncing = false;

  SyncManager(this._db, this._ref);

  Future<void> processSyncQueue() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final queue = await _db.select(_db.syncQueue).get();
      for (final item in queue) {
        await _processItem(item);
      }
    } finally {
      _isSyncing = false;
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
    final payload = jsonDecode(item.payload ?? '{}');
    final job = JobModel.fromMap(payload);

    if (item.operation == 'create') {
      await jobsRemote.createJob(job);
    } else if (item.operation == 'update') {
      await jobsRemote.updateJob(job);
    } else if (item.operation == 'delete') {
      await jobsRemote.deleteJob(item.recordId);
    }
  }
}
