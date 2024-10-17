// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:display_app/data/models/energy_wh_import.dart';
import 'package:display_app/data/models/frequency_hz.dart';
import 'package:display_app/data/models/power_w.dart';
import 'package:display_app/data/models/voltage_v.dart';

import 'current_a.dart';

part 'power_meter.g.dart';

@JsonSerializable()
class PowerMeter {
  final String? meter_id;
  final bool? phase_seq_error;
  final double timestamp;
  final CurrentA? current_A;
  final EnergyWhImport energy_Wh_import;
  final FrequencyHz? frequency_Hz;
  final PowerW? power_W;
  final VoltageV? voltage_V;

  PowerMeter(
      this.current_A,
      this.meter_id,
      this.phase_seq_error,
      this.timestamp,
      this.energy_Wh_import,
      this.frequency_Hz,
      this.power_W,
      this.voltage_V);

  factory PowerMeter.fromJson(Map<String, dynamic> json) =>
      _$PowerMeterFromJson(json);

  Map<String, dynamic> toJson() => _$PowerMeterToJson(this);
}
