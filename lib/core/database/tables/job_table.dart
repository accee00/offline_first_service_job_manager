import 'package:drift/drift.dart';
import 'package:offline_first_service_job_manager/features/jobs/model/jobs_model.dart';
import 'package:offline_first_service_job_manager/core/database/tables/user_table.dart';

class Jobs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get status => text().map(const JobStatusConverter())();
  IntColumn get scheduledAt => integer().nullable()();
  IntColumn get completedAt => integer().nullable()();
  TextColumn get createdBy => text()();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();
  IntColumn get version => integer().withDefault(const Constant(0))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get lastSyncedAt => integer().nullable()();
  IntColumn get syncStatus => integer().map(const SyncStatusConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class JobStatusConverter extends TypeConverter<JobStatus, String> {
  const JobStatusConverter();

  @override
  JobStatus fromSql(String fromDb) => JobStatusX.fromDb(fromDb);

  @override
  String toSql(JobStatus value) => value.toDb();
}
