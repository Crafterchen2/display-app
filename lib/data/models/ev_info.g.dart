// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ev_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EvInfo _$EvInfoFromJson(Map<String, dynamic> json) => EvInfo(
      (json['soc'] as num?)?.toDouble(),
      (json['present_voltage'] as num?)?.toDouble(),
      (json['present_current'] as num?)?.toDouble(),
      (json['target_voltage'] as num?)?.toDouble(),
      (json['target_current'] as num?)?.toDouble(),
      (json['maximum_current_limit'] as num?)?.toDouble(),
      (json['minimum_current_limit'] as num?)?.toDouble(),
      (json['maximum_voltage_limit'] as num?)?.toDouble(),
      (json['maximum_power_limit'] as num?)?.toDouble(),
      json['estimated_time_full'] as String?,
      json['departure_time'] as String?,
      json['estimated_time_bulk'] as String?,
      json['evcc_id'] as String?,
      (json['remaining_energy_needed'] as num?)?.toDouble(),
      (json['battery_capacity'] as num?)?.toDouble(),
      (json['battery_full_soc'] as num?)?.toDouble(),
      (json['battery_bulk_soc'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$EvInfoToJson(EvInfo instance) => <String, dynamic>{
      'soc': instance.soc,
      'present_voltage': instance.present_voltage,
      'present_current': instance.present_current,
      'target_voltage': instance.target_voltage,
      'target_current': instance.target_current,
      'maximum_current_limit': instance.maximum_current_limit,
      'minimum_current_limit': instance.minimum_current_limit,
      'maximum_voltage_limit': instance.maximum_voltage_limit,
      'maximum_power_limit': instance.maximum_power_limit,
      'estimated_time_full': instance.estimated_time_full,
      'departure_time': instance.departure_time,
      'estimated_time_bulk': instance.estimated_time_bulk,
      'evcc_id': instance.evcc_id,
      'remaining_energy_needed': instance.remaining_energy_needed,
      'battery_capacity': instance.battery_capacity,
      'battery_full_soc': instance.battery_full_soc,
      'battery_bulk_soc': instance.battery_bulk_soc,
    };
