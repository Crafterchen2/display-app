// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charger_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargerInfo _$ChargerInfoFromJson(Map<String, dynamic> json) => ChargerInfo(
      ChargerModel.fromString(json['model_name'] as String?),
      json['pcb_serial_number'] as String?,
      json['charger_serial_number'] as String?,
      json['firmware_version'] as String?,
      json['hardware_version'] as String?,
    );

Map<String, dynamic> _$ChargerInfoToJson(ChargerInfo instance) =>
    <String, dynamic>{
      'model_name': instance.model_name,
      'pcb_serial_number': instance.pcb_serial_number,
      'charger_serial_number': instance.charger_serial_number,
      'firmware_version': instance.firmware_version,
      'hardware_version': instance.hardware_version,
    };
