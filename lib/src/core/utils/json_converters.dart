import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

/// A converter that handles [File] objects for [json_serializable].
class FileConverter implements JsonConverter<File, String> {
  const FileConverter();

  @override
  File fromJson(String json) => File(json);

  @override
  String toJson(File file) => file.path;
}

/// A converter that handles nullable [File] objects for [json_serializable].
class NullableFileConverter implements JsonConverter<File?, String?> {
  const NullableFileConverter();

  @override
  File? fromJson(String? json) => json != null ? File(json) : null;

  @override
  String? toJson(File? file) => file?.path;
}
