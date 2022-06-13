import 'package:json_annotation/json_annotation.dart';

part 'configured_network.g.dart';

@JsonSerializable()
class ConfiguredNetwork {
  final int networkId;
  final String ssid;
  final String password;
  final String psk;
  final int isConnected;

  ConfiguredNetwork(
      {required this.networkId,
      required this.ssid,
      this.password = '',
      this.psk = '',
      this.isConnected = 0});

  factory ConfiguredNetwork.fromJson(Map<String, dynamic> json) =>
      _$ConfiguredNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$ConfiguredNetworkToJson(this);
}
