import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/mqtt.dart';

final hostnameStreamProvider = StreamProvider<String>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final stream =
      mqtt.subscribeStream("everest_api/setup/var/hostname");
  await for (final message in stream) {
    // debugPrint("Received hostname");
    yield message;
  }
});
