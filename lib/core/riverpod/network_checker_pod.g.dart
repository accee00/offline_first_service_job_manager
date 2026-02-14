// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_checker_pod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(networkStatus)
final networkStatusProvider = NetworkStatusProvider._();

final class NetworkStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<NetworkStatus>,
          NetworkStatus,
          Stream<NetworkStatus>
        >
    with $FutureModifier<NetworkStatus>, $StreamProvider<NetworkStatus> {
  NetworkStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkStatusHash();

  @$internal
  @override
  $StreamProviderElement<NetworkStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<NetworkStatus> create(Ref ref) {
    return networkStatus(ref);
  }
}

String _$networkStatusHash() => r'd3b3ca7448a896dd2b2725d374c702b0e8027578';
