import 'package:drift/drift.dart';
import 'package:offline_first_service_job_manager/core/database/app_database.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';

class JobsLocalRepository {
  final AppDatabase _db;

  JobsLocalRepository(this._db);

  Future<void> saveJob(JobModel job) async {
    await _db
        .into(_db.jobs)
        .insertOnConflictUpdate(
          JobsCompanion(
            id: Value(job.id ?? ''),
            title: Value(job.title),
            description: Value(job.description),
            status: Value(job.status),
            scheduledAt: Value(job.scheuledAt),
            completedAt: Value(job.completedAt),
            createdBy: Value(job.createdBy),
            createdAt: Value(job.createdAt),
            updatedAt: Value(job.updatedAt),
            version: Value(job.version),
            isDeleted: Value(job.isDeleted),
            lastSyncedAt: Value(job.lastSyncedAt),
            syncStatus: Value(job.syncStatus),
          ),
        );
  }

  Future<void> saveJobs(List<JobModel> jobs) async {
    await _db.batch((batch) {
      for (final job in jobs) {
        batch.insert(
          _db.jobs,
          JobsCompanion(
            id: Value(job.id ?? ''),
            title: Value(job.title),
            description: Value(job.description),
            status: Value(job.status),
            scheduledAt: Value(job.scheuledAt),
            completedAt: Value(job.completedAt),
            createdBy: Value(job.createdBy),
            createdAt: Value(job.createdAt),
            updatedAt: Value(job.updatedAt),
            version: Value(job.version),
            isDeleted: Value(job.isDeleted),
            lastSyncedAt: Value(job.lastSyncedAt),
            syncStatus: Value(job.syncStatus),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<JobModel>> getAllJobs() async {
    final jobs = await _db.select(_db.jobs).get();
    return jobs
        .map(
          (j) => JobModel(
            id: j.id,
            title: j.title,
            description: j.description,
            status: j.status,
            scheuledAt: j.scheduledAt ?? 0,
            completedAt: j.completedAt ?? 0,
            createdBy: j.createdBy,
            createdAt: j.createdAt ?? 0,
            updatedAt: j.updatedAt ?? 0,
            version: j.version,
            isDeleted: j.isDeleted,
            lastSyncedAt: j.lastSyncedAt ?? 0,
            syncStatus: j.syncStatus,
          ),
        )
        .toList();
  }

  Future<JobModel?> getJobById(String id) async {
    final j = await (_db.select(
      _db.jobs,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (j == null) return null;
    return JobModel(
      id: j.id,
      title: j.title,
      description: j.description,
      status: j.status,
      scheuledAt: j.scheduledAt ?? 0,
      completedAt: j.completedAt ?? 0,
      createdBy: j.createdBy,
      createdAt: j.createdAt ?? 0,
      updatedAt: j.updatedAt ?? 0,
      version: j.version,
      isDeleted: j.isDeleted,
      lastSyncedAt: j.lastSyncedAt ?? 0,
      syncStatus: j.syncStatus,
    );
  }
}
