class ChargingState {
  static const String charging = 'Charging';
  static const String unplugged = 'Unplugged';
  static const String disable = 'Disable';
  static const String pluggedIn = 'PluggedIn';
  static const String authRequired = 'AuthRequired';
  static const String chargingPausedEV = 'ChargingPausedEV';
  static const String chargingPausedEVSE = 'ChargingPausedEVSE';
  static const String error = 'Error';
  static const String permanentFault = 'PermanentFault';
}

class Topic {
  static const String pauseChargingTopic = '/external/cmd/pause_charging';
  static const String resumeChargingTopic = '/external/cmd/resume_charging';
  static const String modifyChargingSessionTopic =
      '/carsim/cmd/modify_charging_session';
  static const String enableSimulationTopic =
      '/carsim/cmd/enable';

  static const String blockWifi = 'everest_api/setup/cmd/rfkill_block';
  static const String unblockWifi = 'everest_api/setup/cmd/rfkill_unblock';
  static const String addNetwork = 'everest_api/setup/cmd/add_network';
  static const String removeAllNetworks = 'everest_api/setup/cmd/remove_all_networks';
  static const String listConfiguredNetworks = 'everest_api/setup/cmd/list_configured_networks';


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
}
