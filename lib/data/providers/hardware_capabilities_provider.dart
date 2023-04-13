import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/hardware_capabilities.dart';
import 'package:pionixbox/data/providers/connector_provider.dart';
import 'package:pionixbox/mqtt.dart';

HardwareCapabilities parseHardwareCapabilities(String hardwareCapabilities) {
  return HardwareCapabilities.fromJson(jsonDecode(hardwareCapabilities));
}

final hardwareCapabilitiesStreamProvider = StreamProvider<HardwareCapabilities>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream =
      mqtt.subscribeStream("everest_api/" + connector + "/var/hardware_capabilities");
  await for (final message in stream) {
    // debugPrint("Received hardware capabilities");
    yield parseHardwareCapabilities(message);
  }
});
