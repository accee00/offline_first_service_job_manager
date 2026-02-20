import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_status_provider.g.dart';

class SyncStatusState {
  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final String? lastError;

  SyncStatusState({this.isSyncing = false, this.lastSyncedAt, this.lastError});

  SyncStatusState copyWith({
    bool? isSyncing,
    DateTime? lastSyncedAt,
    String? lastError,
  }) {
    return SyncStatusState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastError: lastError ?? this.lastError,
    );
  }
}

@Riverpod(keepAlive: true)
class AppSyncStatus extends _$AppSyncStatus {
  @override
  SyncStatusState build() => SyncStatusState();

  void setSyncing(bool syncing) {
    state = state.copyWith(isSyncing: syncing);
  }

  void setLastSynced(DateTime time) {
    state = state.copyWith(lastSyncedAt: time, lastError: null);
  }

  void setError(String error) {
    state = state.copyWith(lastError: error, isSyncing: false);
  }
}
