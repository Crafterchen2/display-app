import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/telemetry.dart';
import 'package:display_app/data/providers/connector_provider.dart';
import 'package:display_app/mqtt.dart';

Telemetry parseTelemetry(String telemetry) {
  return Telemetry.fromJson(jsonDecode(telemetry));
}

final telemetryStreamProvider = StreamProvider<Telemetry>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream =
      mqtt.subscribeStream("everest_api/" + connector + "/var/telemetry");
  await for (final message in stream) {
    // debugPrint("Received telemetry");
    yield parseTelemetry(message);
  }
});
