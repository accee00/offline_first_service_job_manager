import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:offline_first_service_job_manager/core/service/network_service.dart';

part 'riverpod_di.g.dart';

@Riverpod(keepAlive: true)
NetworkService networkService(Ref ref) {
  return NetworkService();
}
