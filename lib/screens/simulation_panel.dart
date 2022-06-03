import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../widgets/buttons.dart';

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
    final buttonWidth = MediaQuery.of(context).size.width * 0.4;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: AppColors.primaryBlue,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton2(
                      width: buttonWidth,
                      title: 'Plug In',
                      onPressed: plugIn,
                    ),
                    const SizedBox(width: 8),
                    PrimaryButton2(
                      width: buttonWidth,
                      title: 'Plug Out',
                      onPressed: plugOut,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton2(
                      width: buttonWidth,
                      title: 'Resume by car',
                      onPressed: resumeByCar,
                    ),
                    const SizedBox(width: 8),
                    PrimaryButton2(
                      width: buttonWidth,
                      title: 'Pause by car',
                      onPressed: pauseByCar,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton2(
                      width: buttonWidth,
                      title: 'Enable Simulation',
                      onPressed: enableSimulation,
                    ),
                    const SizedBox(width: 8),
                    PrimaryButton2(
                      width: buttonWidth,
                      title: 'Disable Simulation',
                      onPressed: disableSimulation,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton2(
                      width: MediaQuery.of(context).size.width * 0.6,
                      title: 'Charging Simulation',
                      onPressed: chargingSimulation,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
            const PionixCloseButton(
              color: AppColors.primaryAmber,
            ),
          ],
        ),
      ),
    );
  }

  // void performAction(Function() action) {
  //   action();
  // }

  void pauseCharging() {
    mqtt.publish(Topic.pauseChargingTopic, "");
    Navigator.pop(context);
  }

  void resumeCharging() {
    mqtt.publish(Topic.resumeChargingTopic, "");
    Navigator.pop(context);
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
