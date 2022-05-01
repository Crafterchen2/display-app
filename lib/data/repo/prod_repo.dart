import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pionixbox/utils/server.dart'
    if (dart.library.html) 'browser.dart' as mqttsetup;

import 'package:pionixbox/data/models/session_info.dart';

import '../../mqtt.dart';
import 'app_repo.dart';

///
///
class ProdRepo implements AppRepo {
  @override
  Future<SessionInfo> getSessionInfo() async {
    late dynamic info;
    final mqtt = MQTT();
    await mqtt.connect();
    mqtt.subscribe("everest_api/evse_manager/var/session_info", (m) {

      info = jsonDecode(m);
      debugPrint(info.toString());
    });
    debugPrint('outside: ${info.toString()}');
    return info;
  }

  SessionInfo parseSessionInfo(String message) {
    final sessionInfo = jsonDecode(message);
    // debugPrint(sessionInfo.toString());
    return SessionInfo.fromJson(sessionInfo);
  }
}
