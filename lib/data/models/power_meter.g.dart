// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_meter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PowerMeter _$PowerMeterFromJson(Map<String, dynamic> json) => PowerMeter(
      CurrentA.fromJson(json['current_A'] as Map<String, dynamic>),
      json['meter_id'] as String,
      json['phase_seq_error'] as bool,
      (json['timestamp'] as num).toDouble(),
      EnergyWhImport.fromJson(json['energy_Wh_import'] as Map<String, dynamic>),
      FrequencyHz.fromJson(json['frequency_Hz'] as Map<String, dynamic>),
      PowerW.fromJson(json['power_W'] as Map<String, dynamic>),
      VoltageV.fromJson(json['voltage_V'] as Map<String, dynamic>),
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
