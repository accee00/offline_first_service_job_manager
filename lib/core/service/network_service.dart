import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;

  NetworkService._internal() {
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      _statusController.add(status == InternetStatus.connected);
    });
  }

  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _statusController.stream;

  Future<bool> get isConnected async {
    return await InternetConnection().hasInternetAccess;
  }
}
