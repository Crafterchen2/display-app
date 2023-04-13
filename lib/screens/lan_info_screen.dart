import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/data/models/network_device_info.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/screens/landing_screen.dart';
import 'package:pionixbox/screens/charging_dashboard_screen.dart';
import 'package:pionixbox/screens/wifi_setup_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            _showProgress
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
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
                                  ? AppColors.successLight
                                  : AppColors.errorLight),
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
                              style: AppTextStyles.heading6
                                  .copyWith(color: Colors.white),
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
                          color: Colors.white,
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
                                  borderColor: AppColors.errorLight,
                                  textColor: AppColors.errorLight,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  width: screenWidth * 0.2,
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                PrimaryButton(
                                  title: 'Add WIFI',
                                  color: AppColors.errorLight,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.wifiSetupScreen,
                                        arguments: {
                                          'init': true,
                                        });
                                  },
                                  width: screenWidth * 0.3,
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                PrimaryButton(
                                  title: 'Done with SETUP',
                                  color: AppColors.successLight,
                                  onPressed: () {
                                    setInitialized();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                      return const LandingScreen();
                                    }), (Route<dynamic> route) => false);
                                  },
                                  width: screenWidth * 0.3,
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
              style: AppTextStyles.subTitle4.copyWith(
                  color: AppColors.primaryBlue, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'IPV4: ${info.ipv4.isEmpty ? '----------' : info.ipv4}',
              style: AppTextStyles.subTitle4.copyWith(
                  color: AppColors.primaryBlue, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
