import 'package:offline_first_service_job_manager/features/auth/model/user_model.dart';
import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';

class AuthRemoteRepository {
  // Simulate a remote database
  final Map<String, UserModel> _mockRemoteDb = {};

  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_mockRemoteDb.containsKey(email)) {
      return _mockRemoteDb[email]!;
    }

    // For mock purposes, create a user if they don't exist
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: email.split('@')[0],
      role: Role.worker,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      version: 1,
      lastSyncedAt: DateTime.now().millisecondsSinceEpoch,
      syncStatus: SyncStatus.clean,
    );
    _mockRemoteDb[email] = user;
    return user;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UserModel> syncUser(UserModel user) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockRemoteDb[user.email] = user.copyWith(
      lastSyncedAt: DateTime.now().millisecondsSinceEpoch,
      syncStatus: SyncStatus.clean,
    );
    return _mockRemoteDb[user.email]!;
  }
}
