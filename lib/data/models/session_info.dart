// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:pionixbox/data/models/error.dart';

part 'session_info.g.dart';

@JsonSerializable()
class SessionInfo {
  final int charged_energy_wh;
  final int discharged_energy_wh;
  final int charging_duration_s;
  final DateTime datetime;
  final int latest_total_w;
  final String state;
  final List<Error> active_permanent_faults;
  final List<Error> active_errors;

  SessionInfo(
      this.charged_energy_wh,
      this.discharged_energy_wh,
      this.charging_duration_s,
      this.datetime,
      this.latest_total_w,
      this.state,
      this.active_permanent_faults,
      this.active_errors);

  factory SessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionInfoToJson(this);
}
