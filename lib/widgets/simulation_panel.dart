import 'package:flutter/material.dart';
import 'package:pionixbox/main.dart';
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
    List<Widget> menuButtons = makeMenuButtons();
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      floatingActionButton: const PionixCloseButton(
        inverted: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: adjustScale(80),
          left: adjustScale(8),
          right: adjustScale(8),
          top: adjustScale(8),
        ),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: adjustScale(75),
              child: menuButtons[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemCount: menuButtons.length,
        ),
      ),
    );
  }

  List<Widget> makeMenuButtons() {
    return [
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
    ];
  }

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
