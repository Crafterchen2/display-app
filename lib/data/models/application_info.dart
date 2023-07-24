// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'application_info.g.dart';

@JsonSerializable()
class ApplicationInfo {
  final String current_language;
  final String default_language;
  final bool initialized;
  final String mode;
  final String? release_metadata_file;

  ApplicationInfo(this.current_language, this.default_language,
      this.initialized, this.mode, this.release_metadata_file);

  factory ApplicationInfo.fromJson(Map<String, dynamic> json) =>
      _$ApplicationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationInfoToJson(this);
}
