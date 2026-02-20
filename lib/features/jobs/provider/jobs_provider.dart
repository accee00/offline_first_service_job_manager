import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';
import 'package:offline_first_service_job_manager/core/di/riverpod_di.dart';

part 'jobs_provider.g.dart';

@riverpod
class JobsNotifier extends _$JobsNotifier {
  @override
  FutureOr<List<JobModel>> build() async {
    final repository = ref.watch(jobsRepositoryProvider);
    return repository.getJobs();
  }

  Future<void> addJob(JobModel job) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(jobsRepositoryProvider);
      await repository.createJob(job);
      return repository.getJobs();
    });
  }

  Future<void> updateJob(JobModel job) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(jobsRepositoryProvider);
      await repository.updateJob(job);
      return repository.getJobs();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(jobsRepositoryProvider);
      return repository.getJobs();
    });
  }
}
