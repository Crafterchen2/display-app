// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'hardware_capabilities.g.dart';

@JsonSerializable()
class HardwareCapabilities {
  final double max_current_A_export;
  final double max_current_A_import;
  final int max_phase_count_export;
  final int max_phase_count_import;
  final double min_current_A_export;
  final double min_current_A_import;
  final int min_phase_count_export;
  final int min_phase_count_import;
  final bool supports_changing_phases_during_charging;

  HardwareCapabilities(
      this.max_current_A_export,
      this.max_current_A_import,
      this.max_phase_count_export,
      this.max_phase_count_import,
      this.min_current_A_export,
      this.min_current_A_import,
      this.min_phase_count_export,
      this.min_phase_count_import,
      this.supports_changing_phases_during_charging);

  factory HardwareCapabilities.fromJson(Map<String, dynamic> json) =>
      _$HardwareCapabilitiesFromJson(json);

  Map<String, dynamic> toJson() => _$HardwareCapabilitiesToJson(this);
}
