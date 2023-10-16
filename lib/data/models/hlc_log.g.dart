// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hlc_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HlcLog _$HlcLogFromJson(Map<String, dynamic> json) => HlcLog(
      json['origin'] as String,
      json['target'] as String,
      json['iso15118'] as bool,
      json['msg'] as String,
    );

Map<String, dynamic> _$HlcLogToJson(HlcLog instance) => <String, dynamic>{
      'origin': instance.origin,
      'target': instance.target,
      'iso15118': instance.iso15118,
      'msg': instance.msg,
    };
