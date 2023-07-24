// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'network_device_info.g.dart';

@JsonSerializable()
class NetworkDeviceInfo {
  final String interface;
  final List<String> ipv4;
  final bool blocked;
  final bool wireless;
  final List<String> ipv6;
  final String rfkill_id;

  NetworkDeviceInfo(
      {required this.interface,
      this.ipv4 = const [],
      required this.blocked,
      required this.wireless,
      this.ipv6 = const [],
      this.rfkill_id = ""});

  factory NetworkDeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkDeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkDeviceInfoToJson(this);
}
