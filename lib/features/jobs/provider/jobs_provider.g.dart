// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JobsNotifier)
final jobsProvider = JobsNotifierProvider._();

final class JobsNotifierProvider
    extends $AsyncNotifierProvider<JobsNotifier, List<JobModel>> {
  JobsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobsNotifierHash();

  @$internal
  @override
  JobsNotifier create() => JobsNotifier();
}

String _$jobsNotifierHash() => r'b1c806ab50ae5cb5c7a601da86ec7818f4632925';

abstract class _$JobsNotifier extends $AsyncNotifier<List<JobModel>> {
  FutureOr<List<JobModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<JobModel>>, List<JobModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<JobModel>>, List<JobModel>>,
              AsyncValue<List<JobModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
