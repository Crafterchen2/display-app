// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableNetwork _$AvailableNetworkFromJson(Map<String, dynamic> json) =>
    AvailableNetwork(
      json['ssid'] as String,
      json['frequency'] as int,
      json['signal_level'] as int,
    );

Map<String, dynamic> _$AvailableNetworkToJson(AvailableNetwork instance) =>
    <String, dynamic>{
      'ssid': instance.ssid,
      'frequency': instance.frequency,
      'signal_level': instance.signal_level,
    };
