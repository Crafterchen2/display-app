import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/session_info.dart';

import '../../mqtt.dart';
import 'app_repo_provider.dart';

final sessionInfoProvider =
    StreamProvider.autoDispose<SessionInfo>((ref) async* {
  final repo = ref.read(appRepoProvider);
  debugPrint("Values starting");
  final mqtt = MQTT();
  await mqtt.connect();
  mqtt.subscribe("everest_api/evse_manager/var/session_info", (m) async* {
    debugPrint("Values starting");
    try {
      yield jsonDecode(m);
    } catch (e) {
      debugPrint(e.toString());
    }
  });

  // await for (final val in result) {
  //   debugPrint(val.toString());
  //   final s = json.decode(val.toString()) as Map<String, dynamic>;
  //   debugPrint("Values Mid");
  //
  //   final obj = SessionInfo.fromJson(s);
  //   debugPrint("Values ending$obj");
  //   yield obj;
  // }
});
