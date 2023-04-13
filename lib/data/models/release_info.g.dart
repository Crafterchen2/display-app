// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseInfo _$ReleaseInfoFromJson(Map<String, dynamic> json) => ReleaseInfo(
      json['channel'] as String,
      DateTime.parse(json['datetime'] as String),
      json['version'] as String,
      (json['components'] as List<dynamic>)
          .map((e) => ReleaseComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReleaseInfoToJson(ReleaseInfo instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'datetime': instance.datetime.toIso8601String(),
      'version': instance.version,
      'components': instance.components,
    };
