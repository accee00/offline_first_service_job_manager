import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;

  NetworkService._internal() {
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      _streamController.add(status == InternetStatus.connected);
    });
  }
  final StreamController<bool> _streamController = StreamController.broadcast();

  Stream<bool> get connectionStream => _streamController.stream;
}
