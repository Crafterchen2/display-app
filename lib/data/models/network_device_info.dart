import 'package:json_annotation/json_annotation.dart';

part 'network_device_info.g.dart';

@JsonSerializable()
class NetworkDeviceInfo {
  final String interface;
  final String ipv4;

  NetworkDeviceInfo(this.interface, this.ipv4);

  factory NetworkDeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkDeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkDeviceInfoToJson(this);
}
