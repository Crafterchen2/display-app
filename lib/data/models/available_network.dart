// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'available_network.g.dart';

@JsonSerializable()
class AvailableNetwork {
  final String ssid;
  final int frequency;
  final int signal_level;

  AvailableNetwork(this.ssid, this.frequency, this.signal_level);

  factory AvailableNetwork.fromJson(Map<String, dynamic> json) =>
      _$AvailableNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableNetworkToJson(this);
}
