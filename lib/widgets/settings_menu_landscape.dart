import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/widgets/simulation_panel_landscape.dart';
import 'package:pionixbox/screens/system_info.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/utils/routing/app_router.dart';
import 'package:pionixbox/widgets/settings_menu_button.dart';

class SettingsMenuLandscape extends StatefulWidget {
  final bool setupWifi;
  final bool setupSimulation;
  final bool localization;
  final Future<void> Function(BuildContext) resetInitialised;
  final Future<void> Function(BuildContext) rebootCharger;
  final VoidCallback setParentState;
  final EdgeInsetsGeometry margin;
  const SettingsMenuLandscape({
    Key? key,
    required this.setupWifi,
    required this.setupSimulation,
    required this.localization,
    required this.resetInitialised,
    required this.rebootCharger,
    required this.setParentState,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  }) : super(key: key);

  @override
  State<SettingsMenuLandscape> createState() => _SettingsMenuLandscapeState();
}

class _SettingsMenuLandscapeState extends State<SettingsMenuLandscape> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: [
        GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            shrinkWrap: true,
            children: [
              if (widget.setupWifi)
                Container(
                  margin: widget.margin,
                  child: SettingMenuButton(
                    icon: Icons.wifi_protected_setup,
                    title: tr('wifi_setup'),
                    style: AppTextStyles.horizontalMenuButton,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.wifiSetupScreen, arguments: {
                        'init': false,
                      });
                    },
                  ),
                ),
              if (widget.setupSimulation)
                Container(
                  margin: widget.margin,
                  child: SettingMenuButton(
                    icon: Icons.settings,
                    title: tr('simulation'),
                    style: AppTextStyles.horizontalMenuButton,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const SimulationPanelLandscape();
                      }));
                    },
                  ),
                ),
              if (widget.localization)
                Container(
                  margin: widget.margin,
                  child: SettingMenuButton(
                    icon: Icons.language,
                    title: tr('language'),
                    style: AppTextStyles.horizontalMenuButton,
                    onPressed: () async {
                      await Navigator.of(context)
                          .pushNamed(AppRoutes.languagePickerScreen)
                          .then((_) => setState(
                                () {},
                              ))
                          .then((_) => widget.setParentState());
                    },
                  ),
                ),
              Container(
                margin: widget.margin,
                child: SettingMenuButton(
                  icon: Icons.info_outline,
                  title: tr('system_info'),
                  style: AppTextStyles.horizontalMenuButton,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const SystemInfo();
                    }));
                  },
                ),
              ),
              Container(
                margin: widget.margin,
                child: SettingMenuButton(
                  icon: Icons.restore,
                  title: tr('reset'),
                  style: AppTextStyles.horizontalMenuButton,
                  onPressed: () {
                    widget.resetInitialised(context);
                  },
                ),
              ),
              Container(
                margin: widget.margin,
                child: SettingMenuButton(
                  icon: Icons.restart_alt,
                  title: tr('reboot'),
                  style: AppTextStyles.horizontalMenuButton,
                  onPressed: () {
                    widget.rebootCharger(context);
                  },
                ),
              ),
            ]),
      ],
    ));
  }
}
