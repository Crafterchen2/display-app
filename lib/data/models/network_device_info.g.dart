// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkDeviceInfo _$NetworkDeviceInfoFromJson(Map<String, dynamic> json) =>
    NetworkDeviceInfo(
      json['interface'] as String,
      json['ipv4'] as String,
    );

Map<String, dynamic> _$NetworkDeviceInfoToJson(NetworkDeviceInfo instance) =>
    <String, dynamic>{
      'interface': instance.interface,
      'ipv4': instance.ipv4,
    };
