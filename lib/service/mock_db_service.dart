import 'package:offline_first_service_job_manager/service/network_service.dart';

class TestDb {
  final NetworkService _networkService = NetworkService();

  Future<bool> getStatus() async {
    final isConnected = await _networkService.connectionStream.first;
    return isConnected;
  }
}
