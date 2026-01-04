// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ExportScreenState {
  double get progress => throw _privateConstructorUsedError;
  ExportState get state => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ExportScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExportScreenStateCopyWith<ExportScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExportScreenStateCopyWith<$Res> {
  factory $ExportScreenStateCopyWith(
    ExportScreenState value,
    $Res Function(ExportScreenState) then,
  ) = _$ExportScreenStateCopyWithImpl<$Res, ExportScreenState>;
  @useResult
  $Res call({double progress, ExportState state, String? errorMessage});
}

/// @nodoc
class _$ExportScreenStateCopyWithImpl<$Res, $Val extends ExportScreenState>
    implements $ExportScreenStateCopyWith<$Res> {
  _$ExportScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExportScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? state = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as ExportState,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExportScreenStateImplCopyWith<$Res>
    implements $ExportScreenStateCopyWith<$Res> {
  factory _$$ExportScreenStateImplCopyWith(
    _$ExportScreenStateImpl value,
    $Res Function(_$ExportScreenStateImpl) then,
  ) = __$$ExportScreenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double progress, ExportState state, String? errorMessage});
}

/// @nodoc
class __$$ExportScreenStateImplCopyWithImpl<$Res>
    extends _$ExportScreenStateCopyWithImpl<$Res, _$ExportScreenStateImpl>
    implements _$$ExportScreenStateImplCopyWith<$Res> {
  __$$ExportScreenStateImplCopyWithImpl(
    _$ExportScreenStateImpl _value,
    $Res Function(_$ExportScreenStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExportScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? state = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$ExportScreenStateImpl(
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as ExportState,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ExportScreenStateImpl implements _ExportScreenState {
  const _$ExportScreenStateImpl({
    this.progress = 0.0,
    this.state = ExportState.idle,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final double progress;
  @override
  @JsonKey()
  final ExportState state;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ExportScreenState(progress: $progress, state: $state, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExportScreenStateImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress, state, errorMessage);

  /// Create a copy of ExportScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExportScreenStateImplCopyWith<_$ExportScreenStateImpl> get copyWith =>
      __$$ExportScreenStateImplCopyWithImpl<_$ExportScreenStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ExportScreenState implements ExportScreenState {
  const factory _ExportScreenState({
    final double progress,
    final ExportState state,
    final String? errorMessage,
  }) = _$ExportScreenStateImpl;

  @override
  double get progress;
  @override
  ExportState get state;
  @override
  String? get errorMessage;

  /// Create a copy of ExportScreenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExportScreenStateImplCopyWith<_$ExportScreenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
