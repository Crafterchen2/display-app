library;

import 'package:flutter/material.dart';
import 'package:display_app/data/models/hlc_log.dart';

List<HlcLog> hlcLogList = [];

String loggingPath = "";

bool inLogScreen = false;

void clearHlcLog() {
  if (!inLogScreen) {
    debugPrint("Cleaning HLC log");
    hlcLogList.clear();
  } else {
    debugPrint("Not clearing HLC log since we are in log screen");
  }
}
