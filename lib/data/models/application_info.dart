import 'package:json_annotation/json_annotation.dart';

part 'application_info.g.dart';

@JsonSerializable()
class ApplicationInfo {
  final String current_language;
  final String default_language;
  final bool initialized;
  final String mode;

  ApplicationInfo(this.current_language, this.default_language, this.initialized, this.mode);

  factory ApplicationInfo.fromJson(Map<String, dynamic> json) =>
      _$ApplicationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationInfoToJson(this);
}
