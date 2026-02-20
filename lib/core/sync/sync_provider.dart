import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:offline_first_service_job_manager/core/sync/sync_manager.dart';
import 'package:offline_first_service_job_manager/core/di/riverpod_di.dart';
import 'package:offline_first_service_job_manager/core/riverpod/network_checker_pod.dart';

part 'sync_provider.g.dart';

@Riverpod(keepAlive: true)
SyncManager syncManager(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final manager = SyncManager(db, ref);

  // Automatically start sync when coming back online
  ref.listen(networkStatusProvider, (previous, next) {
    if (next.value == NetworkStatus.online) {
      manager.processSyncQueue();
    }
  });

  return manager;
}
