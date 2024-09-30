// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'telemetry.g.dart';

@JsonSerializable()
class Telemetry {
  final double fan_rpm;
  final double? rcd_current;
  final bool? relais_on;
  final double supply_voltage_12V;
  final double supply_voltage_minus_12V;
  final double temperature;

  Telemetry(this.fan_rpm, this.rcd_current, this.relais_on,
      this.supply_voltage_12V, this.supply_voltage_minus_12V, this.temperature);

  factory Telemetry.fromJson(Map<String, dynamic> json) =>
      _$TelemetryFromJson(json);

  Map<String, dynamic> toJson() => _$TelemetryToJson(this);
}
