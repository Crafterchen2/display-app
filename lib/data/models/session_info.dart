import 'package:json_annotation/json_annotation.dart';

part 'session_info.g.dart';

@JsonSerializable()
class SessionInfo {
  final int charged_energy_wh;
  final int charging_duration_s;
  final DateTime datetime;
  final int latest_total_w;
  final String state;
  final String state_info;

  SessionInfo(this.charged_energy_wh, this.charging_duration_s, this.datetime,
      this.latest_total_w, this.state, this.state_info);

  factory SessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionInfoToJson(this);
}
