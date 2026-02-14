import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';

class JobAssignmentModel {
  final String? id;
  final String jobId;
  final String userId;
  final int assignedAt;
  final int version;
  final bool isDeleted;
  final int lastSyncedAt;
  final SyncStatus syncStatus;

  JobAssignmentModel({
    this.id,
    required this.jobId,
    required this.userId,
    required this.assignedAt,
    required this.version,
    required this.isDeleted,
    required this.lastSyncedAt,
    required this.syncStatus,
  });

  JobAssignmentModel copyWith({
    String? id,
    String? jobId,
    String? userId,
    int? assignedAt,
    int? version,
    bool? isDeleted,
    int? lastSyncedAt,
    SyncStatus? syncStatus,
  }) {
    return JobAssignmentModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      userId: userId ?? this.userId,
      assignedAt: assignedAt ?? this.assignedAt,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'jobId': jobId,
      'userId': userId,
      'assignedAt': assignedAt,
      'version': version,
      'isDeleted': isDeleted,
      'lastSyncedAt': lastSyncedAt,
      'syncStatus': syncStatus.toDb(),
    };
  }

  factory JobAssignmentModel.fromMap(Map<String, dynamic> map) {
    return JobAssignmentModel(
      id: map['id'] != null ? map['id'] as String : null,
      jobId: map['jobId'] as String,
      userId: map['userId'] as String,
      assignedAt: map['assignedAt'] as int,
      version: map['version'] as int,
      isDeleted: map['isDeleted'] as bool,
      lastSyncedAt: map['lastSyncedAt'] as int,
      syncStatus: SyncStatusX.fromDb(map['syncStatus'] as int),
    );
  }
}
