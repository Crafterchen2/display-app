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
  return url;
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
      return '';
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

String durationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
