import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient setup(String serverAddress, String uniqueID, int port) {
  final uid = uniqueID + 'rpi';
  final client = MqttServerClient.withPort(serverAddress, uid, port);
  client.useWebSocket = true;

  return client;
}
