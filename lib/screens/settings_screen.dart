import 'package:flutter/material.dart';
import 'package:pionixbox/screens/simulation_panel.dart';
import 'package:pionixbox/screens/wifi_setup_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/widgets/settings_menu_button.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool localization = false;
  bool setup_simulation = false;
  bool setup_wifi = false;

  void extractArguments(BuildContext context) {
    final i = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    localization = i["localization"];
    setup_simulation = i["setup_simulation"];
    setup_wifi = i["setup_wifi"];
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    extractArguments(context);
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
                    if (setup_wifi)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: SettingMenuButton(
                          icon: Icons.wifi_protected_setup,
                          title: 'Wifi Setup',
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const WifiSetupScreen();
                            }));
                          },
                        ),
                      ),
                    if (setup_simulation)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: SettingMenuButton(
                          icon: Icons.settings,
                          title: 'Simulation',
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const SimulationPanel();
                            }));
                          },
                        ),
                      ),
                    if (localization)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: SettingMenuButton(
                          icon: Icons.language,
                          title: 'Language',
                          onPressed: () {
                            // Navigator.of(context)
                            //     .pushNamed(AppRoutes.languagePickerScreen);
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: screenWidth * 0.02),
              child: InkWell(
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
            ),
          ],
        ),
      ),
    );
  }
}
