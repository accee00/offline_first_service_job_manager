import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:offline_first_service_job_manager/core/service/network_service.dart';
import 'package:offline_first_service_job_manager/core/database/app_database.dart';
import 'package:offline_first_service_job_manager/features/auth/repository/auth_local_repository.dart';

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
