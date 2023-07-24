// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'saved_network.g.dart';

@JsonSerializable()
class SavedNetwork {
  final String interface;
  final int network_id;

  SavedNetwork({required this.network_id, required this.interface});

  factory SavedNetwork.fromJson(Map<String, dynamic> json) =>
      _$SavedNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$SavedNetworkToJson(this);
}
