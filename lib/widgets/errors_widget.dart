import 'dart:convert';

import 'package:display_app/mqtt.dart';
import 'package:display_app/screens/errors_screen.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

const String receiveErrorsTopic =
    "basecamp/api/1.0/error_history_consumer/error_history_api/b2m/customReceiveErrorTopic";
const String pollErrorsTopic =
    "basecamp/api/1.0/error_history_consumer/error_history_api/m2b/active_errors";

List<BasecampError> activeErrors = [];

class ErrorsWidget extends StatefulWidget {
  const ErrorsWidget({super.key});

  @override
  State<ErrorsWidget> createState() => _ErrorsWidgetState();
}

class _ErrorsWidgetState extends State<ErrorsWidget> {
  final mqtt = MQTT();
  late final CancelableOperation pollErrorLoop;
  @override
  void initState() {
    super.initState();
    startPolling();
  }

  @override
  void dispose() {
    pollErrorLoop.cancel();
    super.dispose();
  }

  void startPolling() async {
    await mqtt.connect();
    mqtt.subscribe(receiveErrorsTopic, parseErrors);
    pollErrorLoop = CancelableOperation.fromFuture(
      pollErrors(),
      onCancel: () {
        debugPrint("stopped ppolling for errors");
      },
    );
  }

  Future<void> pollErrors() async {
    // debugPrint("started error polling");
    while (true) {
      mqtt.publish(pollErrorsTopic,
          "{\"headers\":{\"replyTo\":\"$receiveErrorsTopic\"}}");
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void parseErrors(String message) {
    try {
      activeErrors = [];
      List activeErrorsJson = json.decode(message)["errors"]! as List;
      for (var error in activeErrorsJson) {
        activeErrors.add(BasecampError.fromJson(error));
      }
    } catch (e, strace) {
      debugPrint("$e, $strace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return activeErrors.isEmpty
        ? const SizedBox.shrink()
        : IconButton.filled(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ErrorsScreen(activeErrors),
              ));
            },
            icon: const Icon(Icons.error));
  }
}

enum BasecampErrorSeverity { high, medium, low }

enum BasecampErrorState { active, clearedByModule, clearedByReboot }

/// an implementation of the errors specified here: https://docs.pionix.de/BaseCamp-API/error_history_consumer_API/index.html#operations
class BasecampError {
  String type = "";
  String subType = "";
  String description = "";
  String message = "";
  BasecampErrorSeverity severity = BasecampErrorSeverity.low;
  Map<String, dynamic> origin = {};
  DateTime timestamp = DateTime.now();
  String uuid = "";
  BasecampErrorState state = BasecampErrorState.active;

  BasecampError.fromJson(Map<String, dynamic> json) {
    type = json["type"] as String;
    subType = json["sub_type"] as String;
    description = json["description"] as String;
    message = json["message"] as String;
    severity = {
      "High": BasecampErrorSeverity.high,
      "Medium": BasecampErrorSeverity.medium,
      "Low": BasecampErrorSeverity.low,
    }[json["severity"] as String]!;
    origin = json["origin"].cast<String, String>();
    timestamp = DateTime.parse(json["timestamp"]);
    uuid = json["uuid"];
    state = {
      "Active": BasecampErrorState.active,
      "ClearedByModule": BasecampErrorState.clearedByModule,
      "ClearedByReboot": BasecampErrorState.clearedByReboot,
    }[json["state"]]!;
  }
}
