import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:pionixbox/utils/constants/keys.dart';

String getChargingSessionIconByState(String state) {
  String base = 'assets/icons/';
  String url = '';
  switch (state) {
    case ChargingState.authRequired:
      return '';
    case ChargingState.disable:
      return '';
    case ChargingState.pluggedIn:
      return '';
    case ChargingState.unplugged:
      return '${base}icon_unplugged.svg';
    case ChargingState.charging:
      return '${base}icon_charging.svg';
    case ChargingState.chargingPausedEV:
      return '${base}icon_charging.svg';
    case ChargingState.chargingPausedEVSE:
      return '${base}icon_charging.svg';
    case ChargingState.error:
      return '';
    case ChargingState.permanentFault:
      return '';
  }
  return '${base}icon_unplugged.svg';
}

String chargingStateTitle(String state) {
  switch (state) {
    case ChargingState.authRequired:
      return 'Auth Required';
    case ChargingState.disable:
      return 'Disable';
    case ChargingState.pluggedIn:
      return 'PluggedIn';
    case ChargingState.unplugged:
      return 'Unplugged';
    case ChargingState.charging:
      return 'Charging';
    case ChargingState.chargingPausedEV:
      return 'Charging Paused By Car';
    case ChargingState.chargingPausedEVSE:
      return 'Charging Paused';
    case ChargingState.error:
      return 'Error';
    case ChargingState.permanentFault:
      return 'Permanent Fault';
    default:
      return 'Unplugged';
  }
}

String pauseOrResumeChargingTitle(String state) {
  String title = '';
  switch (state) {
    case ChargingState.authRequired:
      return '';
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

Future<String> generatePSK(String ssid, String password) async {
  final pbkdf2 =
      Pbkdf2(macAlgorithm: Hmac(Sha1()), iterations: 4096, bits: 256);

  List<int> password_bytes = utf8.encode(password);
  List<int> ssid_bytes = utf8.encode(ssid);

  final psk = await pbkdf2.deriveKey(
      secretKey: SecretKey(password_bytes), nonce: ssid_bytes);
  final psk_bytes = await psk.extractBytes();
  final psk_string = hex.encode(psk_bytes);

  print("PSK: " + psk_string);
  return psk_string;
}

String durationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {}
  return false;
}
