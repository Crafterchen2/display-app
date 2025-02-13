import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:display_app/data/models/application_info.dart';
import 'package:display_app/main.dart';
import 'package:display_app/theme/app_colors.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';

class InitializingScreen extends StatefulWidget {
  const InitializingScreen({
    super.key,
  });

  @override
  State<InitializingScreen> createState() => _InitializingScreenState();
}

class _InitializingScreenState extends State<InitializingScreen> {
  final mqtt = MQTT();
  late ApplicationInfo _appInfo;
  double _progress = 0.0;
  bool waitingIndicator = true;
  late Timer _timer;
  Timer? _reconnectMessageTimer;
  Timer? _reconnectTimer;
  String progressMessage = 'initializing'.tr();

  @override
  void didChangeDependencies() {
    _appInfo = ApplicationInfo('null', 'null', false, 'null', "");
    _connect(context);
    startTimer();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    _reconnectTimer?.cancel();
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
          if (mounted) {
            // needed or hot restart will fail :(
            setState(() {
              _progress = _progress + 0.01;
            });
          }
        }
      },
    );
  }

  void _connect(BuildContext context) async {
    try {
      progressMessage = 'initializing'.tr();
      await mqtt.connect();
      getAppInfo(context, mqtt);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
      progressMessage = 'connection_failed'.tr();
      // reconnecting...
      _reconnectMessageTimer = Timer(const Duration(seconds: 3),
          () => progressMessage = 'reconnecting'.tr());
      _reconnectTimer =
          Timer(const Duration(seconds: 5), () => _connect(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Padding(
        padding: EdgeInsets.all(adjustScale(10)),
        child: SizedBox.expand(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                waitingIndicator
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Expanded(
                              child: EverestLogoWidget(),
                            ),
                            Divider(
                              height: adjustScale(20),
                              indent: adjustScale(20),
                              endIndent: adjustScale(20),
                            ),
                            LinearProgressIndicator(
                              minHeight: adjustScale(10),
                            ),
                            Text(
                              progressMessage.toUpperCase(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.wifiSetupScreen,
                                    arguments: {
                                      'init': true,
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/icon_wifi.svg',
                                    ),
                                    Text(
                                      'wifi'.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              width: 20,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.lanInfoScreen,
                                    arguments: {
                                      'init': true,
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/icon_lan.svg',
                                    ),
                                    Text(
                                      'lan'.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
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

    if (mounted) {
      if (_appInfo.mode != 'null') {
        if (_appInfo.initialized) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              _appInfo.mode == 'unknown'
                  ? AppRoutes.landingScreen
                  : AppRoutes.chargingDashboardScreen,
              (Route<dynamic> route) => false,
              arguments: {
                'private_mode': _appInfo.mode == 'private',
              });
        } else {
          waitingIndicator = false;
        }
      }
    }
    if (mounted) {
      setState(() {
        // _showProgress = false;
      });
    }
  }

  void controlAvailable(String message) {
    if (message == "true") {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.chargingDashboardScreen, (Route<dynamic> route) => false,
            arguments: {
              'private_mode': true,
            });
      } else {
        waitingIndicator = false;
      }
    }
    if (mounted) {
      setState(() {
        // _showProgress = false;
      });
    }
  }

  void getAppInfo(BuildContext context, MQTT mqtt) {
    mqtt.subscribe("everest_api/setup/var/application_info", applicationInfo);
    mqtt.subscribe("everest_api/control/var/available", controlAvailable);
    mqtt.publish("everest_api/setup/cmd/get_application_info", '');
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

class InitializingProgressWidget extends StatelessWidget {
  final double? progress;
  final String message;

  const InitializingProgressWidget(
      {super.key, this.progress, this.message = 'INITIALIZING...'});

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
              color: Theme.of(context).colorScheme.tertiaryContainer,
              backgroundColor:
                  Theme.of(context).colorScheme.onTertiaryContainer,
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
    return const AspectRatio(
      aspectRatio: 3,
      child: Image(
        image: AssetImage(AppAssets.everestLogo),
        //width: width,
        //height: height,
      ),
    );
  }
}
