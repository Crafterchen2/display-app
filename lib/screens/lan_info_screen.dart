import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/data/models/network_device_info.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/screens/landing_screen.dart';
import 'package:pionixbox/widgets/buttons.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../utils/routing/app_router.dart';

class LanInfoScreen extends StatefulWidget {
  const LanInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LanInfoScreen> createState() => _LanInfoScreenState();
}

class _LanInfoScreenState extends State<LanInfoScreen> {
  final mqtt = MQTT();
  List<NetworkDeviceInfo> devices = [];

  bool _showProgress = true;
  bool _connected = false;

  @override
  void initState() {
    _connect();

    super.initState();
  }

  void networkDeviceInfo(String message) {
    final deviceInfo = jsonDecode(message);
    devices.clear();
    for (final d in deviceInfo) {
      final device = NetworkDeviceInfo.fromJson(d);
      if (!device.wireless) {
        devices.add(device);
      }
    }
    if (devices.isNotEmpty) {
      _connected = true;
    }
    if (mounted) {
      setState(() {
        _showProgress = false;
      });
    }
  }

  void scanWifi() {
    /// calling twice to make sure its going through all available frequencies
    mqtt.publish(Topic.scanWifi, '');
    mqtt.publish(Topic.scanWifi, '');
  }

  void _connect() async {
    try {
      await mqtt.connect();
      scanWifi();
      mqtt.subscribe(
          "everest_api/setup/var/network_device_info", networkDeviceInfo);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
      setState(() {
        _showProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Is Container really necessary?
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            _showProgress
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _connected
                                ? Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer
                                : Theme.of(context).colorScheme.errorContainer,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.2,
                                right: screenWidth * 0.02,
                                top: screenHeight * 0.02,
                                bottom: screenHeight * 0.02),
                            child: Text(
                              _connected
                                  ? 'CONNECTED TO LAN'.tr()
                                  : 'NO NETWORK FOUND'.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    color: _connected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onTertiaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: devices.length,
                            itemBuilder: (builder, index) {
                              return NetworkDeviceInfoWidget(
                                info: devices[index],
                              );
                            }),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .background, //Is this necessary?
                          height: screenHeight * 0.2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SecondaryButton(
                                  title: 'Close',
                                  borderColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  //width: screenWidth * 0.2,
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                PrimaryButton(
                                  child: const Text('Add WIFI'),
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                          (states) => Theme.of(context)
                                              .colorScheme
                                              .errorContainer,
                                        ),
                                      ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.wifiSetupScreen,
                                        arguments: {
                                          'init': true,
                                        });
                                  },
                                  //width: screenWidth * 0.3,
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                PrimaryButton(
                                  child: const Text('Done with SETUP'),
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                          (states) => Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                        ),
                                      ),
                                  onPressed: () {
                                    setInitialized();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                      return const LandingScreen();
                                    }), (Route<dynamic> route) => false);
                                  },
                                  //width: screenWidth * 0.3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void setInitialized() {
    mqtt.publish(Topic.setInitialized, 'true');
  }
}

class NetworkDeviceInfoWidget extends StatelessWidget {
  final NetworkDeviceInfo info;

  const NetworkDeviceInfoWidget({Key? key, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Interface: ${info.interface}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'IPV4: ${info.ipv4.isEmpty ? '----------' : info.ipv4}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ],
      ),
    );
  }
}
