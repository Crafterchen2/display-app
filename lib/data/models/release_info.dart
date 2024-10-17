import 'package:json_annotation/json_annotation.dart';
import 'package:display_app/data/models/release_component.dart';

part 'release_info.g.dart';

@JsonSerializable()
class ReleaseInfo {
  final String channel;
  final DateTime datetime;
  final String version;
  final List<ReleaseComponent> components;

  ReleaseInfo(this.channel, this.datetime, this.version, this.components);

  factory ReleaseInfo.fromJson(Map<String, dynamic> json) =>
      _$ReleaseInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseInfoToJson(this);
}
