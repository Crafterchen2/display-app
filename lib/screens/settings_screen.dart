import 'package:flutter/material.dart';
import 'package:pionixbox/screens/simulation_panel.dart';
import 'package:pionixbox/screens/wifi_setup_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/widgets/settings_menu_button.dart';

import '../routing/app_router.dart';
import '../widgets/buttons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                    SettingMenuButton(
                      icon: Icons.wifi_protected_setup,
                      title: 'Wifi Setup',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return const WifiSetupScreen();
                            }));
                      },
                    ),
                    SizedBox(width: screenWidth * 0.1),
                    SettingMenuButton(
                      icon: Icons.settings,
                      title: 'Simulation',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return const SimulationPanel();
                        }));
                      },
                    ),
                    SizedBox(width: screenWidth * 0.1),
                    SettingMenuButton(
                      icon: Icons.language,
                      title: 'Language',
                      onPressed: () {
                        // Navigator.of(context)
                        //     .pushNamed(AppRoutes.languagePickerScreen);
                      },
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.1),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        color: AppColors.primaryBlue,
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
}
