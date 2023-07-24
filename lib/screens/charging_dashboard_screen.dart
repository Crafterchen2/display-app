import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/data/providers/connector_provider.dart';
import 'package:pionixbox/data/providers/ev_info_provider.dart';
import 'package:pionixbox/data/providers/hardware_capabilities_provider.dart';
import 'package:pionixbox/data/providers/limits_provider.dart';
import 'package:pionixbox/data/providers/powermeter_provider.dart';
import 'package:pionixbox/data/providers/session_info_provider.dart';
import 'package:pionixbox/data/providers/telemetry_provider.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/utils/circular_queue.dart';
import 'package:pionixbox/utils/constants/helper.dart';
import 'package:pionixbox/utils/enums.dart';
import 'package:pionixbox/widgets/session_info_body_portrait.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/datetime_formats.dart';
import '../utils/routing/app_router.dart';
import '../widgets/header_widget.dart';
import '../widgets/session_info_body.dart';

class ChargingDashboardScreen extends ConsumerStatefulWidget {
  const ChargingDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChargingDashboardScreen> createState() =>
      _ChargingDashboardScreenState();
}

class _ChargingDashboardScreenState
    extends ConsumerState<ChargingDashboardScreen> {
  late String _status;
  late String _statusInfo;
  late String _energyTotal;
  late double _chargedEnergy;
  late double _latestTotalw;
  late String _duration;
  late double _power;
  late PowerMeter powerMeter;
  late Limits limits;
  double _current = 6.0;
  double _minCurrentA = 6.0;
  double _maxCurrentA = 32.0;
  bool _online = false;
  String connector = connectorDefault;

  bool _showProgressBar = false;
  bool showSettingsIcon = true;
  bool simulation = false;
  bool wifi = false;
  bool localization = false;
  bool privateMode = false;
  ChargingMode chargingMode = ChargingMode.unknown;
  final mqtt = MQTT();

  @override
  void initState() {
    _status = 'unplugged';
    _statusInfo = '';
    _energyTotal = '0.0';
    _power = 0;
    _chargedEnergy = 0.0;
    _latestTotalw = 0;
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
  Widget build(BuildContext context) {
    extractArguments(context);
    connector = ref.watch(connectorProvider);
    final powermeter =
        ref.watch(powermeterStreamProvider).whenOrNull(data: (data) => data);
    if (powermeter != null) {
      powerMeter = powermeter;
      if (powerMeter.power_W != null) {
        _power = powerMeter.power_W!.total / 1000;

        if (powerMeter.power_W!.L1 != null) {
          bufferedPowerMeter.powerL1.add(powerMeter.power_W!.L1!);
        }
        if (powerMeter.power_W!.L2 != null) {
          bufferedPowerMeter.powerL2.add(powerMeter.power_W!.L2!);
        }
        if (powerMeter.power_W!.L3 != null) {
          bufferedPowerMeter.powerL3.add(powerMeter.power_W!.L3!);
        }
        bufferedPowerMeter.powerTotal.add(powerMeter.power_W!.total);
      }

      if (powerMeter.current_A != null) {
        if (powerMeter.current_A!.L1 != null) {
          bufferedPowerMeter.currentL1.add(powerMeter.current_A!.L1!);
        }
        if (powerMeter.current_A!.L2 != null) {
          bufferedPowerMeter.currentL2.add(powerMeter.current_A!.L2!);
        }
        if (powerMeter.current_A!.L3 != null) {
          bufferedPowerMeter.currentL3.add(powerMeter.current_A!.L3!);
        }
        if (powerMeter.current_A!.N != null) {
          bufferedPowerMeter.currentN.add(powerMeter.current_A!.N!);
        }
        if (powerMeter.current_A!.DC != null) {
          bufferedPowerMeter.currentDC.add(powerMeter.current_A!.DC!);
          bufferedPowerMeter.ac = false;
        }
      }

      if (powerMeter.frequency_Hz != null) {
        bufferedPowerMeter.freqL1.add(powerMeter.frequency_Hz!.L1);
        if (powerMeter.frequency_Hz!.L2 != null) {
          bufferedPowerMeter.freqL2.add(powerMeter.frequency_Hz!.L2!);
        }
        if (powerMeter.frequency_Hz!.L3 != null) {
          bufferedPowerMeter.freqL3.add(powerMeter.frequency_Hz!.L3!);
        }
      }

      if (powerMeter.voltage_V != null) {
        if (powerMeter.voltage_V!.L1 != null) {
          bufferedPowerMeter.voltageL1.add(powerMeter.voltage_V!.L1!);
        }
        if (powerMeter.voltage_V!.L2 != null) {
          bufferedPowerMeter.voltageL2.add(powerMeter.voltage_V!.L2!);
        }
        if (powerMeter.voltage_V!.L3 != null) {
          bufferedPowerMeter.voltageL3.add(powerMeter.voltage_V!.L3!);
        }
        if (powerMeter.voltage_V!.DC != null) {
          bufferedPowerMeter.voltageDC.add(powerMeter.voltage_V!.DC!);
        }
      }
    }

    final telemetry =
        ref.watch(telemetryStreamProvider).whenOrNull(data: (data) => data);
    if (telemetry != null) {
      bufferedTelemetry.fanRPM.add(telemetry.fan_rpm);
      bufferedTelemetry.rcdCurrent.add(telemetry.rcd_current);
      bufferedTelemetry.relaisOn.add(telemetry.relais_on);
      bufferedTelemetry.supplyVoltage12V.add(telemetry.supply_voltage_12V);
      bufferedTelemetry.supplyMinusVoltage12V
          .add(telemetry.supply_voltage_minus_12V);
      bufferedTelemetry.temperature.add(telemetry.temperature);
    }

    final l = ref.watch(limitsStreamProvider).whenOrNull(data: (data) => data);
    if (l != null) {
      limits = l;
      if (limits.max_current >= 6.0) {
        _current = limits.max_current;
      }
    }
    final sessioninfo =
        ref.watch(sessionInfoStreamProvider).whenOrNull(data: (data) => data);
    if (sessioninfo != null) {
      _status = sessioninfo.state;
      _statusInfo = sessioninfo.state_info;
      _chargedEnergy = sessioninfo.charged_energy_wh / 1000.0;
      _latestTotalw = sessioninfo.latest_total_w / 1000.0;
      _energyTotal = (_chargedEnergy.toStringAsFixed(1) + " kWh");
      _duration =
          durationFormat(Duration(seconds: sessioninfo.charging_duration_s));
    }
    final hardwareCapabilities = ref
        .watch(hardwareCapabilitiesStreamProvider)
        .whenOrNull(data: (data) => data);
    if (hardwareCapabilities != null) {
      if (hardwareCapabilities.max_current_A_import >= 6.0) {
        _maxCurrentA = hardwareCapabilities.max_current_A_import;
      }
      if (hardwareCapabilities.min_current_A_import >= 6.0) {
        _minCurrentA = hardwareCapabilities.min_current_A_import;
      }
    }
    final evInfo =
        ref.watch(evInfoStreamProvider).whenOrNull(data: (data) => data);
    if (evInfo != null) {
      if (evInfo.evcc_id != null) {
        // not basic charging
        if (powerMeter.voltage_V != null && powerMeter.voltage_V!.DC != null) {
          chargingMode = ChargingMode.unknownDC;
        } else {
          chargingMode = ChargingMode.isoAC;
        }
      } else {
        chargingMode = ChargingMode.basicAC;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.white,
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
                      await Navigator.of(context)
                          .pushNamed(AppRoutes.languagePickerScreen);
                      setState(() {});
                    }
                  },
                ),
                orientation == Orientation.landscape
                    ? SessionInfoBody(
                        state: _status,
                        stateInfo: _statusInfo,
                        energy: _chargedEnergy,
                        totalEnergy: _energyTotal,
                        power: _power,
                        latestTotalw: _latestTotalw,
                        duration: _duration,
                        online: _online,
                        seeMorePressed: () async {
                          await Navigator.of(context).pushNamed(
                              AppRoutes.sessionDetailScreen,
                              arguments: {}).then((value) {
                            setState(() {});
                          });
                        },
                        onPauseCharging: () => performAction(pauseCharging),
                        onResumeCharging: () => performAction(resumeCharging),
                        onCurrentChanged: (value) {
                          _current = value;
                          setState(() {});
                          setMaxCurrent(value);
                        },
                        current: _current,
                        maxCurrentA: _maxCurrentA,
                        minCurrentA: _minCurrentA,
                        chargingMode: chargingMode,
                        soc: evInfo?.soc)
                    : SessionInfoBodyPortrait(
                        state: _status,
                        stateInfo: _statusInfo,
                        energy: _chargedEnergy,
                        totalEnergy: _energyTotal,
                        power: _power,
                        current: _current,
                        maxCurrentA: _maxCurrentA,
                        minCurrentA: _minCurrentA,
                        latestTotalw: _latestTotalw,
                        duration: _duration,
                        online: _online,
                        seeMorePressed: () {
                          Navigator.of(context).pushNamed(
                              AppRoutes.sessionDetailScreen,
                              arguments: {}).then((value) {
                            setState(() {});
                          });
                        },
                        onPauseCharging: () => performAction(pauseCharging),
                        onResumeCharging: () => performAction(resumeCharging),
                        onCurrentChanged: (value) {
                          _current = value;
                          setState(() {});
                          setMaxCurrent(value);
                        },
                      ),
                const Spacer(flex: 2),
                Column(
                  children: [
                    Container(
                      height: 3,
                      color: Colors.grey.shade300,
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _online
                                        ? AppColors.successLight
                                        : AppColors.errorLight),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  child: Text(
                                    _online ? 'online'.tr() : 'offline'.tr(),
                                    style: AppTextStyles.subTitle2
                                        .copyWith(color: Colors.white),
                                  ),
                                )),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              dateTimeFormat.format(DateTime.now()),
                              style: AppTextStyles.digitsSubTitle2
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
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

  ///
  /// getting server data
  ///

  Future<void> _connectMqtt() async {
    setState(() {
      _showProgressBar = true;
    });
    try {
      await mqtt.connect();
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
    _online = message == "online";
    if (mounted) {
      setState(() {});
    }
  }

  ///
  /// Actions
  ///

  void performAction(Function() action) {
    setState(() {
      _showProgressBar = true;
    });
    action();
    setState(() {
      _showProgressBar = false;
    });
  }

  void pauseCharging() {
    mqtt.publish("everest_api/" + connector + "/cmd/pause_charging", "");
  }

  void setMaxCurrent(double maxCurrent) {
    mqtt.publish(Topic.setMaxCurrent, "$maxCurrent");
  }

  void resumeCharging() {
    mqtt.publish("everest_api/" + connector + "/cmd/resume_charging", "");
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
