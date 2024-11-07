import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/hardware_capabilities.dart';
import 'package:display_app/data/providers/connector_provider.dart';
import 'package:display_app/mqtt.dart';

HardwareCapabilities parseHardwareCapabilities(String hardwareCapabilities) {
  /// provide dummy data on an empty string as an error occurs otherwise
  if (hardwareCapabilities == "") {
    return HardwareCapabilities(0, 0, 0, 0, 0, 0, 0, 0, false);
  }
  return HardwareCapabilities.fromJson(jsonDecode(hardwareCapabilities));
}

final hardwareCapabilitiesStreamProvider =
    StreamProvider<HardwareCapabilities>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream = mqtt.subscribeStream(
      "everest_api/" + connector + "/var/hardware_capabilities");
  await for (final message in stream) {
    // debugPrint("Received hardware capabilities");
    yield parseHardwareCapabilities(message);
  }
});
