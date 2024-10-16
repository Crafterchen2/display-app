import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/utils/constants/keys.dart';

String getChargingSessionIconByState(String state) {
  String base = 'assets/icons/';
  switch (state) {
    case ChargingState.authRequired:
      return '${base}icon_cardswipe.svg';
    case ChargingState.disable:
      return '';
    case ChargingState.pluggedIn:
      return '';
    case ChargingState.unplugged:
      return '${base}icon_unplugged.svg';
    case ChargingState.charging:
      return '${base}icon_battery_3.svg';
    case ChargingState.chargingPausedEV:
      return '${base}icon_pausecharging.svg';
    case ChargingState.chargingPausedEVSE:
      return '${base}icon_pausecharging.svg';
    case ChargingState.error:
      return '${base}icon_error.svg';
    case ChargingState.permanentFault:
      return '';
  }
  return '${base}icon_unplugged.svg';
}

String chargingStateTitle(String state, {String stateInfo = ''}) {
  switch (state) {
    case ChargingState.authRequired:
      return 'auth_required'.tr();
    case ChargingState.disable:
      return 'disable'.tr();
    case ChargingState.pluggedIn:
      return 'pluggedIn'.tr();
    case ChargingState.unplugged:
      return 'unplugged'.tr();
    case ChargingState.preparing:
      return 'preparing'.tr();
    case ChargingState.charging:
      return 'charging'.tr();
    case ChargingState.chargingPausedEV:
      return tr('charging_paused_by_car');
    case ChargingState.chargingPausedEVSE:
      return 'charging_paused'.tr();
    case ChargingState.error:
      return errorStateInfo(stateInfo);
    case ChargingState.permanentFault:
      return 'permanent_fault'.tr();
    case ChargingState.waitEnergy:
      return 'wait_for_energy'.tr();
    default:
      return state;
  }
}

String pauseOrResumeChargingTitle(String state) {
  String title = '';
  switch (state) {
    case ChargingState.authRequired:
      return 'Auth Required';
    case ChargingState.disable:
      return '';
    case ChargingState.pluggedIn:
      return '';
    case ChargingState.unplugged:
      return '';
    case ChargingState.charging:
      return 'Charging';
    case ChargingState.chargingPausedEV:
      return '';
    case ChargingState.chargingPausedEVSE:
      return 'ChargingPausedEVSE';
    case ChargingState.error:
      return '';
    case ChargingState.permanentFault:
      return '';
  }
  return title;
}

String errorStateInfo(String stateInfo) {
  String title = '';
  switch (stateInfo) {
    case ErrorStateInfo.car:
      return 'car_error'.tr();
    case ErrorStateInfo.carDiodeFault:
      return 'carDiodeFault_error'.tr();
    case ErrorStateInfo.relais:
      return 'relais_error'.tr();
    case ErrorStateInfo.rCD:
      return 'rCD_error'.tr();
    case ErrorStateInfo.ventilationNotAvailable:
      return 'ventilationNotAvailable_error'.tr();
    case ErrorStateInfo.overCurrent:
      return 'overCurrent_error'.tr();
    case ErrorStateInfo.internal:
      return 'internal_error'.tr();
    case ErrorStateInfo.slac:
      return 'slac_error'.tr();
    case ErrorStateInfo.hlc:
      return 'hlc_error'.tr();
  }
  return title;
}

String checkSignalStrength(int signalLevel) {
  String strength = '';
  if (signalLevel >= -50 && signalLevel <= -30) {
    return 'Strong';
  } else if (signalLevel >= -60 && signalLevel <= -51) {
    return 'Good';
  } else if (signalLevel >= -79 && signalLevel <= -61) {
    return 'Poor';
  } else if (signalLevel >= -90 && signalLevel <= -80) {
    return 'Unstable';
  }
  return strength;
}

String getWifiIcon(int signalLevel) {
  String base = 'assets/icons/';
  if (signalLevel >= -50 && signalLevel <= -30) {
    return '${base}signal_full.svg';
  } else if (signalLevel >= -60 && signalLevel <= -51) {
    return '${base}signal_3.svg';
  } else if (signalLevel >= -79 && signalLevel <= -61) {
    return '${base}signal_2.svg';
  } else if (signalLevel >= -90 && signalLevel <= -80) {
    return '${base}signal_0.svg';
  }
  return '${base}signal_0.svg';
}

Color checkSignalStrengthColor(int signalLevel) {
  if (signalLevel >= -50 && signalLevel <= -30) {
    return Colors.green;
  } else if (signalLevel >= -60 && signalLevel <= -51) {
    return Colors.lightGreen;
  } else if (signalLevel >= -79 && signalLevel <= -61) {
    return Colors.yellow;
  } else if (signalLevel >= -90 && signalLevel <= -80) {
    return Colors.redAccent;
  }
  return Colors.white;
}

Future<String> generatePSK(String ssid, String password) async {
  final pbkdf2 =
      Pbkdf2(macAlgorithm: Hmac(Sha1()), iterations: 4096, bits: 256);

  List<int> passwordBytes = utf8.encode(password);
  List<int> ssidBytes = utf8.encode(ssid);

  final psk = await pbkdf2.deriveKey(
      secretKey: SecretKey(passwordBytes), nonce: ssidBytes);
  final pskBytes = await psk.extractBytes();
  final pskString = hex.encode(pskBytes);

  // print("PSK: " + pskString);
  return pskString;
}

String durationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

// String signalStrength(int ) {
//   return;
// }

String wrapString(String str) {
  String newStr = "";
  for (var character in str.runes) {
    newStr += String.fromCharCode(character);
    newStr += '\u200B';
  }
  return newStr;
}
