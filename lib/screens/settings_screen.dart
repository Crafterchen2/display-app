import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/screens/simulation_panel.dart';
import 'package:pionixbox/screens/system_info.dart';
import 'package:pionixbox/screens/wifi_setup_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/widgets/buttons.dart';
import 'package:pionixbox/widgets/restart_widget.dart';
import 'package:pionixbox/widgets/settings_menu_button.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final mqtt = MQTT();
  bool localization = false;
  bool setup_simulation = false;
  bool setup_wifi = false;
  String selectedLanguage = 'english';

  void extractArguments(BuildContext context) {
    final i = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    localization = i["localization"];
    setup_simulation = i["setup_simulation"];
    setup_wifi = i["setup_wifi"];
    setState(() {});
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (setup_wifi)
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: SettingMenuButton(
                            icon: Icons.wifi_protected_setup,
                            title: tr('wifi_setup'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.settingScreen, arguments: {
                                'init': false,
                              });
                            },
                          ),
                        ),
                      if (setup_simulation)
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: SettingMenuButton(
                            icon: Icons.settings,
                            title: tr('simulation'),
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
                            title: tr('language'),
                            onPressed: () async {
                              debugPrint('Before');
                              final result = await Navigator.of(context)
                                  .pushNamed(AppRoutes.languagePickerScreen);
                              debugPrint(result.toString());
                              setState(() {});
                            },
                          ),
                        ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: SettingMenuButton(
                          icon: Icons.info_outline,
                          title: tr('system_info'),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const SystemInfo();
                            }));
                          },
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: SettingMenuButton(
                          icon: Icons.info_outline,
                          title: tr('reset'),
                          onPressed: () {
                            resetInitialised();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const PionixCloseButton(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void resetInitialised() {
    mqtt.publish(Topic.resetInitialized, '');
    RestartWidget.restartApp(context);
  }
}
