import 'dart:async';

import 'package:offline_first_service_job_manager/core/di/riverpod_di.dart';
import 'package:offline_first_service_job_manager/core/service/network_service.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_checker_pod.g.dart';

enum NetworkStatus { initial, online, offline }

@riverpod
Stream<NetworkStatus> networkStatus(Ref ref) {
  final NetworkService service = ref.watch(networkServiceProvider);

  return service.connectionStream.map(
    (connected) => connected ? NetworkStatus.online : NetworkStatus.offline,
  );
}
