// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkDeviceInfo _$NetworkDeviceInfoFromJson(Map<String, dynamic> json) =>
    NetworkDeviceInfo(
      interface: json['interface'] as String,
      ipv4: json['ipv4'] as String? ?? "",
      blocked: json['blocked'] as bool,
      wireless: json['wireless'] as bool,
      ipv6: json['ipv6'] as String? ?? "",
      rfkill_id: json['rfkill_id'] as String? ?? "",
    );

Map<String, dynamic> _$NetworkDeviceInfoToJson(NetworkDeviceInfo instance) =>
    <String, dynamic>{
      'interface': instance.interface,
      'ipv4': instance.ipv4,
      'blocked': instance.blocked,
      'wireless': instance.wireless,
      'ipv6': instance.ipv6,
      'rfkill_id': instance.rfkill_id,
    };
