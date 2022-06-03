import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTT {
  static final MQTT _instance = MQTT._internal();
  static const String localHost = 'localhost';
  static const String testing = '192.168.10.8';

  factory MQTT() => _instance;

  MqttClient _client;
  late StreamSubscription<List<MqttReceivedMessage<MqttMessage>>> subscription;
  final StreamController _subscriptionController = StreamController<String>();
  final Map _callbacks = {};

  ///todo undo ip address
  MQTT._internal()
      : _client = MqttServerClient.withPort(testing, "pionixbox", 1883) {
    _client.onConnected = () {
      _subscriptionController.stream.listen((topic) {
        _client.subscribe(topic, MqttQos.exactlyOnce);
      });
    };
  }

  Future<void> connect() async {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      return;
    }
    try {
      await _client.connect();
      subscription = _client.updates!.listen((event) {
        final MqttPublishMessage receivedMessage =
            event[0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            receivedMessage.payload.message);
        final String topic = event[0].topic;

        if (_callbacks.containsKey(topic)) {
          _callbacks[topic](message);
        }
      });
    } on NoConnectionException catch (e) {
      _client.disconnect();
    }
  }

  void subscribe(String topic, Function(String) callback) {
    _callbacks[topic] = callback;
    _subscriptionController.sink.add(topic);
  }

  void publish(String topic, String payload) {
    _client.publishMessage(topic, MqttQos.exactlyOnce,
        MqttClientPayloadBuilder().addString(payload).payload!);
  }
}
