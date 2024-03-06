// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_paths.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigPaths _$ConfigPathsFromJson(Map<String, dynamic> json) => ConfigPaths(
      (json['configs'] as List<dynamic>).map((e) => e as String).toList(),
      (json['config_dirs'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$ConfigPathsToJson(ConfigPaths instance) =>
    <String, dynamic>{
      'configs': instance.configs,
      'config_dirs': instance.config_dirs,
    };
