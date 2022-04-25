import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pionixbox/data/models/session_info.dart';

import '../../mqtt.dart';
import 'app_repo.dart';

///
///
class ProdRepo implements AppRepo {
  @override
  Future<void> getSessionInfo() async {
    try {
      final mqtt = MQTT();
      await mqtt.connect();
      mqtt.subscribe("everest_api/evse_manager/var/session_info", (message) {
        debugPrint('RESPONSE FROM: everest_api/evse_manager/var/session_info:: '+message);
        return SessionInfo.fromJson(jsonDecode(message));
      });
    } catch (e) {
      debugPrint("EXCEPTION FROM: everest_api/evse_manager/var/session_info::"+e.toString());
    }
  }
}
