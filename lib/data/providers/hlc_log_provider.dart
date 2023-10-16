import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/hlc_log.dart';
import 'package:pionixbox/data/providers/connector_provider.dart';
import 'package:pionixbox/mqtt.dart';

HlcLog parseHlcLog(String hlcLog) {
  return HlcLog.fromJson(jsonDecode(hlcLog));
}

final hlcLogStreamProvider = StreamProvider<HlcLog>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream =
      mqtt.subscribeStream("everest_api/" + connector + "/var/hlc_log");
  await for (final message in stream) {
    // debugPrint("Received hlc log");
    yield parseHlcLog(message);
  }
});
