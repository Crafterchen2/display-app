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
    return Container(
      color: AppColors.primaryBlue,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                    title: 'Plug In',
                    onPressed: plugInPressed,
                    color: AppColors.successLight,
                  ),
                  PrimaryButton(
                    title: 'Plug Out',
                    onPressed: plugOutPressed,
                    color: AppColors.errorLight,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                    title: 'Resume by car',
                    onPressed: resumeByCarPressed,
                    color: AppColors.successLight,
                  ),
                  PrimaryButton(
                    title: 'Pause by car',
                    onPressed: pauseByCarPressed,
                    color: AppColors.errorLight,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                    title: 'Enable Simulation',
                    onPressed: enableSimulationPressed,
                    color: AppColors.successLight,
                  ),
                  PrimaryButton(
                    title: 'Disable Simulation',
                    onPressed: disableSimulationPressed,
                    color: AppColors.errorLight,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                    title: 'Charging Simulation',
                    onPressed: chargingSimulationPressed,
                    color: AppColors.errorLight,
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
