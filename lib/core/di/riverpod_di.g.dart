// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_di.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(networkService)
final networkServiceProvider = NetworkServiceProvider._();

final class NetworkServiceProvider
    extends $FunctionalProvider<NetworkService, NetworkService, NetworkService>
    with $Provider<NetworkService> {
  NetworkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkServiceHash();

  @$internal
  @override
  $ProviderElement<NetworkService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkService create(Ref ref) {
    return networkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkService>(value),
    );
  }
}

String _$networkServiceHash() => r'8bb92624e1651795641b7d99d3fc9c24f5730954';

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

@ProviderFor(authLocalRepository)
final authLocalRepositoryProvider = AuthLocalRepositoryProvider._();

final class AuthLocalRepositoryProvider
    extends
        $FunctionalProvider<
          AuthLocalRepository,
          AuthLocalRepository,
          AuthLocalRepository
        >
    with $Provider<AuthLocalRepository> {
  AuthLocalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLocalRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLocalRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthLocalRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthLocalRepository create(Ref ref) {
    return authLocalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthLocalRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthLocalRepository>(value),
    );
  }
}

String _$authLocalRepositoryHash() =>
    r'c479d1cca2d735b43077b359c1c2b51d969c5388';
