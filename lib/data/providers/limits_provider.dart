import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/limits.dart';
import 'package:display_app/data/providers/connector_provider.dart';
import 'package:display_app/mqtt.dart';

Limits parseLimits(String limits) {
  return Limits.fromJson(jsonDecode(limits));
}

final limitsStreamProvider = StreamProvider<Limits>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream =
      mqtt.subscribeStream("everest_api/" + connector + "/var/limits");
  await for (final message in stream) {
    // debugPrint("Received limits");
    yield parseLimits(message);
  }
});
