// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Limits _$LimitsFromJson(Map<String, dynamic> json) => Limits(
      (json['max_current'] as num).toDouble(),
      json['nr_of_phases_available'] as int,
      json['uuid'] as String?,
    );

Map<String, dynamic> _$LimitsToJson(Limits instance) => <String, dynamic>{
      'max_current': instance.max_current,
      'nr_of_phases_available': instance.nr_of_phases_available,
      'uuid': instance.uuid,
    };
