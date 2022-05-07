import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pionixbox/screens/simulation_panel.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/utils/helper.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../widgets/footer_widget.dart';
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
  bool _showSimulationPanel = false;
  bool _showProgressBar = false;
  final mqtt = MQTT();

  @override
  void initState() {
    _status = 'unplugged';
    _energyTotal = '12.3';
    _chargedEnergy = 12.3;
    _latestTotalw = 1000;
    _duration = '00:00:00';
    _connectMqtt();

    mqtt.subscribe(
        "everest_api/evse_manager/var/session_info", parseSessionInfo);

    super.initState();
  }

  void parseSessionInfo(String message) {
    final i = jsonDecode(message);
    debugPrint(i.toString());
    setState(() {
      _status = i["state"];
      _chargedEnergy = i["charged_energy_wh"] / 1000.0;
      _latestTotalw = i["latest_total_w"] / 1000.0;
      _energyTotal = (_chargedEnergy.toStringAsFixed(1) + " kWh");
      _duration = durationFormat(Duration(seconds: i["charging_duration_s"]));
    });

    setState(() {
      _showProgressBar = false;
    });
  }

  Future<void> _connectMqtt() async {
    setState(() {
      _showProgressBar = true;
    });
    await mqtt.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Header(
                onSettingsPressed: () {
                  setState(() {
                    _showSimulationPanel = true;
                  });
                },
              ),
              const Spacer(flex: 1),
              SessionInfoBody(
                state: _status,
                energy: _chargedEnergy,
                totalEnergy: _energyTotal,
                latestTotalw: _latestTotalw.toString(),
                duration: _duration,
                onPauseCharging: () => performAction(pauseCharging),
                onResumeCharging: () => performAction(resumeCharging),
              ),
              const Spacer(flex: 2),
              const Footer(),
            ],
          ),
          if (_showSimulationPanel)
            SimulationPanel(
              plugInPressed: () => performAction(plugIn),
              plugOutPressed: () => performAction(plugOut),
              resumeByCarPressed: () => performAction(resumeByCar),
              pauseByCarPressed: () => performAction(pauseByCar),
              chargingSimulationPressed: () =>
                  performAction(chargingSimulation),
              enableSimulationPressed: () => performAction(enableSimulation),
              disableSimulationPressed: () => performAction(disableSimulation),
              closePanel: () {
                setState(() {
                  _showSimulationPanel = false;
                });
              },
            ),
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
}
