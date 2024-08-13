import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/widgets/dialogs.dart';
import 'package:pionixbox/widgets/buttons.dart';
import 'package:pionixbox/widgets/restart_widget.dart';
import 'package:pionixbox/widgets/settings_menu.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';

@Deprecated("The Settings have been made obsolete by the NavigationDrawer.")
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
  bool setupSimulation = false;
  bool setupWifi = false;
  String selectedLanguage = 'english';

  void extractArguments(BuildContext context) {
    final i = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    localization = i["localization"];
    setupSimulation = i["setup_simulation"];
    setupWifi = i["setup_wifi"];
    setState(() {});
  }

  void rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    extractArguments(context);
    return Scaffold(
      floatingActionButton: const PionixCloseButton(
        inverted: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SettingsMenu(
        setupWifi: setupWifi,
        setupSimulation: setupSimulation,
        localization: localization,
        resetInitialised: resetConfirmationDialog,
        rebootCharger: rebootConfirmationDialog,
        setParentState: rebuild,
      ),
    );
  }

  void setMode(String mode) {
    mqtt.publish(Topic.setAppMode, mode);
    setState(() {});
  }

  void resetInitialised() {
    mqtt.publish(Topic.resetInitialized, '');
    setMode('unknown');
    RestartWidget.restartApp(context);
  }

  void reboot() {
    mqtt.publish(Topic.reboot, '');
  }

  Future<void> resetConfirmationDialog(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (ctz) {
        return BasicDialog(
          title: 'reset_app_to_factory_defaults'.tr(),
          positiveText: 'reset'.tr(),
          negativeText: 'cancel'.tr(),
          content: 'reset_app_to_factory_defaults_explanation'.tr(),
          onPositivePressed: () {
            Navigator.pop(context);
            resetInitialised();
          },
          onNegativePressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> rebootConfirmationDialog(
    BuildContext context,
  ) async {
    showDialog(
        context: context,
        builder: (ctz) {
          return BasicDialog(
            //No reference to model name, but this is deprecated anyway. --> WONTFIX
              title: 'reboot_belaybox'.tr(),
              positiveText: 'reboot'.tr(),
              negativeText: 'cancel'.tr(),
              //No reference to model name, but this is deprecated anyway. --> WONTFIX
              content: 'reboot_belaybox_explanation'.tr(),
              onPositivePressed: () {
                Navigator.pop(context);
                reboot();
              },
              onNegativePressed: () {
                Navigator.pop(context);
              });
        });
  }
}
