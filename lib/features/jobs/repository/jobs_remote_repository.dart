import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';
import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';

class JobsRemoteRepository {
  final Map<String, JobModel> _mockRemoteDb = {};

  Future<List<JobModel>> fetchJobs() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockRemoteDb.values.toList();
  }

  Future<JobModel?> fetchJobById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRemoteDb[id];
  }

  Future<JobModel> createJob(JobModel job) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newJob = job.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      syncStatus: SyncStatus.clean,
      lastSyncedAt: DateTime.now().millisecondsSinceEpoch,
    );
    _mockRemoteDb[newJob.id!] = newJob;
    return newJob;
  }

  Future<JobModel> updateJob(JobModel job) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updatedJob = job.copyWith(
      syncStatus: SyncStatus.clean,
      lastSyncedAt: DateTime.now().millisecondsSinceEpoch,
    );
    _mockRemoteDb[updatedJob.id!] = updatedJob;
    return updatedJob;
  }

  Future<void> deleteJob(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockRemoteDb.remove(id);
  }
}
