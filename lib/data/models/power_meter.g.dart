// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_meter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

num parseTimestamp(dynamic timestamp) {
  if (timestamp is num) {
    return timestamp;
  } else if (timestamp is String) {
    return DateTime.parse(timestamp).millisecondsSinceEpoch / 1000;
  } else {
    return DateTime.now().millisecondsSinceEpoch / 1000;
  }
}

PowerMeter _$PowerMeterFromJson(Map<String, dynamic> json) => PowerMeter(
      json['current_A'] == null
          ? null
          : CurrentA.fromJson(json['current_A'] as Map<String, dynamic>),
      json['meter_id'] as String?,
      json['phase_seq_error'] as bool?,
      parseTimestamp(json['timestamp']).toDouble(),
      EnergyWhImport.fromJson(json['energy_Wh_import'] as Map<String, dynamic>),
      json['frequency_Hz'] == null
          ? null
          : FrequencyHz.fromJson(json['frequency_Hz'] as Map<String, dynamic>),
      json['power_W'] == null
          ? null
          : PowerW.fromJson(json['power_W'] as Map<String, dynamic>),
      json['voltage_V'] == null
          ? null
          : VoltageV.fromJson(json['voltage_V'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PowerMeterToJson(PowerMeter instance) =>
    <String, dynamic>{
      'meter_id': instance.meter_id,
      'phase_seq_error': instance.phase_seq_error,
      'timestamp': instance.timestamp,
      'current_A': instance.current_A,
      'energy_Wh_import': instance.energy_Wh_import,
      'frequency_Hz': instance.frequency_Hz,
      'power_W': instance.power_W,
      'voltage_V': instance.voltage_V,
    };
