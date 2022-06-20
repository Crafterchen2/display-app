// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configured_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfiguredNetwork _$ConfiguredNetworkFromJson(Map<String, dynamic> json) =>
    ConfiguredNetwork(
      networkId: json['networkId'] as int,
      ssid: json['ssid'] as String,
      interface: json['interface'] as String,
      password: json['password'] as String? ?? '',
      psk: json['psk'] as String? ?? '',
      isConnected: json['isConnected'] as bool? ?? false,
    );

Map<String, dynamic> _$ConfiguredNetworkToJson(ConfiguredNetwork instance) =>
    <String, dynamic>{
      'networkId': instance.networkId,
      'ssid': instance.ssid,
      'interface': instance.interface,
      'password': instance.password,
      'psk': instance.psk,
      'isConnected': instance.isConnected,
    };
