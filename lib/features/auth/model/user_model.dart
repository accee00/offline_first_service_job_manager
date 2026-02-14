import 'package:offline_first_service_job_manager/core/enums/sync_enum.dart';

enum Role { admin, manager, worker }

extension RoleX on Role {
  String toDb() => name;

  static Role fromDb(String value) =>
      Role.values.firstWhere((e) => e.name == value);

  String get displayName {
    switch (this) {
      case Role.admin:
        return "Admin";
      case Role.manager:
        return "Manager";
      case Role.worker:
        return "Worker";
    }
  }
}

class UserModel {
  final String? id;
  final String email;
  final String name;
  final Role role;
  final int? createdAt;
  final int? updatedAt;
  final int version;
  final int? lastSyncedAt;
  final SyncStatus syncStatus;

  UserModel({
    this.id,
    required this.email,
    required this.name,
    required this.role,
    this.createdAt,
    this.updatedAt,
    required this.version,
    this.lastSyncedAt,
    required this.syncStatus,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    Role? role,
    int? createdAt,
    int? updatedAt,
    int? version,
    int? lastSyncedAt,
    SyncStatus? syncStatus,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toDb(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'version': version,
      'last_synced_at': lastSyncedAt,
      'sync_status': syncStatus.toDb(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      email: map['email'] as String,
      name: map['name'] as String,
      role: RoleX.fromDb(map['role'] as String),
      createdAt: map['created_at'] as int?,
      updatedAt: map['updated_at'] as int?,
      version: map['version'] as int? ?? 0,
      lastSyncedAt: map['last_synced_at'] as int?,
      syncStatus: SyncStatusX.fromDb(map['sync_status'] as int),
    );
  }
}
