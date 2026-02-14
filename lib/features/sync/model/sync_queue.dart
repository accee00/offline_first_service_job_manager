enum EntityType { user, jobs, assignment }

extension EntityTypeX on EntityType {
  String toDb() => name;

  static EntityType fromDb(String value) =>
      EntityType.values.firstWhere((e) => e.name == value);
}

enum Operations { create, update, delete }

extension OperationsX on Operations {
  String toDb() => name;

  static Operations fromDb(String value) =>
      Operations.values.firstWhere((e) => e.name == value);
}

class SyncQueue {
  final String? id;
  final EntityType entityType;
  final String entityId;
  final Operations operations;
  final int retryCount;
  final int lastAttemptAt;
  final String errorMsg;
  SyncQueue({
    this.id,
    required this.entityType,
    required this.entityId,
    required this.operations,
    required this.retryCount,
    required this.lastAttemptAt,
    required this.errorMsg,
  });

  SyncQueue copyWith({
    String? id,
    EntityType? entityType,
    String? entityId,
    Operations? operations,
    int? retryCount,
    int? lastAttemptAt,
    String? errorMsg,
  }) {
    return SyncQueue(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operations: operations ?? this.operations,
      retryCount: retryCount ?? this.retryCount,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'entityType': entityType.toDb(),
      'entityId': entityId,
      'operations': operations.toDb(),
      'retryCount': retryCount,
      'lastAttemptAt': lastAttemptAt,
      'errorMsg': errorMsg,
    };
  }

  factory SyncQueue.fromMap(Map<String, dynamic> map) {
    return SyncQueue(
      id: map['id'] != null ? map['id'] as String : null,
      entityType: EntityTypeX.fromDb(map['entityType'] as String),
      entityId: map['entityId'] as String,
      operations: OperationsX.fromDb(map['operations'] as String),
      retryCount: map['retryCount'] as int,
      lastAttemptAt: map['lastAttemptAt'] as int,
      errorMsg: map['errorMsg'] as String,
    );
  }
}
