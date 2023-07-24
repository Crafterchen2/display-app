// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frequency_hz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrequencyHz _$FrequencyHzFromJson(Map<String, dynamic> json) => FrequencyHz(
      (json['L1'] as num).toDouble(),
      (json['L2'] as num?)?.toDouble(),
      (json['L3'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FrequencyHzToJson(FrequencyHz instance) =>
    <String, dynamic>{
      'L1': instance.L1,
      'L2': instance.L2,
      'L3': instance.L3,
    };
