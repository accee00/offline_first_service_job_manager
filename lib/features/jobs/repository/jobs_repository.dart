import 'package:drift/drift.dart';
import 'package:offline_first_service_job_manager/core/database/app_database.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';
import 'package:offline_first_service_job_manager/features/jobs/repository/jobs_local_repository.dart';
import 'package:offline_first_service_job_manager/features/jobs/repository/jobs_remote_repository.dart';
import 'package:offline_first_service_job_manager/core/riverpod/network_checker_pod.dart';
import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';
import 'package:offline_first_service_job_manager/core/sync/sync_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';

class JobsRepository {
  final JobsLocalRepository _local;
  final JobsRemoteRepository _remote;
  final AppDatabase _db;
  final Ref _ref;

  JobsRepository(this._local, this._remote, this._db, this._ref);

  Future<List<JobModel>> getJobs() async {
    final networkStatus = await _ref.read(networkStatusProvider.future);

    if (networkStatus == NetworkStatus.online) {
      // Trigger a sync pull/push
      await _ref.read(syncManagerProvider).syncAll();
      return _local.getAllJobs();
    } else {
      return _local.getAllJobs();
    }
  }

  Future<JobModel> createJob(JobModel job) async {
    final networkStatus = await _ref.read(networkStatusProvider.future);
    final localJob = job.copyWith(
      id: job.id ?? 'local_${DateTime.now().millisecondsSinceEpoch}',
      syncStatus: SyncStatus.dirty,
    );

    if (networkStatus == NetworkStatus.online) {
      try {
        final createdJob = await _remote.createJob(job);
        await _local.saveJob(createdJob);
        return createdJob;
      } catch (e) {
        await _local.saveJob(localJob);
        await _addToSyncQueue('jobs', localJob.id!, 'create', localJob.toMap());
        return localJob;
      }
    } else {
      await _local.saveJob(localJob);
      await _addToSyncQueue('jobs', localJob.id!, 'create', localJob.toMap());
      return localJob;
    }
  }

  Future<void> updateJob(JobModel job) async {
    final networkStatus = await _ref.read(networkStatusProvider.future);

    if (networkStatus == NetworkStatus.online) {
      try {
        await _remote.updateJob(job);
        await _local.saveJob(job.copyWith(syncStatus: SyncStatus.clean));
      } catch (e) {
        await _local.saveJob(job.copyWith(syncStatus: SyncStatus.dirty));
        await _addToSyncQueue('jobs', job.id!, 'update', job.toMap());
      }
    } else {
      await _local.saveJob(job.copyWith(syncStatus: SyncStatus.dirty));
      await _addToSyncQueue('jobs', job.id!, 'update', job.toMap());
    }
  }

  Future<void> _addToSyncQueue(
    String table,
    String recordId,
    String operation,
    Map<String, dynamic> payload,
  ) async {
    await _db
        .into(_db.syncQueue)
        .insert(
          SyncQueueCompanion(
            targetTable: Value(table),
            recordId: Value(recordId),
            operation: Value(operation),
            payload: Value(jsonEncode(payload)),
            createdAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }
}
