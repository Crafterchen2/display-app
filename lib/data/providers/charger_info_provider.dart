import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/charger_info.dart';
import 'package:pionixbox/mqtt.dart';

ChargerInfo parseChargerInfo(String chargerInfo) {
  return ChargerInfo.fromJson(jsonDecode(chargerInfo));
}

final chargerInfoStreamProvider = StreamProvider<ChargerInfo>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final stream = mqtt.subscribeStream("everest_api/info/var/info");
  await for (final message in stream) {
    // debugPrint("Received charger info");
    yield parseChargerInfo(message);
  }
});
