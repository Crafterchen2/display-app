// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionInfo _$SessionInfoFromJson(Map<String, dynamic> json) => SessionInfo(
      (json['charged_energy_wh'] as num).toDouble(),
      (json['charging_duration_s'] as num).toDouble(),
      DateTime.parse(json['datetime'] as String),
      (json['latest_total_w'] as num).toDouble(),
      json['state'] as String,
    );

Map<String, dynamic> _$SessionInfoToJson(SessionInfo instance) =>
    <String, dynamic>{
      'charged_energy_wh': instance.charged_energy_wh,
      'charging_duration_s': instance.charging_duration_s,
      'datetime': instance.datetime.toIso8601String(),
      'latest_total_w': instance.latest_total_w,
      'state': instance.state,
    };
