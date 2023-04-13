import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import 'buttons.dart';

class SimulationPanel extends StatefulWidget {
  const SimulationPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<SimulationPanel> createState() => _SimulationPanelState();
}

class _SimulationPanelState extends State<SimulationPanel> {
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

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 2,
              ),
              children: [
                PrimaryButton2(
                  title: 'Plug In',
                  onPressed: plugIn,
                ),
                PrimaryButton2(
                  title: 'Plug Out',
                  onPressed: plugOut,
                ),
                PrimaryButton2(
                  title: 'Resume by car',
                  onPressed: resumeByCar,
                ),
                PrimaryButton2(
                  title: 'Pause by car',
                  onPressed: pauseByCar,
                ),
                PrimaryButton2(
                  title: 'Enable Simulation',
                  onPressed: enableSimulation,
                ),
                PrimaryButton2(
                  title: 'Disable Simulation',
                  onPressed: disableSimulation,
                ),
                PrimaryButton2(
                  title: 'Charging Simulation',
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
