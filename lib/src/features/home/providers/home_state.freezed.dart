// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  List<File> get photos => throw _privateConstructorUsedError;
  File? get backgroundMusic => throw _privateConstructorUsedError;
  TransitionType get transitionType => throw _privateConstructorUsedError;
  Duration get imageDuration => throw _privateConstructorUsedError;
  Duration get transitionDuration => throw _privateConstructorUsedError;
  bool get isPicking => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    List<File> photos,
    File? backgroundMusic,
    TransitionType transitionType,
    Duration imageDuration,
    Duration transitionDuration,
    bool isPicking,
  });
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photos = null,
    Object? backgroundMusic = freezed,
    Object? transitionType = null,
    Object? imageDuration = null,
    Object? transitionDuration = null,
    Object? isPicking = null,
  }) {
    return _then(
      _value.copyWith(
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<File>,
            backgroundMusic: freezed == backgroundMusic
                ? _value.backgroundMusic
                : backgroundMusic // ignore: cast_nullable_to_non_nullable
                      as File?,
            transitionType: null == transitionType
                ? _value.transitionType
                : transitionType // ignore: cast_nullable_to_non_nullable
                      as TransitionType,
            imageDuration: null == imageDuration
                ? _value.imageDuration
                : imageDuration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            transitionDuration: null == transitionDuration
                ? _value.transitionDuration
                : transitionDuration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            isPicking: null == isPicking
                ? _value.isPicking
                : isPicking // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<File> photos,
    File? backgroundMusic,
    TransitionType transitionType,
    Duration imageDuration,
    Duration transitionDuration,
    bool isPicking,
  });
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photos = null,
    Object? backgroundMusic = freezed,
    Object? transitionType = null,
    Object? imageDuration = null,
    Object? transitionDuration = null,
    Object? isPicking = null,
  }) {
    return _then(
      _$HomeStateImpl(
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<File>,
        backgroundMusic: freezed == backgroundMusic
            ? _value.backgroundMusic
            : backgroundMusic // ignore: cast_nullable_to_non_nullable
                  as File?,
        transitionType: null == transitionType
            ? _value.transitionType
            : transitionType // ignore: cast_nullable_to_non_nullable
                  as TransitionType,
        imageDuration: null == imageDuration
            ? _value.imageDuration
            : imageDuration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        transitionDuration: null == transitionDuration
            ? _value.transitionDuration
            : transitionDuration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        isPicking: null == isPicking
            ? _value.isPicking
            : isPicking // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl extends _HomeState {
  const _$HomeStateImpl({
    final List<File> photos = const [],
    this.backgroundMusic,
    this.transitionType = TransitionType.dissolve,
    this.imageDuration = const Duration(seconds: 3),
    this.transitionDuration = const Duration(seconds: 1),
    this.isPicking = false,
  }) : _photos = photos,
       super._();

  final List<File> _photos;
  @override
  @JsonKey()
  List<File> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  final File? backgroundMusic;
  @override
  @JsonKey()
  final TransitionType transitionType;
  @override
  @JsonKey()
  final Duration imageDuration;
  @override
  @JsonKey()
  final Duration transitionDuration;
  @override
  @JsonKey()
  final bool isPicking;

  @override
  String toString() {
    return 'HomeState(photos: $photos, backgroundMusic: $backgroundMusic, transitionType: $transitionType, imageDuration: $imageDuration, transitionDuration: $transitionDuration, isPicking: $isPicking)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.backgroundMusic, backgroundMusic) ||
                other.backgroundMusic == backgroundMusic) &&
            (identical(other.transitionType, transitionType) ||
                other.transitionType == transitionType) &&
            (identical(other.imageDuration, imageDuration) ||
                other.imageDuration == imageDuration) &&
            (identical(other.transitionDuration, transitionDuration) ||
                other.transitionDuration == transitionDuration) &&
            (identical(other.isPicking, isPicking) ||
                other.isPicking == isPicking));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_photos),
    backgroundMusic,
    transitionType,
    imageDuration,
    transitionDuration,
    isPicking,
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState extends HomeState {
  const factory _HomeState({
    final List<File> photos,
    final File? backgroundMusic,
    final TransitionType transitionType,
    final Duration imageDuration,
    final Duration transitionDuration,
    final bool isPicking,
  }) = _$HomeStateImpl;
  const _HomeState._() : super._();

  @override
  List<File> get photos;
  @override
  File? get backgroundMusic;
  @override
  TransitionType get transitionType;
  @override
  Duration get imageDuration;
  @override
  Duration get transitionDuration;
  @override
  bool get isPicking;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
