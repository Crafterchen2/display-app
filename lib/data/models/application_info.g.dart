// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationInfo _$ApplicationInfoFromJson(Map<String, dynamic> json) =>
    ApplicationInfo(
      json['current_language'] as String,
      json['default_language'] as String,
      json['initialized'] as bool,
      json['mode'] as String,
    );

Map<String, dynamic> _$ApplicationInfoToJson(ApplicationInfo instance) =>
    <String, dynamic>{
      'current_language': instance.current_language,
      'default_language': instance.default_language,
      'initialized': instance.initialized,
      'mode': instance.mode,
    };
