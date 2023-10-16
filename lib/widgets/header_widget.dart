import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/widgets/buttons.dart';
import 'package:pionixbox/widgets/restart_widget.dart';

import '../mqtt.dart';
import '../screens/initializing_screen.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';
import 'dialogs.dart';

const everestLogo = 'assets/icons/everest_horizontal_color_logo.svg';
const rpiLogo = 'assets/icons/powered_by_raspberry_pi_logo_black.svg';
final targetPlatform = Platform.environment['PIONIXBOX_TARGET_PLATFORM'] ?? '';

const labelStyle = TextStyle(fontSize: 28);

class Header extends StatelessWidget {
  final mqtt = MQTT();
  final bool showSettingsIcon;
  final bool privateMode;
  final bool setupWifi;
  final bool setupSimulation;
  final bool localization;

  Header(
      {Key? key,
      required this.setupWifi,
      required this.setupSimulation,
      required this.localization,
      this.showSettingsIcon = false,
      this.privateMode = true})
      : super(key: key);

  void resetInitialised() {
    mqtt.publish(Topic.resetInitialized, '');
    setMode('unknown');
    //RestartWidget.restartApp(context);
  }

  void setMode(String mode) {
    mqtt.publish(Topic.setAppMode, mode);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint(MediaQuery.of(context).size.width.toString()+" - "+MediaQuery.of(context).size.height.toString()); //FIXME: remove later, used to verify min screen size
    return SizedBox(
      height: adjustScale(80),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: adjustScale(5),
              ),
              child: Row(
                children: [
                  const EverestLogoWidget(),
                  targetPlatform == "rpi"
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: SvgPicture.asset(
                              rpiLogo, // FIXME: make this configurable at build time!
                              //width: 72,
                              //height: 36,
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: (privateMode)
                    ? SpeedDial(
                        heroTag: PionixCloseButton.getHeroTag(),
                        direction: SpeedDialDirection.down,
                        icon: Icons.settings,
                        iconTheme: const IconThemeData(
                          size: 48,
                        ),
                        renderOverlay: true,
                        overlayColor: const Color.fromARGB(255, 64, 64, 64),
                        backgroundColor: AppColors.primaryBlue,
                        elevation: 20,
                        closeDialOnPop: true,
                        activeIcon: Icons.close,
                        useRotationAnimation: true,
                        childrenButtonSize: const Size(64, 64),
                        children: [
                          SpeedDialChild(
                            label: tr('wifi_setup'),
                            labelStyle: labelStyle,
                            backgroundColor: AppColors.primaryAmber,
                            visible: setupWifi,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.wifiSetupScreen,
                                arguments: {
                                  'init': false,
                                },
                              );
                            },
                            child: const Icon(
                              Icons.wifi_protected_setup,
                              color: AppColors.white,
                            ),
                          ),
                          SpeedDialChild(
                            label: tr('simulation'),
                            labelStyle: labelStyle,
                            backgroundColor: AppColors.primaryAmber,
                            visible: setupSimulation,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.simulationScreen);
                            },
                            child: const Icon(
                              Icons.settings,
                              color: AppColors.white,
                            ),
                          ),
                          SpeedDialChild(
                            label: tr('language'),
                            labelStyle: labelStyle,
                            backgroundColor: AppColors.primaryAmber,
                            visible: localization,
                            onTap: () async {
                              await Navigator.of(context)
                                  .pushNamed(AppRoutes.languagePickerScreen);
                              //.then(
                              //  (_) => setState(
                              //    () {},
                              //  ),
                              //)
                              //.then((_) => widget.setParentState());
                            },
                            child: const Icon(
                              Icons.language,
                              color: AppColors.white,
                            ),
                          ),
                          SpeedDialChild(
                            label: tr('system_info'),
                            labelStyle: labelStyle,
                            backgroundColor: AppColors.primaryAmber,
                            visible: true,
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.systemInfo);
                            },
                            child: const Icon(
                              Icons.info_outline,
                              color: AppColors.white,
                            ),
                          ),
                          SpeedDialChild(
                            label: tr('reset'),
                            labelStyle: labelStyle,
                            backgroundColor: Colors.red,
                            visible: true,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BasicDialog(
                                    title: 'reset_app_to_factory_defaults'.tr(),
                                    positiveText: 'reset'.tr(),
                                    negativeText: 'cancel'.tr(),
                                    content:
                                        'reset_app_to_factory_defaults_explanation'
                                            .tr(),
                                    onPositivePressed: () {
                                      Navigator.pop(context);
                                      mqtt.publish(Topic.resetInitialized, '');
                                      setMode('unknown');
                                      RestartWidget.restartApp(context);
                                    },
                                    onNegativePressed: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.restore,
                              color: AppColors.white,
                            ),
                          ),
                          SpeedDialChild(
                            label: tr('reboot'),
                            labelStyle: labelStyle,
                            backgroundColor: Colors.red,
                            visible: true,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctz) {
                                  return BasicDialog(
                                      title: 'reboot_charger'.tr(),
                                      positiveText: 'reboot'.tr(),
                                      negativeText: 'cancel'.tr(),
                                      content:
                                          'reboot_charger_explanation'.tr(),
                                      onPositivePressed: () {
                                        Navigator.pop(context);
                                        mqtt.publish(Topic.reboot, '');
                                      },
                                      onNegativePressed: () {
                                        Navigator.pop(context);
                                      });
                                },
                              );
                            },
                            child: const Icon(
                              Icons.restart_alt,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      )
                    : FloatingActionButton(
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                            AppRoutes.languagePickerScreen,
                          );
                        },
                        backgroundColor: AppColors.primaryBlue,
                        child: const Icon(
                          Icons
                              .language, //Icons.language --> privateMode ? Icons.settings : Icons.language,
                          color: AppColors.white,
                          size: 48,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
