import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/data/models/application_info.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/screens/private_charger_screen_demo.dart';
import 'package:pionixbox/screens/wifi_setup_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import 'lan_info_screen.dart';

class InitializingScreen extends StatefulWidget {
  const InitializingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<InitializingScreen> createState() => _InitializingScreenState();
}

class _InitializingScreenState extends State<InitializingScreen> {
  final mqtt = MQTT();
  late ApplicationInfo _appInfo;
  double _progress = 0.0;
  late Timer _timer;

  @override
  void didChangeDependencies() {
    _connect(context);
    startTimer();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(milliseconds: 20);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_progress == 1.0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _progress = _progress + 0.01;
          });
        }
      },
    );
  }

  void _connect(BuildContext context) async {
    try {
      await mqtt.connect();
      getAppInfo(context, mqtt);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
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
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _progress > 0.9
                ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SquareButtonWidget(
                            iconUrl: 'assets/icons/icon_wifi.svg',
                            text: 'WIFI',
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const WifiSetupScreen();
                              }));
                            }),
                        SquareButtonWidget(
                            iconUrl: 'assets/icons/icon_lan.svg',
                            text: 'LAN',
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const LanInfoScreen();
                              }));
                            })
                      ],
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          EverestLogoWidget(
                            width: screenHeight * 0.6,
                          ),
                          InitializingProgressWidget(progress: _progress),
                        ],
                      ),
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
    debugPrint('\n\nCurrent Lang: ${_appInfo.current_language}');
    debugPrint('Mode: ${_appInfo.mode}');
    debugPrint('Default Lang: ${_appInfo.default_language}');
    debugPrint('INIT: ${_appInfo.initialized}\n\n');
    if (_appInfo.current_language == 'unknown') {
      //
      updateDefaultLanguage();
      updateCurrentLanguage();
    }
    if (_appInfo.initialized) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return const PrivateChargerScreenDemo();
      }), (Route<dynamic> route) => false);
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
}

class SquareButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final String iconUrl;

  const SquareButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height = 200,
    this.width = 200,
    required this.iconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: screenWidth * 0.4,
        width: screenWidth * 0.4,
        child: Material(
          elevation: 3,
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                iconUrl,
                height: screenWidth * 0.2,
                width: screenWidth * 0.2,
              ),
              Text(text,
                  style: AppTextStyles.heading6
                      .copyWith(color: AppColors.primaryBlue)),
            ],
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
                color: Colors.greenAccent,
                backgroundColor: Colors.grey.shade300,
              )),
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
            ),
            child: Text(
              'INITIALIZING...',
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
