// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for export screen state management.

@ProviderFor(ExportNotifier)
final exportProvider = ExportNotifierProvider._();

/// Provider for export screen state management.
final class ExportNotifierProvider
    extends $NotifierProvider<ExportNotifier, ExportScreenState> {
  /// Provider for export screen state management.
  ExportNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportNotifierHash();

  @$internal
  @override
  ExportNotifier create() => ExportNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportScreenState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportScreenState>(value),
    );
  }
}

String _$exportNotifierHash() => r'3f0efc9634487e2ef47a69bf4252515ee136a5a8';

/// Provider for export screen state management.

abstract class _$ExportNotifier extends $Notifier<ExportScreenState> {
  ExportScreenState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExportScreenState, ExportScreenState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportScreenState, ExportScreenState>,
              ExportScreenState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
