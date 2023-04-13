// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hardware_capabilities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HardwareCapabilities _$HardwareCapabilitiesFromJson(
        Map<String, dynamic> json) =>
    HardwareCapabilities(
      (json['max_current_A_export'] as num).toDouble(),
      (json['max_current_A_import'] as num).toDouble(),
      json['max_phase_count_export'] as int,
      json['max_phase_count_import'] as int,
      (json['min_current_A_export'] as num).toDouble(),
      (json['min_current_A_import'] as num).toDouble(),
      json['min_phase_count_export'] as int,
      json['min_phase_count_import'] as int,
      json['supports_changing_phases_during_charging'] as bool,
    );

Map<String, dynamic> _$HardwareCapabilitiesToJson(
        HardwareCapabilities instance) =>
    <String, dynamic>{
      'max_current_A_export': instance.max_current_A_export,
      'max_current_A_import': instance.max_current_A_import,
      'max_phase_count_export': instance.max_phase_count_export,
      'max_phase_count_import': instance.max_phase_count_import,
      'min_current_A_export': instance.min_current_A_export,
      'min_current_A_import': instance.min_current_A_import,
      'min_phase_count_export': instance.min_phase_count_export,
      'min_phase_count_import': instance.min_phase_count_import,
      'supports_changing_phases_during_charging':
          instance.supports_changing_phases_during_charging,
    };
