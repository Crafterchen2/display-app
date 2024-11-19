import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:display_app/main.dart';
import 'package:display_app/widgets/buttons.dart';

import '../mqtt.dart';
import '../screens/initializing_screen.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';

const everestLogo = 'assets/icons/everest_horizontal_color_logo.svg';
const rpiLogo = 'assets/icons/powered_by_raspberry_pi_logo_black.svg';
final targetPlatform =
    Platform.environment['DISPLAY_APP_TARGET_PLATFORM'] ?? '';

const labelStyle = TextStyle(fontSize: 28);

class Header extends StatelessWidget {
  final mqtt = MQTT();
  final bool showSettingsIcon;
  final bool privateMode;
  final bool setupWifi;
  final bool setupSimulation;
  final bool localization;

  Header(
      {super.key,
      required this.setupWifi,
      required this.setupSimulation,
      required this.localization,
      this.showSettingsIcon = false,
      this.privateMode = true});

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
                    ? FloatingActionButton(
                        heroTag: PionixCloseButton.getHeroTag(),
                        elevation: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 48,
                        ),
                      )
                    : FloatingActionButton(
                        heroTag: PionixCloseButton.getHeroTag(),
                        elevation: 20,
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                            AppRoutes.languagePickerScreen,
                          );
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Icons.language,
                          color: Theme.of(context).colorScheme.onPrimary,
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
