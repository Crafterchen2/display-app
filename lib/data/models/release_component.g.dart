// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_component.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseComponent _$ReleaseComponentFromJson(Map<String, dynamic> json) =>
    ReleaseComponent(
      json['name'] as String,
      json['version'] as String,
      json['description'] as String,
      json['license'] as String,
    );

Map<String, dynamic> _$ReleaseComponentToJson(ReleaseComponent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'description': instance.description,
      'license': instance.license,
    };
