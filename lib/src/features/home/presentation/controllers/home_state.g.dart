// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeState _$HomeStateFromJson(Map<String, dynamic> json) => HomeState(
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => const FileConverter().fromJson(e as String))
          .toList() ??
      const [],
  backgroundMusic: const NullableFileConverter().fromJson(
    json['backgroundMusic'] as String?,
  ),
  transitionType:
      $enumDecodeNullable(_$TransitionTypeEnumMap, json['transitionType']) ??
      TransitionType.dissolve,
  imageDuration: json['imageDuration'] == null
      ? const Duration(seconds: 3)
      : Duration(microseconds: (json['imageDuration'] as num).toInt()),
  transitionDuration: json['transitionDuration'] == null
      ? const Duration(seconds: 1)
      : Duration(microseconds: (json['transitionDuration'] as num).toInt()),
  isPicking: json['isPicking'] as bool? ?? false,
);

Map<String, dynamic> _$HomeStateToJson(HomeState instance) => <String, dynamic>{
  'photos': instance.photos.map(const FileConverter().toJson).toList(),
  'backgroundMusic': const NullableFileConverter().toJson(
    instance.backgroundMusic,
  ),
  'transitionType': _$TransitionTypeEnumMap[instance.transitionType]!,
  'imageDuration': instance.imageDuration.inMicroseconds,
  'transitionDuration': instance.transitionDuration.inMicroseconds,
  'isPicking': instance.isPicking,
};

const _$TransitionTypeEnumMap = {
  TransitionType.dissolve: 'dissolve',
  TransitionType.slideLeft: 'slideLeft',
  TransitionType.slideRight: 'slideRight',
  TransitionType.slideUp: 'slideUp',
  TransitionType.slideDown: 'slideDown',
};
