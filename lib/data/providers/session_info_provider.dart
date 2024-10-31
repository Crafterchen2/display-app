import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/session_info.dart';
import 'package:display_app/data/providers/connector_provider.dart';
import 'package:display_app/mqtt.dart';

SessionInfo parseSessionInfo(String sessionInfo) {
  return SessionInfo.fromJson(jsonDecode(sessionInfo));
}

final sessionInfoStreamProvider = StreamProvider<SessionInfo>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream =
      mqtt.subscribeStream("everest_api/$connector/var/session_info");
  await for (final message in stream) {
    // debugPrint("Received session info");
    yield parseSessionInfo(message);
  }
});
