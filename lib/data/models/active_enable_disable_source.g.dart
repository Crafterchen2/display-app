// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_enable_disable_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveEnableDisableSource _$ActiveEnableDisableSourceFromJson(
        Map<String, dynamic> json) =>
    ActiveEnableDisableSource(
      json['priority'] as int,
      json['source'] as String,
      json['state'] as String,
    );

Map<String, dynamic> _$ActiveEnableDisableSourceToJson(
        ActiveEnableDisableSource instance) =>
    <String, dynamic>{
      'priority': instance.priority,
      'source': instance.source,
      'state': instance.state,
    };
