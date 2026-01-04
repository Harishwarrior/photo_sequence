// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaRepository)
final mediaRepositoryProvider = MediaRepositoryProvider._();

final class MediaRepositoryProvider
    extends
        $FunctionalProvider<
          IMediaRepository,
          IMediaRepository,
          IMediaRepository
        >
    with $Provider<IMediaRepository> {
  MediaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaRepositoryHash();

  @$internal
  @override
  $ProviderElement<IMediaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IMediaRepository create(Ref ref) {
    return mediaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IMediaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IMediaRepository>(value),
    );
  }
}

String _$mediaRepositoryHash() => r'a182da2fdfae2af511a4eeaf33fa7c3bceee8980';
