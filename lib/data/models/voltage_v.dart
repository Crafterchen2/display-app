// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'voltage_v.g.dart';

@JsonSerializable()
class VoltageV {
  final double? DC;
  final double? L1;
  final double? L2;
  final double? L3;

  VoltageV(this.DC, this.L1, this.L2, this.L3);

  factory VoltageV.fromJson(Map<String, dynamic> json) =>
      _$VoltageVFromJson(json);

  Map<String, dynamic> toJson() => _$VoltageVToJson(this);
}
