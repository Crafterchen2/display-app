import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/mqtt.dart';

const String connectorDefault = "evse_manager";

String parseConnectors(String message) {
  final msg = jsonDecode(message);
  List<dynamic> connectors = msg;
  if (connectors.isNotEmpty) {
    return connectors[0];
  }

  return connectorDefault;
}

final connectorStreamProvider = StreamProvider<String>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final stream = mqtt.subscribeStream("everest_api/connectors");
  await for (final message in stream) {
    yield parseConnectors(message);
  }
});

final connectorProvider = Provider<String>((ref) {
  final connector =
      ref.watch(connectorStreamProvider).whenOrNull(data: (data) => data);

  return connector ?? connectorDefault;
});
