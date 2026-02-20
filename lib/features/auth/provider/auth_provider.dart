import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:offline_first_service_job_manager/features/auth/model/user_model.dart';
import 'package:offline_first_service_job_manager/core/di/riverpod_di.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  UserModel? build() {
    return null;
  }

  Future<void> login(String email, String password) async {
    final repository = ref.read(authRepositoryProvider);
    final user = await repository.login(email, password);
    state = user;
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = null;
  }
}
