import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:offline_first_service_job_manager/core/service/network_service.dart';
import 'package:offline_first_service_job_manager/core/database/app_database.dart';
import 'package:offline_first_service_job_manager/features/auth/repository/auth_local_repository.dart';
import 'package:offline_first_service_job_manager/features/auth/repository/auth_remote_repository.dart';
import 'package:offline_first_service_job_manager/features/auth/repository/auth_repository.dart';
import 'package:offline_first_service_job_manager/features/jobs/repository/jobs_local_repository.dart';
import 'package:offline_first_service_job_manager/features/jobs/repository/jobs_remote_repository.dart';
import 'package:offline_first_service_job_manager/features/jobs/repository/jobs_repository.dart';

part 'riverpod_di.g.dart';

@Riverpod(keepAlive: true)
NetworkService networkService(Ref ref) {
  return NetworkService();
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(authLocalRepositoryProvider),
    ref.watch(authRemoteRepositoryProvider),
    ref,
  );
}

@Riverpod(keepAlive: true)
JobsLocalRepository jobsLocalRepository(Ref ref) {
  return JobsLocalRepository(ref.watch(appDatabaseProvider));
}

@Riverpod(keepAlive: true)
JobsRemoteRepository jobsRemoteRepository(Ref ref) {
  return JobsRemoteRepository();
}

@Riverpod(keepAlive: true)
JobsRepository jobsRepository(Ref ref) {
  return JobsRepository(
    ref.watch(jobsLocalRepositoryProvider),
    ref.watch(jobsRemoteRepositoryProvider),
    ref.watch(appDatabaseProvider),
    ref,
  );
}
