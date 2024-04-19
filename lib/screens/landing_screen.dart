import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/data/models/application_info.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/widgets/dialogs.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    Key? key,
  }) : super(key: key);

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
      setState(() {
        // _showProgress = false;
      });
    }

    setState(() {
      // _showProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(flex: 1, child: EverestLogoWidget()),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SquareButtonWidget(
                        text: 'private_mode'.tr(),
                        onPressed: () {
                          privateConfirmationDialog(context);
                        }),
                    SizedBox(width: screenWidth * 0.1),
                    SquareButtonWidget(
                        text: 'public_mode'.tr(),
                        onPressed: () {
                          publicConfirmationDialog(context);
                        })
                  ],
                ),
              ),
            )
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
                Navigator.of(context)
                    .pushNamed(AppRoutes.chargingDashboardScreen, arguments: {
                  'private_mode': true,
                });
              },
              onNegativePressed: () {
                Navigator.pop(context);
              });
        });
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
                Navigator.of(context)
                    .pushNamed(AppRoutes.chargingDashboardScreen, arguments: {
                  'private_mode': false,
                });
              },
              onNegativePressed: () {
                Navigator.pop(context);
              });
        });
  }
}

class SquareButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SquareButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: screenHeight * 0.45,
        width: screenHeight * 0.45,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading6.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
          ),
        ),
      ),
    );
  }
}

class InitializingProgressWidget extends StatelessWidget {
  final double? progress;

  const InitializingProgressWidget({Key? key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height * 0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              width: height * 0.5,
              child: LinearProgressIndicator(
                value: progress,
                color: Theme.of(context).colorScheme.secondary,
                backgroundColor: Colors.grey.shade300,
              )),
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
            ),
            child: Text(
              'initializing'.tr(),
              style:
                  AppTextStyles.subTitle4.copyWith(fontWeight: FontWeight.w700),
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

  const EverestLogoWidget({Key? key, this.height = 100, this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage(AppAssets.everestLogo),
      width: width,
      height: height,
    );
  }
}
