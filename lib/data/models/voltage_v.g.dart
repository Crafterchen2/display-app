// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voltage_v.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoltageV _$VoltageVFromJson(Map<String, dynamic> json) => VoltageV(
      (json['L1'] as num).toDouble(),
      (json['L2'] as num).toDouble(),
      (json['L3'] as num).toDouble(),
    );

Map<String, dynamic> _$VoltageVToJson(VoltageV instance) => <String, dynamic>{
      'L1': instance.L1,
      'L2': instance.L2,
      'L3': instance.L3,
    };
