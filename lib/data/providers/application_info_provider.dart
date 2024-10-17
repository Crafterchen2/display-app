import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/application_info.dart';
import 'package:display_app/mqtt.dart';

ApplicationInfo parseApplicationInfo(String applicationInfo) {
  return ApplicationInfo.fromJson(jsonDecode(applicationInfo));
}

final applicationInfoStreamProvider =
    StreamProvider<ApplicationInfo>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final stream = mqtt.subscribeStream("everest_api/setup/var/application_info");
  await for (final message in stream) {
    // debugPrint("Received application info");
    yield parseApplicationInfo(message);
  }
});
