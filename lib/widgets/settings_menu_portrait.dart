import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/widgets/simulation_panel.dart';
import 'package:pionixbox/screens/system_info.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/utils/routing/app_router.dart';
import 'package:pionixbox/widgets/settings_menu_button.dart';

class SettingsMenuPortrait extends StatelessWidget {
  final bool setup_wifi;
  final bool setup_simulation;
  final bool localization;
  final Future<void> Function(BuildContext) resetInitialised;
  final Future<void> Function(BuildContext) rebootCharger;

  const SettingsMenuPortrait({
    Key? key,
    required this.setup_wifi,
    required this.setup_simulation,
    required this.localization,
    required this.resetInitialised,
    required this.rebootCharger,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(12),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          crossAxisCount: 2,
        ),
        children: [
          SettingMenuButton(
            icon: Icons.wifi_protected_setup,
            title: tr('wifi_setup'),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.wifiSetupScreen, arguments: {
                'init': false,
              });
            },
          ),
          if (setup_simulation)
            SettingMenuButton(
              icon: Icons.settings,
              title: tr('simulation'),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const SimulationPanel();
                }));
              },
            ),
          if (localization)
            SettingMenuButton(
              icon: Icons.language,
              title: tr('language'),
              onPressed: () async {
                await Navigator.of(context)
                    .pushNamed(AppRoutes.languagePickerScreen);
              },
            ),
          SettingMenuButton(
            icon: Icons.info_outline,
            title: tr('system_info'),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const SystemInfo();
              }));
            },
          ),
          SettingMenuButton(
            icon: Icons.restore,
            title: tr('reset'),
            onPressed: () {
              resetInitialised(context);
            },
          ),
          SettingMenuButton(
            icon: Icons.restore,
            title: tr('reboot'),
            onPressed: () {
              rebootCharger(context);
            },
          ),
        ],
      ),
    ));
  }
}
