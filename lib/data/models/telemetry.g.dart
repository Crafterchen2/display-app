// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Telemetry _$TelemetryFromJson(Map<String, dynamic> json) => Telemetry(
      (json['fan_rpm'] as num).toDouble(),
      (json['rcd_current'] as num).toDouble(),
      json['relais_on'] as bool,
      (json['supply_voltage_12V'] as num).toDouble(),
      (json['supply_voltage_minus_12V'] as num).toDouble(),
      (json['temperature'] as num).toDouble(),
    );

Map<String, dynamic> _$TelemetryToJson(Telemetry instance) => <String, dynamic>{
      'fan_rpm': instance.fan_rpm,
      'rcd_current': instance.rcd_current,
      'relais_on': instance.relais_on,
      'supply_voltage_12V': instance.supply_voltage_12V,
      'supply_voltage_minus_12V': instance.supply_voltage_minus_12V,
      'temperature': instance.temperature,
    };
