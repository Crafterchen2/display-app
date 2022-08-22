import 'package:json_annotation/json_annotation.dart';

part 'network_device_info.g.dart';

@JsonSerializable()
class NetworkDeviceInfo {
  final String interface;
  final String ipv4;
  final bool blocked;
  final bool wireless;
  final String ipv6;
  final String rfkill_id;

  NetworkDeviceInfo({required this.interface, this.ipv4 = "", required this.blocked, required this.wireless, this.ipv6 = "", this.rfkill_id = ""});

  factory NetworkDeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkDeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkDeviceInfoToJson(this);
}
