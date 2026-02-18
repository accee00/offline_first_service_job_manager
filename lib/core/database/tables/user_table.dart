import 'package:drift/drift.dart';
import 'package:offline_first_service_job_manager/features/auth/model/user_model.dart';
import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';

class Users extends Table {
  TextColumn get id => text().nullable()();
  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get role => text().map(const RoleConverter())();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();
  IntColumn get version => integer().withDefault(const Constant(0))();
  IntColumn get lastSyncedAt => integer().nullable()();
  IntColumn get syncStatus => integer().map(const SyncStatusConverter())();

  @override
  Set<Column> get primaryKey => {email};
}

class RoleConverter extends TypeConverter<Role, String> {
  const RoleConverter();

  @override
  Role fromSql(String fromDb) => RoleX.fromDb(fromDb);

  @override
  String toSql(Role value) => value.toDb();
}

class SyncStatusConverter extends TypeConverter<SyncStatus, int> {
  const SyncStatusConverter();

  @override
  SyncStatus fromSql(int fromDb) => SyncStatusX.fromDb(fromDb);

  @override
  int toSql(SyncStatus value) => value.toDb();
}
