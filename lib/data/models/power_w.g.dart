// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_w.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PowerW _$PowerWFromJson(Map<String, dynamic> json) => PowerW(
      (json['L1'] as num).toDouble(),
      (json['L2'] as num).toDouble(),
      (json['L3'] as num).toDouble(),
      (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$PowerWToJson(PowerW instance) => <String, dynamic>{
      'L1': instance.L1,
      'L2': instance.L2,
      'L3': instance.L3,
      'total': instance.total,
    };
