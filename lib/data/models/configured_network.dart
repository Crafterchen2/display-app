import 'package:json_annotation/json_annotation.dart';

part 'configured_network.g.dart';

@JsonSerializable()
class ConfiguredNetwork {
  final int networkId;
  final String ssid;
  final String interface;
  final String password;
  final String psk;
  final bool isConnected;

  ConfiguredNetwork(
      {required this.networkId,
      required this.ssid,
      required this.interface,
      this.password = '',
      this.psk = '',
      this.isConnected = false});

  factory ConfiguredNetwork.fromJson(Map<String, dynamic> json) =>
      _$ConfiguredNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$ConfiguredNetworkToJson(this);
}
