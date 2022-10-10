// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_network.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedNetwork _$SavedNetworkFromJson(Map<String, dynamic> json) => SavedNetwork(
      network_id: json['network_id'] as int,
      interface: json['interface'] as String,
    );

Map<String, dynamic> _$SavedNetworkToJson(SavedNetwork instance) =>
    <String, dynamic>{
      'interface': instance.interface,
      'network_id': instance.network_id,
    };
