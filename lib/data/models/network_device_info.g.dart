// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

List<String> parseIp(dynamic ip) {
  if (ip is String) {
    return [ip];
  } else if (ip is List<dynamic>) {
    return ip.map((e) => e as String).toList();
  }
  return [];
}

NetworkDeviceInfo _$NetworkDeviceInfoFromJson(Map<String, dynamic> json) =>
    NetworkDeviceInfo(
      interface: json['interface'] as String,
      ipv4: parseIp(json['ipv4']),
      blocked: json['blocked'] as bool,
      wireless: json['wireless'] as bool,
      ipv6: parseIp(json['ipv6']),
      rfkill_id: json['rfkill_id'] as String? ?? "",
      mac: json['mac'] as String? ?? "",
    );

Map<String, dynamic> _$NetworkDeviceInfoToJson(NetworkDeviceInfo instance) =>
    <String, dynamic>{
      'interface': instance.interface,
      'ipv4': instance.ipv4,
      'blocked': instance.blocked,
      'wireless': instance.wireless,
      'ipv6': instance.ipv6,
      'rfkill_id': instance.rfkill_id,
      'mac': instance.mac,
    };
