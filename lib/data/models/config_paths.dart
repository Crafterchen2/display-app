// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'config_paths.g.dart';

@JsonSerializable()
class ConfigPaths {
  final List<String> configs;
  final Map<String, List<String>> config_dirs;

  ConfigPaths(this.configs, this.config_dirs);

  factory ConfigPaths.fromJson(Map<String, dynamic> json) =>
      _$ConfigPathsFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigPathsToJson(this);
}
