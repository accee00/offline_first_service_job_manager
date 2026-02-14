enum SyncStatus { clean, dirty, syncing, error }

extension SyncStatusX on SyncStatus {
  int toDb() => index;

  static SyncStatus fromDb(int value) {
    if (value < 0 || value >= SyncStatus.values.length) {
      return SyncStatus.error;
    }
    return SyncStatus.values[value];
  }

  String get displayName {
    switch (this) {
      case SyncStatus.clean:
        return "Clean";
      case SyncStatus.dirty:
        return "Dirty";
      case SyncStatus.syncing:
        return "Syncing";
      case SyncStatus.error:
        return "Error";
    }
  }
}
