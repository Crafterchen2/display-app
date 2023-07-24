import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/ev_info.dart';
import 'package:pionixbox/data/providers/connector_provider.dart';
import 'package:pionixbox/mqtt.dart';

EvInfo parseEvInfo(String evInfo) {
  return EvInfo.fromJson(jsonDecode(evInfo));
}

final evInfoStreamProvider = StreamProvider<EvInfo>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream =
      mqtt.subscribeStream("everest_api/" + connector + "/var/ev_info");
  await for (final message in stream) {
    // debugPrint("Received EvInfo");
    yield parseEvInfo(message);
  }
});
