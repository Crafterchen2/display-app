import 'package:json_annotation/json_annotation.dart';

part 'configured_network.g.dart';

@JsonSerializable()
class ConfiguredNetwork {
  final int network_id;
  final String ssid;

  ConfiguredNetwork(this.network_id, this.ssid);

  factory ConfiguredNetwork.fromJson(Map<String, dynamic> json) =>
      _$ConfiguredNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$ConfiguredNetworkToJson(this);
}
