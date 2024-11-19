import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:display_app/data/models/application_info.dart';
import 'package:display_app/widgets/buttons.dart';
import 'package:display_app/widgets/dialogs.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    super.key,
  });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final mqtt = MQTT();
  late ApplicationInfo _appInfo;

  @override
  void didChangeDependencies() {
    _connect(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _connect(BuildContext context) async {
    try {
      await mqtt.connect();
      getAppInfo(context, mqtt);
    } catch (e) {
      debugPrint(
          'connecting MQTT server/ getting app info failed with exception: $e');
      setState(
        () {
          // _showProgress = false;
        },
      );
    }

    setState(
      () {
        // _showProgress = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
    * Using the screen size here (although we normally don't want to do that!)
    * is acceptable, as this screen only contains 2 Buttons and should
    * look the same for every screen.
    * Using the screen size as f.e. padding in lists is less acceptable, because of
    * possibly unpredictable stretching, moving etc.
    * */
    var sWidth = MediaQuery.of(context).size.width;
    var sHeight = MediaQuery.of(context).size.height;
    var buttonHeight = sHeight / 2 - 25;
    var buttonWidth = sWidth / 2 - 25;
    const double textScaleFactor = 1.6;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: EverestLogoWidget()),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: buttonHeight,
                    width: buttonWidth,
                    child: PrimaryButton(
                      onPressed: () {
                        privateConfirmationDialog(context);
                      },
                      child: Text(
                        'private_mode'.tr(),
                        textScaler: const TextScaler.linear(textScaleFactor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: buttonHeight,
                    width: buttonWidth,
                    child: PrimaryButton(
                      onPressed: () {
                        publicConfirmationDialog(context);
                      },
                      child: Text(
                        'public_mode'.tr(),
                        textScaler: const TextScaler.linear(textScaleFactor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void applicationInfo(String message) {
    final msg = jsonDecode(message);
    _appInfo = ApplicationInfo.fromJson(msg);
    if (_appInfo.current_language == 'unknown') {
      updateDefaultLanguage();
      updateCurrentLanguage();
    }
    if (_appInfo.initialized) {
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) {
      //   return const PrivateChargerScreenDemo();
      // }), (Route<dynamic> route) => false);
    }

    if (mounted) {
      setState(() {
        // _showProgress = false;
      });
    }
  }

  void getAppInfo(BuildContext context, MQTT mqtt) {
    mqtt.publish("everest_api/setup/cmd/get_application_info", '');
    mqtt.subscribe("everest_api/setup/var/application_info", applicationInfo);
  }

  void updateCurrentLanguage() {
    mqtt.publish(Topic.updateCurrentLanguage, "eng");
    setState(() {});
  }

  void updateDefaultLanguage() {
    mqtt.publish(Topic.updateDefaultLanguage, "eng");
    setState(() {});
  }

  void setMode(String mode) {
    mqtt.publish(Topic.setAppMode, mode);
    setState(() {});
  }

  Future<void> privateConfirmationDialog(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (ctz) {
        return BasicDialog(
          title: 'private_mode'.tr(),
          positiveText: 'private_mode_ok'.tr(),
          negativeText: 'cancel'.tr(),
          content: 'private_mode_explanation'.tr(),
          onPositivePressed: () {
            Navigator.pop(context);
            setMode('private');
            Navigator.of(context).pushNamed(
              AppRoutes.chargingDashboardScreen,
              arguments: {
                'private_mode': true,
              },
            );
          },
          onNegativePressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> publicConfirmationDialog(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (ctz) {
        return BasicDialog(
          title: 'public_mode'.tr(),
          positiveText: 'public_mode_ok'.tr(),
          negativeText: 'cancel'.tr(),
          content: 'public_mode_explanation'.tr(),
          onPositivePressed: () {
            Navigator.pop(context);
            setMode('public');
            Navigator.of(context).pushNamed(
              AppRoutes.chargingDashboardScreen,
              arguments: {
                'private_mode': false,
              },
            );
          },
          onNegativePressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class InitializingProgressWidget extends StatelessWidget {
  final double? progress;

  const InitializingProgressWidget({
    super.key,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              color: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Text(
              'initializing'.tr(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class EverestLogoWidget extends StatelessWidget {
  final double height;
  final double width;

  const EverestLogoWidget({super.key, this.height = 100, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage(AppAssets.everestLogo),
      width: width,
      height: height,
    );
  }
}
