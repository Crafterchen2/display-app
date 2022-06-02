import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../widgets/buttons.dart';

class SimulationPanel extends StatefulWidget {
  // final VoidCallback plugInPressed;
  // final VoidCallback plugOutPressed;
  // final VoidCallback resumeByCarPressed;
  // final VoidCallback pauseByCarPressed;
  // final VoidCallback chargingSimulationPressed;
  // final VoidCallback enableSimulationPressed;
  // final VoidCallback disableSimulationPressed;
  // final VoidCallback closePanel;

  const SimulationPanel({
    Key? key,
    // required this.plugInPressed,
    // required this.plugOutPressed,
    // required this.resumeByCarPressed,
    // required this.pauseByCarPressed,
    // required this.chargingSimulationPressed,
    // required this.enableSimulationPressed,
    // required this.disableSimulationPressed,
    // required this.closePanel,
  }) : super(key: key);

  @override
  State<SimulationPanel> createState() => _SimulationPanelState();
}

class _SimulationPanelState extends State<SimulationPanel> {
  final mqtt = MQTT();

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.4;
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
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 30),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryAmber, shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
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
