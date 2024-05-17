import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/charger_info.dart';
import 'package:pionixbox/data/models/hlc_log.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/data/providers/charger_info_provider.dart';
import 'package:pionixbox/data/providers/connector_provider.dart';
import 'package:pionixbox/data/providers/ev_info_provider.dart';
import 'package:pionixbox/data/providers/hardware_capabilities_provider.dart';
import 'package:pionixbox/data/providers/hlc_log_provider.dart';
import 'package:pionixbox/data/providers/limits_provider.dart';
import 'package:pionixbox/data/providers/powermeter_provider.dart';
import 'package:pionixbox/data/providers/selected_protocol_provider.dart';
import 'package:pionixbox/data/providers/session_info_provider.dart';
import 'package:pionixbox/data/providers/telemetry_provider.dart';
import 'package:pionixbox/utils/circular_queue.dart';
import 'package:pionixbox/utils/constants/helper.dart';
import 'package:pionixbox/utils/enums.dart';
import 'package:pionixbox/utils/globals.dart';
import 'package:pionixbox/widgets/layout.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/datetime_formats.dart';
import '../utils/routing/app_router.dart';
import '../widgets/dialogs.dart';
import '../widgets/header_widget.dart';
import '../widgets/restart_widget.dart';
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
  late String _energyTotal;
  late double _chargedEnergy;
  late double _latestTotalw;
  late String _duration;
  late double _power;
  ChargerInfo? chargerInfo;
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
  String selectedProtocolString = "";
  // List<HlcLog> hlcLogList = [];

  final mqtt = MQTT();

  @override
  void initState() {
    _status = 'unplugged';
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
    _connect();
    super.didChangeDependencies();
  }

  void parseHlcLogMsg(String message) {
    // debugPrint("Parsing $message");
    HlcLog log = parseHlcLog(message);
    hlcLogList.add(log);
  }

  void parseLoggingPathMsg(String message) {
    // debugPrint("Parsing $message");
    loggingPath = message;
  }

  void _connect() async {
    try {
      await mqtt.connect();
      final connector = ref.watch(connectorProvider);
      mqtt.subscribe(
          "everest_api/" + connector + "/var/hlc_log", parseHlcLogMsg);
      mqtt.subscribe("everest_api/" + connector + "/var/logging_path",
          parseLoggingPathMsg);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    extractArguments(context);
    connector = ref.watch(connectorProvider);
    final chargerinfo =
        ref.watch(chargerInfoStreamProvider).whenOrNull(data: (data) => data);
    if (chargerinfo != null) {
      chargerInfo = chargerinfo;
    }
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

    final selectedProtocol = ref
        .watch(selectedProtocolStreamProvider)
        .whenOrNull(data: (data) => data);
    if (selectedProtocol != null) {
      selectedProtocolString = selectedProtocol;
      if (selectedProtocol == "IEC61851-1") {
        chargingMode = ChargingMode.basicAC;
      } else if (selectedProtocol == "DIN70121") {
        chargingMode = ChargingMode.dinDC;
      } else if (selectedProtocol == "ISO15118-2-2013") {
        if (powerMeter.voltage_V != null && powerMeter.voltage_V!.DC != null) {
          chargingMode = ChargingMode.isoDC;
        } else {
          chargingMode = ChargingMode.isoAC;
        }
      } else if (selectedProtocol == "ISO15118-2-2010") {
        if (powerMeter.voltage_V != null && powerMeter.voltage_V!.DC != null) {
          chargingMode = ChargingMode.isoDC;
        } else {
          chargingMode = ChargingMode.isoAC;
        }
      } else {
        chargingMode = ChargingMode.unknown;
        selectedProtocolString = "";
      }
    }

    return Scaffold(
      endDrawer: NavigationDrawer(
        //TODO Handle with theme!
        backgroundColor: Theme.of(context).colorScheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 20,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Text(
              "Navigation", //TODO Localisation
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 5,
              right: 10,
              top: 10,
            ),
            child: FilledButton.icon(
              onPressed: (ref
                          .watch(powermeterStreamProvider)
                          .whenOrNull(data: (data) => data) !=
                      null)
                  ? () async {
                      await Navigator.of(context).pushNamed(
                          AppRoutes.sessionDetailScreen,
                          arguments: {}).then(
                        (value) {
                          setState(() {});
                        },
                      );
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 20,
                          duration: const Duration(
                            seconds: 2,
                          ),
                          content: const Text(
                              'You are offline. Try again or check wifi Settings.'), //TODO: Localization
                          action: SnackBarAction(
                            label: 'Open Wifi settings', //TODO: Localization
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.wifiSetupScreen,
                                arguments: {
                                  'init': false,
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.details),
              label: Text(
                "Details", //TODO Localisation
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 5,
              right: 10,
            ),
            child: FilledButton.icon(
              onPressed: () async {
                await Navigator.of(context).pushNamed(AppRoutes.hlcLogScreen);
              },
              icon: const Icon(Icons.compare_arrows),
              label: Text(
                "HLC log", //TODO Localisation
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Text(
              "Einstellungen", //TODO Localisation
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 5,
              right: 10,
              top: 10,
            ),
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.wifiSetupScreen,
                  arguments: {
                    'init': false,
                  },
                );
              },
              label: Text(
                tr('wifi_setup'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              icon: const Icon(Icons.wifi_protected_setup),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 5,
              right: 10,
            ),
            child: FilledButton.icon(
              onPressed: () async {
                await Navigator.of(context)
                    .pushNamed(AppRoutes.languagePickerScreen);
              },
              label: Text(
                tr('language'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              icon: const Icon(Icons.language),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 5,
              right: 10,
            ),
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.systemInfo);
              },
              label: Text(
                tr('system_info'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              icon: const Icon(Icons.info_outline),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 5,
              right: 10,
            ),
            child: FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return BasicDialog(
                      title: 'reset_app_to_factory_defaults'.tr(),
                      positiveText: 'reset'.tr(),
                      negativeText: 'cancel'.tr(),
                      content: 'reset_app_to_factory_defaults_explanation'.tr(),
                      onPositivePressed: () {
                        Navigator.pop(context);
                        mqtt.publish(Topic.resetInitialized, '');
                        mqtt.publish(Topic.setAppMode, 'unknown');
                        RestartWidget.restartApp(context);
                      },
                      onNegativePressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              style: Theme.of(context).filledButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).colorScheme.error)),
              label: Text(
                tr('reset'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
              ),
              icon: Icon(
                Icons.restore,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 5,
              right: 10,
            ),
            child: FilledButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctz) {
                    return BasicDialog(
                        title: 'reboot_charger'.tr(),
                        positiveText: 'reboot'.tr(),
                        negativeText: 'cancel'.tr(),
                        content: 'reboot_charger_explanation'.tr(),
                        onPositivePressed: () {
                          Navigator.pop(context);
                          mqtt.publish(Topic.reboot, '');
                        },
                        onNegativePressed: () {
                          Navigator.pop(context);
                        });
                  },
                );
              },
              style: Theme.of(context).filledButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).colorScheme.error)),
              label: Text(
                tr('reboot'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
              ),
              icon: Icon(
                Icons.restart_alt,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 5,
              right: 10,
            ),
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.simulationScreen);
              },
              label: Text(
                tr('simulation'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      //reminder: this is body of scaffold
      body: Stack(
        children: [
          BorderLayout(
            widgets: {
              BorderLayoutSlot.north: Header(
                localization: localization,
                setupSimulation: simulation,
                setupWifi: wifi,
                privateMode: privateMode,
              ),
              BorderLayoutSlot.center: makeSessionInfoBody(context),
              BorderLayoutSlot.south: makeFooterBar(),
            },
          ),
          if (_showProgressBar)
            Center(
              child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .background, //Needed to block view of underlying UI
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ],
      ),
    );
  }

  String getChargerModelName() {
    if (chargerInfo != null) {
      return chargerInfo!.model_name ?? "";
    }
    return "";
  }

  StatefulWidget makeSessionInfoBody(BuildContext context) {
    return SessionInfoBody(
      state: _status,
      stateInfo: "",
      energy: _chargedEnergy,
      totalEnergy: _energyTotal,
      power: _power,
      latestTotalw: _latestTotalw,
      duration: _duration,
      online: _online,
      seeMorePressed: (ref
                  .watch(powermeterStreamProvider)
                  .whenOrNull(data: (data) => data) !=
              null)
          ? () async {
              /*final result = */ await Navigator.of(context)
                  .pushNamed(AppRoutes.sessionDetailScreen, arguments: {}).then(
                (value) {
                  setState(() {});
                },
              );
            }
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  elevation: 20,
                  duration: const Duration(
                    seconds: 2,
                  ),
                  content: const Text(
                      'You are offline. Try again or check wifi Settings.'), //TODO: Localization
                  action: SnackBarAction(
                    label: 'Open Wifi settings', //TODO: Localization
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.wifiSetupScreen,
                        arguments: {
                          'init': false,
                        },
                      );
                    },
                  ),
                ),
              );
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
      chargerModelName: getChargerModelName(),
    );
  }

  Column makeFooterBar() {
    return Column(
      children: [
        Divider(
          thickness: 3,
          color: Colors.grey.shade300,
          height: 4,
        ),
        Row(
          children: [
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _online
                            ? Theme.of(context).colorScheme.tertiaryContainer
                            : Theme.of(context).colorScheme.errorContainer,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        child: Text(
                          _online ? 'online'.tr() : 'offline'.tr(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      selectedProtocolString,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      dateTimeFormat.format(DateTime.now()),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  ScrollPhysics makeScrollPhysics() {
    ScrollPhysics physics = const BouncingScrollPhysics();
    final ScrollPhysics mergedPhysics =
        physics.applyTo(const AlwaysScrollableScrollPhysics());
    return mergedPhysics;
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
