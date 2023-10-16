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
        padding: const EdgeInsets.symmetric(horizontal: 8.0,),
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

  List<Widget> makeMenuButtons(){
    return [
      PrimaryButton(
        title: 'Plug In',
        onPressed: plugIn,
      ),
      PrimaryButton(
        title: 'Plug Out',
        onPressed: plugOut,
      ),
      PrimaryButton(
        title: 'Resume by car',
        onPressed: resumeByCar,
      ),
      PrimaryButton(
        title: 'Pause by car',
        onPressed: pauseByCar,
      ),
      PrimaryButton(
        title: 'Enable Simulation',
        onPressed: enableSimulation,
      ),
      PrimaryButton(
        title: 'Disable Simulation',
        onPressed: disableSimulation,
      ),
      PrimaryButton(
        title: 'Charging Simulation',
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