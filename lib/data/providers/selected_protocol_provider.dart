import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/providers/connector_provider.dart';
import 'package:display_app/mqtt.dart';

final selectedProtocolStreamProvider = StreamProvider<String>((ref) async* {
  final mqtt = MQTT();
  await mqtt.connect();
  final connector = ref.watch(connectorProvider);
  final stream =
      mqtt.subscribeStream("everest_api/$connector/var/selected_protocol");
  await for (final message in stream) {
    // debugPrint("Received selected protocol");
    yield message;
  }
});
