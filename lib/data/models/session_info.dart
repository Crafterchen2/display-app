import 'package:json_annotation/json_annotation.dart';

part 'session_info.g.dart';

@JsonSerializable()
class SessionInfo {
  final double charged_energy_wh;
  final double charging_duration_s;
  final DateTime datetime;
  final double latest_total_w;
  final String state;

  SessionInfo(this.charged_energy_wh, this.charging_duration_s, this.datetime,
      this.latest_total_w, this.state);

  factory SessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionInfoToJson(this);
}
