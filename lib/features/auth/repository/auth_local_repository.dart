import 'package:drift/drift.dart';
import 'package:offline_first_service_job_manager/core/database/app_database.dart';
import 'package:offline_first_service_job_manager/features/auth/model/user_model.dart';

class AuthLocalRepository {
  final AppDatabase _db;

  AuthLocalRepository(this._db);

  Future<void> saveUser(UserModel user) async {
    await _db
        .into(_db.users)
        .insertOnConflictUpdate(
          UsersCompanion(
            id: Value(user.id),
            email: Value(user.email),
            name: Value(user.name),
            role: Value(user.role),
            createdAt: Value(user.createdAt),
            updatedAt: Value(user.updatedAt),
            version: Value(user.version),
            lastSyncedAt: Value(user.lastSyncedAt),
            syncStatus: Value(user.syncStatus),
          ),
        );
  }

  Future<UserModel?> getUser(String email) async {
    final user = await (_db.select(
      _db.users,
    )..where((t) => t.email.equals(email))).getSingleOrNull();

    if (user == null) return null;

    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      version: user.version,
      lastSyncedAt: user.lastSyncedAt,
      syncStatus: user.syncStatus,
    );
  }

  Future<void> deleteUser(String email) async {
    await (_db.delete(_db.users)..where((t) => t.email.equals(email))).go();
  }
}
