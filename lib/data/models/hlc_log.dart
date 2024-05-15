// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'hlc_log.g.dart';

@JsonSerializable()
class HlcLog {
  final String origin;
  final String target;
  final bool iso15118;
  final String msg;

  HlcLog(this.origin, this.target, this.iso15118, this.msg);

  factory HlcLog.fromJson(Map<String, dynamic> json) => _$HlcLogFromJson(json);

  Map<String, dynamic> toJson() => _$HlcLogToJson(this);
}
