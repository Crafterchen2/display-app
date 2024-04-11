import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import 'buttons.dart';

class SimulationPanelLandscape extends StatefulWidget {
  const SimulationPanelLandscape({
    Key? key,
  }) : super(key: key);

  @override
  State<SimulationPanelLandscape> createState() => _SimulationPanelLandscapeState();
}

class _SimulationPanelLandscapeState extends State<SimulationPanelLandscape> {
  final mqtt = MQTT();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Column(
        children: [
          Expanded(
            child: GridView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 4.5,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              children: [
                PrimaryButton(
                  child: const Text('Plug In'),
                  onPressed: plugIn,
                ),
                PrimaryButton(
                  child: const Text('Plug Out'),
                  onPressed: plugOut,
                ),
                PrimaryButton(
                  child: const Text('Resume by car'),
                  onPressed: resumeByCar,
                ),
                PrimaryButton(
                  child: const Text('Pause by car'),
                  onPressed: pauseByCar,
                ),
                PrimaryButton(
                  child: const Text('Enable Simulation'),
                  onPressed: enableSimulation,
                ),
                PrimaryButton(
                  child: const Text('Disable Simulation'),
                  onPressed: disableSimulation,
                ),
                PrimaryButton(
                  child: const Text('Charging Simulation'),
                  onPressed: chargingSimulation,
                ),
              ],
            ),
          ),
          const PionixCloseButton(
            color: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  // void performAction(Function() action) {
  //   action();
  // }

  void pauseByCar() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.pausedByCar);
    Navigator.pop(context);
  }

  void resumeByCar() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.resumeByCar);
    Navigator.pop(context);
    setState(() {});
  }

  void plugIn() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.plugIn);
    Navigator.pop(context);
    setState(() {});
  }

  void plugOut() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.plugOut);
    Navigator.pop(context);
    setState(() {});
  }

  void chargingSimulation() {
    mqtt.publish(Topic.modifyChargingSessionTopic, Payloads.chargingSimulation);
    Navigator.pop(context);
    setState(() {});
  }

  void enableSimulation() {
    mqtt.publish(Topic.enableSimulationTopic, Payloads.enableSimulation);
    Navigator.pop(context);
    setState(() {});
  }

  void disableSimulation() {
    mqtt.publish(Topic.enableSimulationTopic, Payloads.disableSimulation);
    Navigator.pop(context);
    setState(() {});
  }
}
