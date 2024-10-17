// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'active_enable_disable_source.g.dart';

@JsonSerializable()
class ActiveEnableDisableSource {
  final int priority;
  final String source;
  final String state;

  ActiveEnableDisableSource(this.priority, this.source, this.state);

  factory ActiveEnableDisableSource.fromJson(Map<String, dynamic> json) =>
      _$ActiveEnableDisableSourceFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveEnableDisableSourceToJson(this);
}
