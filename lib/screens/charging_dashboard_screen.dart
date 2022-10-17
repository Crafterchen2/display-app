import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/utils/helper.dart';
import 'package:pionixbox/widgets/session_info_body_portrait.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';
import '../widgets/header_widget.dart';
import '../widgets/session_info_body.dart';

class PrivateChargerScreenDemo extends StatefulWidget {
  const PrivateChargerScreenDemo({Key? key}) : super(key: key);

  @override
  State<PrivateChargerScreenDemo> createState() =>
      _PrivateChargerScreenDemoState();
}

class _PrivateChargerScreenDemoState extends State<PrivateChargerScreenDemo> {
  late String _status;
  late String _energyTotal;
  late double _chargedEnergy;
  late double _latestTotalw;
  late String _duration;
  late double _power;
  late PowerMeter powerMeter;
  late Limits limits;
  bool _online = false;

  bool _showSimulationPanel = false;
  bool _showProgressBar = false;
  bool showSettingsIcon = true;
  bool simulation = false;
  bool wifi = false;
  bool localization = false;
  bool privateMode = false;
  final mqtt = MQTT();

  @override
  void initState() {
    _status = 'unplugged';
    _energyTotal = '12.3';
    _power = 0;
    _chargedEnergy = 12.3;
    _latestTotalw = 1000;
    _duration = '00:00:00';

    _connectMqtt();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    extractArguments(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void extractArguments(BuildContext context) {
    setState(() {
      _showProgressBar = true;
    });
    final i = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    privateMode = i["private_mode"] ?? false;
    if (!privateMode) {
      debugPrint("Entering public mode");
      updateCurrentLanguage();
      // _status = 'AuthRequired';
    }
    setState(() {
      _showProgressBar = false;
    });
  }

  void updateCurrentLanguage() {
    mqtt.publish(Topic.updateCurrentLanguage, "eng");
    setState(() {});
  }

  void parseConfigInfo(String message) {
    final i = jsonDecode(message);
    localization = i["localization"];
    wifi = i["setup_wifi"];
    simulation = i["setup_simulation"];
    if (localization || simulation || wifi) {
      showSettingsIcon = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void parseOnlineStatus(String message) {
    debugPrint('\n\nchecking status: $message\n\n');
    _online = message == "online";
    if (mounted) {
      setState(() {});
    }
  }

  void parseSessionInfo(String message) {
    final i = jsonDecode(message);
    _status = i["state"] ?? '';
    _chargedEnergy = i["charged_energy_wh"] / 1000.0;
    _latestTotalw = i["latest_total_w"] / 1000.0;
    _energyTotal = (_chargedEnergy.toStringAsFixed(1) + " kWh");
    _duration = durationFormat(Duration(seconds: i["charging_duration_s"]));
    if (mounted) {
      setState(() {
        _showProgressBar = false;
      });
    }
  }

  void parsePowermeterDetails(String powermtere) {
    final i = jsonDecode(powermtere);
    powerMeter = PowerMeter.fromJson(i);
    _power = powerMeter.power_W.total / 1000;

    if (mounted) {
      setState(() {
        _showProgressBar = false;
      });
    }
  }

  void parseLimits(String message) {
    final i = jsonDecode(message);
    limits = Limits.fromJson(i);
    if (mounted) {
      setState(() {
        _showProgressBar = false;
      });
    }
  }

  Future<void> _connectMqtt() async {
    setState(() {
      _showProgressBar = true;
    });
    try {
      await mqtt.connect();
      mqtt.subscribe(
          "everest_api/evse_manager/var/session_info", parseSessionInfo);
      mqtt.subscribe("everest_api/evse_manager/var/limits", parseLimits);
      mqtt.subscribe(
          "everest_api/evse_manager/var/powermeter", parsePowermeterDetails);
      mqtt.subscribe(
          "everest_api/setup/var/supported_setup_features", parseConfigInfo);
      checkOnlineStatus();
      mqtt.subscribe("everest_api/setup/var/online_status", parseOnlineStatus);
    } catch (e) {
      debugPrint(e.toString());
      _status = 'Connection Error';
      _chargedEnergy = 0;
      _latestTotalw = 0;
      _energyTotal = '';
      setState(() {
        _showProgressBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    extractArguments(context);
    return Scaffold(
      body: Stack(
        children: [
          OrientationBuilder(builder: (context, orientation) {
            return Column(
              children: [
                Header(
                  privateMode: privateMode,
                  onSettingsPressed: () async {
                    if (privateMode) {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.settingScreen, arguments: {
                        'localization': localization,
                        'setup_simulation': simulation,
                        'setup_wifi': wifi,
                      });
                    } else {
                      debugPrint('Before');
                      final result = await Navigator.of(context)
                          .pushNamed(AppRoutes.languagePickerScreen);
                      debugPrint(result.toString());
                      setState(() {});
                    }
                  },
                ),
                const Spacer(flex: 1),
                orientation == Orientation.landscape
                    ? SessionInfoBody(
                        state: _status,
                        energy: _chargedEnergy,
                        totalEnergy: _energyTotal,
                        power: _power,
                        latestTotalw: _latestTotalw,
                        duration: _duration,
                        online: _online,
                        seeMorePressed: () {
                          Navigator.of(context).pushNamed(
                              AppRoutes.sessionDetailScreen,
                              arguments: {
                                'powerMeter': powerMeter,
                                'limits': limits,
                              });
                        },
                        onPauseCharging: () => performAction(pauseCharging),
                        onResumeCharging: () => performAction(resumeCharging),
                      )
                    : SessionInfoBodyPortrait(
                        state: _status,
                        energy: _chargedEnergy,
                        totalEnergy: _energyTotal,
                        power: _power,
                        latestTotalw: _latestTotalw,
                        duration: _duration,
                        online: _online,
                        seeMorePressed: () {
                          Navigator.of(context).pushNamed(
                              AppRoutes.sessionDetailScreen,
                              arguments: {
                                'powerMeter': powerMeter,
                                'limits': limits,
                              });
                        },
                        onPauseCharging: () => performAction(pauseCharging),
                        onResumeCharging: () => performAction(resumeCharging),
                      ),
                const Spacer(flex: 2),
              ],
            );
          }),
          if (_showProgressBar)
            Center(
              child: Container(
                color: Colors.white,
                child: const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryAmber),
                ),
              ),
            )
        ],
      ),
    );
  }

  void performAction(Function() action) {
    setState(() {
      _showProgressBar = true;
    });
    action();
    setState(() {
      _showProgressBar = false;
      _showSimulationPanel = false;
    });
  }

  void pauseCharging() {
    mqtt.publish(Topic.pauseChargingTopic, "");
  }

  void resumeCharging() {
    mqtt.publish(Topic.resumeChargingTopic, "");
  }

  void pauseByCar() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.pausedByCar);
  }

  void resumeByCar() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.resumeByCar);
    setState(() {});
  }

  void plugIn() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.plugIn);
    setState(() {});
  }

  void plugOut() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.plugOut);
    setState(() {});
  }

  void chargingSimulation() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.chargingSimulation);
    setState(() {});
  }

  void enableSimulation() {
    mqtt.publish(Topic.enableSimulationTopic, Payloads.enableSimulation);
    setState(() {});
  }

  void disableSimulation() {
    mqtt.publish(Topic.enableSimulationTopic, Payloads.disableSimulation);
    setState(() {});
  }

  void checkOnlineStatus() {
    mqtt.publish(Topic.checkOnlineStatus, '');
    setState(() {});
  }
}
