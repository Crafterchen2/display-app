import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/power_meter.dart';
import 'package:display_app/data/providers/connector_provider.dart';
import 'package:display_app/mqtt.dart';

PowerMeter parsePowermeter(String powermeter) {
  return PowerMeter.fromJson(jsonDecode(powermeter));
}

final powermeterStreamProvider = StreamProvider<PowerMeter>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream = mqtt.subscribeStream("everest_api/$connector/var/powermeter");
  await for (final message in stream) {
    // debugPrint("Received a powermeter");
    yield parsePowermeter(message);
  }
});
