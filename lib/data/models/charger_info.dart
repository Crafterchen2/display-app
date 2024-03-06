// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'charger_info.g.dart';

@JsonSerializable()
class ChargerInfo {
  final String? model_name;
  final String? pcb_serial_number;
  final String? charger_serial_number;
  final String? firmware_version;
  final String? hardware_version;

  ChargerInfo(this.model_name, this.pcb_serial_number,
      this.charger_serial_number, this.firmware_version, this.hardware_version);

  factory ChargerInfo.fromJson(Map<String, dynamic> json) =>
      _$ChargerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ChargerInfoToJson(this);
}
