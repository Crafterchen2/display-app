// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'energy_wh_import.g.dart';

@JsonSerializable()
class EnergyWhImport {
  final double? L1;
  final double? L2;
  final double? L3;
  final double total;

  EnergyWhImport(this.L1, this.L2, this.L3, this.total);

  factory EnergyWhImport.fromJson(Map<String, dynamic> json) =>
      _$EnergyWhImportFromJson(json);

  Map<String, dynamic> toJson() => _$EnergyWhImportToJson(this);
}
