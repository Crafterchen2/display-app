import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../widgets/buttons.dart';

class SimulationPanel extends StatelessWidget {
  final VoidCallback plugInPressed;
  final VoidCallback plugOutPressed;
  final VoidCallback resumeByCarPressed;
  final VoidCallback pauseByCarPressed;
  final VoidCallback chargingSimulationPressed;
  final VoidCallback enableSimulationPressed;
  final VoidCallback disableSimulationPressed;
  final VoidCallback closePanel;

  const SimulationPanel({
    Key? key,
    required this.plugInPressed,
    required this.plugOutPressed,
    required this.resumeByCarPressed,
    required this.pauseByCarPressed,
    required this.chargingSimulationPressed,
    required this.enableSimulationPressed,
    required this.disableSimulationPressed,
    required this.closePanel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.4;
    return Container(
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
                    onPressed: plugInPressed,
                  ),
                  const SizedBox(width: 8),
                  PrimaryButton2(
                    width: buttonWidth,
                    title: 'Plug Out',
                    onPressed: plugOutPressed,
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
                    onPressed: resumeByCarPressed,
                  ),
                  const SizedBox(width: 8),

                  PrimaryButton2(
                    width: buttonWidth,
                    title: 'Pause by car',
                    onPressed: pauseByCarPressed,
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
                    onPressed: enableSimulationPressed,
                  ),
                  const SizedBox(width: 8),

                  PrimaryButton2(
                    width: buttonWidth,
                    title: 'Disable Simulation',
                    onPressed: disableSimulationPressed,
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
                    onPressed: chargingSimulationPressed,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: closePanel,
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
    );
  }
}
