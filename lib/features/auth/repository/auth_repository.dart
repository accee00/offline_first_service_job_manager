import 'package:offline_first_service_job_manager/features/auth/model/user_model.dart';
import 'package:offline_first_service_job_manager/features/auth/repository/auth_local_repository.dart';
import 'package:offline_first_service_job_manager/features/auth/repository/auth_remote_repository.dart';
import 'package:offline_first_service_job_manager/core/riverpod/network_checker_pod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final AuthLocalRepository _local;
  final AuthRemoteRepository _remote;
  final Ref _ref;

  AuthRepository(this._local, this._remote, this._ref);

  Future<UserModel?> login(String email, String password) async {
    final networkStatus = await _ref.read(networkStatusProvider.future);

    if (networkStatus == NetworkStatus.online) {
      try {
        final remoteUser = await _remote.login(email, password);
        await _local.saveUser(remoteUser);
        return remoteUser;
      } catch (e) {
        // Fallback to local if remote fails even if online
        return _local.getUser(email);
      }
    } else {
      // Offline mode
      return _local.getUser(email);
    }
  }

  Future<void> logout() async {
    // For now, we just sign out locally (maybe clear DB or just session)
    // In a real app, you might notify the remote server
    final networkStatus = await _ref.read(networkStatusProvider.future);
    if (networkStatus == NetworkStatus.online) {
      await _remote.logout();
    }
    // We don't necessarily delete local user data on logout in offline-first
    // unless it's a security requirement.
  }

  Future<UserModel?> getCurrentUser(String email) async {
    return _local.getUser(email);
  }
}
