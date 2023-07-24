// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'ev_info.g.dart';

@JsonSerializable()
class EvInfo {
  final double? soc;
  final double? present_voltage;
  final double? present_current;
  final double? target_voltage;
  final double? target_current;
  final double? maximum_current_limit;
  final double? minimum_current_limit;
  final double? maximum_voltage_limit;
  final double? maximum_power_limit;
  final String? estimated_time_full;
  final String? departure_time;
  final String? estimated_time_bulk;
  final String? evcc_id;
  final double? remaining_energy_needed;
  final double? battery_capacity;
  final double? battery_full_soc;
  final double? battery_bulk_soc;

  EvInfo(
      this.soc,
      this.present_voltage,
      this.present_current,
      this.target_voltage,
      this.target_current,
      this.maximum_current_limit,
      this.minimum_current_limit,
      this.maximum_voltage_limit,
      this.maximum_power_limit,
      this.estimated_time_full,
      this.departure_time,
      this.estimated_time_bulk,
      this.evcc_id,
      this.remaining_energy_needed,
      this.battery_capacity,
      this.battery_full_soc,
      this.battery_bulk_soc);

  factory EvInfo.fromJson(Map<String, dynamic> json) => _$EvInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EvInfoToJson(this);
}
