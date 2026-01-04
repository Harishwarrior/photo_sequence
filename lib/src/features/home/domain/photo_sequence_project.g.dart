// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_sequence_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoSequenceProject _$PhotoSequenceProjectFromJson(
  Map<String, dynamic> json,
) => PhotoSequenceProject(
  photos: (json['photos'] as List<dynamic>)
      .map((e) => const FileConverter().fromJson(e as String))
      .toList(),
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
  exportSettings: json['exportSettings'] == null
      ? ExportSettings.hd720
      : ExportSettings.fromJson(json['exportSettings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PhotoSequenceProjectToJson(
  PhotoSequenceProject instance,
) => <String, dynamic>{
  'photos': instance.photos.map(const FileConverter().toJson).toList(),
  'backgroundMusic': const NullableFileConverter().toJson(
    instance.backgroundMusic,
  ),
  'transitionType': _$TransitionTypeEnumMap[instance.transitionType]!,
  'imageDuration': instance.imageDuration.inMicroseconds,
  'transitionDuration': instance.transitionDuration.inMicroseconds,
  'exportSettings': instance.exportSettings,
};

const _$TransitionTypeEnumMap = {
  TransitionType.dissolve: 'dissolve',
  TransitionType.slideLeft: 'slideLeft',
  TransitionType.slideRight: 'slideRight',
  TransitionType.slideUp: 'slideUp',
  TransitionType.slideDown: 'slideDown',
};
