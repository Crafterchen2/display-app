// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configured_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfiguredNetwork _$ConfiguredNetworkFromJson(Map<String, dynamic> json) =>
    ConfiguredNetwork(
      json['network_id'] as int,
      json['ssid'] as String,
    );

Map<String, dynamic> _$ConfiguredNetworkToJson(ConfiguredNetwork instance) =>
    <String, dynamic>{
      'network_id': instance.network_id,
      'ssid': instance.ssid,
    };
