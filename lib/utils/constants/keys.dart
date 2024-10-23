class ChargingState {
  static const String charging = 'Charging';
  static const String preparing = 'Preparing';
  static const String unplugged = 'Unplugged';
  static const String disable = 'Disable';
  static const String pluggedIn = 'PluggedIn';
  static const String authRequired = 'AuthRequired';
  static const String chargingPausedEV = 'ChargingPausedEV';
  static const String chargingPausedEVSE = 'ChargingPausedEVSE';
  static const String error = 'Error';
  static const String permanentFault = 'PermanentFault';
  static const String waitEnergy = 'WaitingForEnergy';
}

class ErrorStateInfo {
  static const String car = 'Car';
  static const String carDiodeFault = 'CarDiodeFault';
  static const String relais = 'Relais';
  static const String rCD = 'RCD';
  static const String ventilationNotAvailable = 'VentilationNotAvailable';
  static const String overCurrent = 'OverCurrent';
  static const String internal = 'Internal';
  static const String slac = 'SLAC';
  static const String hlc = 'HLC';
}

class Language {
  static const String english = 'english';
  static const String german = 'german';
  static const String unknown = 'unknown';
}

class Topic {
  static const String modifyChargingSessionTopic =
      'everest_external/nodered/1/carsim/cmd/modify_charging_session';
  static const String enableSimulationTopic =
      'everest_external/nodered/carsim/1/cmd/enable';

  static const String blockWifi = 'everest_api/setup/cmd/rfkill_block';
  static const String unblockWifi = 'everest_api/setup/cmd/rfkill_unblock';
  static const String enableAp = 'everest_api/setup/cmd/enable_ap';
  static const String disableAp = 'everest_api/setup/cmd/disable_ap';
  static const String addNetwork = 'everest_api/setup/cmd/add_network';
  static const String enableNetwork = 'everest_api/setup/cmd/enable_network';
  static const String disableNetwork = 'everest_api/setup/cmd/disable_network';
  static const String selectNetwork = 'everest_api/setup/cmd/select_network';
  static const String removeAllNetworks =
      'everest_api/setup/cmd/remove_all_networks';
  static const String listConfiguredNetworks =
      'everest_api/setup/cmd/list_configured_networks';
  static const String scanWifi = 'everest_api/setup/cmd/scan_wifi';
  static const String enableWifiScanning =
      'everest_api/setup/cmd/enable_wifi_scanning';
  static const String disableWifiScanning =
      'everest_api/setup/cmd/disable_wifi_scanning';
  static const String removeNetwork = 'everest_api/setup/cmd/remove_network';
  static const String checkOnlineStatus =
      'everest_api/setup/cmd/check_online_status';
  static const String onlineStatus = 'everest_api/setup/var/online_status';
  static const String applicationInfo =
      'everest_api/setup/var/application_info';
  static const String updateCurrentLanguage =
      'everest_api/setup/cmd/change_current_language';
  static const String updateDefaultLanguage =
      'everest_api/setup/cmd/change_default_language';
  static const String resetInitialized =
      'everest_api/setup/cmd/reset_initialized';
  static const String setInitialized = 'everest_api/setup/cmd/set_initialized';
  static const String setAppMode = 'everest_api/setup/cmd/set_mode';
  static const String reboot = 'everest_api/setup/cmd/reboot';
  static const String setMaxCurrent =
      'everest_external/nodered/1/cmd/set_max_current';
}

class Payloads {
  static const String pausedByCar = 'sleep 1;pause;sleep 86400';
  static const String resumeByCar =
      'sleep 1;draw_power_regulated 32,3;sleep 86400';
  static const String plugIn = 'sleep 1;iec_wait_pwr_ready;sleep 86400';
  static const String plugOut = 'sleep 1;unplug;sleep 86400';
  static const String chargingSimulation =
      'sleep 1;iec_wait_pwr_ready;sleep 1;draw_power_regulated 32,3;sleep 86400;unplug';
  static const String enableSimulation = 'true';
  static const String disableSimulation = 'false';
  static const String isoPause = 'iso_pause_charging;iso_wait_for_resume';
  static const String isoStop =
      'iso_stop_charging;iso_wait_v2g_session_stopped;unplug';
  static const String isoResumeAC =
      'iso_start_bcb_toggle 3;iso_wait_pwm_is_running;iso_start_v2g_session AC;iso_wait_pwr_ready;iso_draw_power_regulated 16,3;sleep 36000';
  static const String isoStartAC =
      'sleep 1;iso_wait_slac_matched;iso_start_v2g_session AC;iso_wait_pwr_ready;iso_draw_power_regulated 16,3;sleep 36000';
  static const String isoStartDC =
      'sleep 1;iso_wait_slac_matched;iso_start_v2g_session DC;iso_wait_pwr_ready;sleep 36000';
}

class ChargerModelName {
  static const String belayBox = 'BelayBox';
  static const String microMegaWattCharger = 'MicroMegaWattCharger';
  static const String microMegaWattCar = 'MicroMegaWattCar';
}

class AppAssets {
  static const String everestLogo = 'assets/images/everest_logo.png';
}
