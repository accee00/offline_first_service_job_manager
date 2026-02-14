import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';

enum JobStatus { open, assigned, inProgress, done, cancelled }

extension JobStatusX on JobStatus {
  String toDb() => name;

  static JobStatus fromDb(String value) =>
      JobStatus.values.firstWhere((e) => e.name == value);

  String get displayName {
    switch (this) {
      case JobStatus.open:
        return 'Open';
      case JobStatus.assigned:
        return 'Assigned';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.done:
        return 'Done';
      case JobStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class JobModel {
  final String? id;
  final String title;
  final String description;
  final JobStatus status;
  final int scheuledAt;
  final int completedAt;
  final String createdBy;
  final int createdAt;
  final int updatedAt;
  final int version;
  final bool isDeleted;
  final int lastSyncedAt;
  final SyncStatus syncStatus;

  JobModel({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.scheuledAt,
    required this.completedAt,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isDeleted,
    required this.lastSyncedAt,
    required this.syncStatus,
  });

  JobModel copyWith({
    String? id,
    String? title,
    String? description,
    JobStatus? status,
    int? scheuledAt,
    int? completedAt,
    String? createdBy,
    int? createdAt,
    int? updatedAt,
    int? version,
    bool? isDeleted,
    int? lastSyncedAt,
    SyncStatus? syncStatus,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      scheuledAt: scheuledAt ?? this.scheuledAt,
      completedAt: completedAt ?? this.completedAt,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'status': status.toDb(),
      'scheuledAt': scheuledAt,
      'completedAt': completedAt,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'version': version,
      'isDeleted': isDeleted,
      'lastSyncedAt': lastSyncedAt,
      'syncStatus': syncStatus.toDb(),
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      status: JobStatusX.fromDb(map['status'] as String),
      scheuledAt: map['scheuledAt'] as int,
      completedAt: map['completedAt'] as int,
      createdBy: map['createdBy'] as String,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      version: map['version'] as int,
      isDeleted: map['isDeleted'] as bool,
      lastSyncedAt: map['lastSyncedAt'] as int,
      syncStatus: SyncStatusX.fromDb(map['sync_status'] as int),
    );
  }
}
