// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppSyncStatus)
final appSyncStatusProvider = AppSyncStatusProvider._();

final class AppSyncStatusProvider
    extends $NotifierProvider<AppSyncStatus, SyncStatusState> {
  AppSyncStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSyncStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSyncStatusHash();

  @$internal
  @override
  AppSyncStatus create() => AppSyncStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStatusState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStatusState>(value),
    );
  }
}

String _$appSyncStatusHash() => r'75300d8e87750e3e75e7ce4be16adab65a024059';

abstract class _$AppSyncStatus extends $Notifier<SyncStatusState> {
  SyncStatusState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncStatusState, SyncStatusState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatusState, SyncStatusState>,
              SyncStatusState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
