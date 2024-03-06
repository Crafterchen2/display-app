// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionInfo _$SessionInfoFromJson(Map<String, dynamic> json) => SessionInfo(
      (json['charged_energy_wh'] as num).toInt(),
      (json['discharged_energy_wh'] as num).toInt(),
      (json['charging_duration_s'] as num).toInt(),
      DateTime.parse(json['datetime'] as String),
      (json['latest_total_w'] as num).toInt(),
      json['state'] as String,
      (json['active_permanent_faults'] as List<dynamic>)
          .map((e) => Error.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['active_errors'] as List<dynamic>)
          .map((e) => Error.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SessionInfoToJson(SessionInfo instance) =>
    <String, dynamic>{
      'charged_energy_wh': instance.charged_energy_wh,
      'discharged_energy_wh': instance.discharged_energy_wh,
      'charging_duration_s': instance.charging_duration_s,
      'datetime': instance.datetime.toIso8601String(),
      'latest_total_w': instance.latest_total_w,
      'state': instance.state,
      'active_permanent_faults': instance.active_permanent_faults,
      'active_errors': instance.active_errors,
    };
