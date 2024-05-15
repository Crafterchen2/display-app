import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/utils/routing/app_router.dart';
import 'package:pionixbox/widgets/settings_menu_button.dart';

class SettingsMenu extends StatefulWidget {
  final bool setupWifi;
  final bool setupSimulation;
  final bool localization;
  final Future<void> Function(BuildContext) resetInitialised;
  final Future<void> Function(BuildContext) rebootCharger;
  final VoidCallback setParentState;
  final EdgeInsetsGeometry margin;
  const SettingsMenu({
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
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            adjustScale(10),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: adjustScale(10),
            runSpacing: adjustScale(10),
            children: [
              if (widget.setupWifi)
                SettingMenuButton(
                  icon: Icons.wifi_protected_setup,
                  title: tr('wifi_setup'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.wifiSetupScreen,
                      arguments: {
                        'init': false,
                      },
                    );
                  },
                ),
              if (widget.setupSimulation)
                SettingMenuButton(
                  icon: Icons.settings,
                  title: tr('simulation'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.simulationScreen);
                    //Navigator.of(context)
                    //    .pushReplacement(MaterialPageRoute(builder: (context) {
                    //  return const SimulationPanelLandscape();
                    //}));
                  },
                ),
              if (widget.localization)
                SettingMenuButton(
                  icon: Icons.language,
                  title: tr('language'),
                  onPressed: () async {
                    await Navigator.of(context)
                        .pushNamed(AppRoutes.languagePickerScreen)
                        .then((_) => setState(
                              () {},
                            ))
                        .then((_) => widget.setParentState());
                  },
                ),
              SettingMenuButton(
                icon: Icons.info_outline,
                title: tr('system_info'),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.systemInfo);
                },
              ),
              SettingMenuButton(
                icon: Icons.restore,
                title: tr('reset'),
                onPressed: () {
                  widget.resetInitialised(context);
                },
              ),
              SettingMenuButton(
                icon: Icons.restart_alt,
                title: tr('reboot'),
                onPressed: () {
                  widget.rebootCharger(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
