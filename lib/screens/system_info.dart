import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pionixbox/data/models/network_device_info.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/widgets/buttons.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';

class SystemInfo extends StatefulWidget {
  const SystemInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<SystemInfo> createState() => _SystemInfoState();
}

class _SystemInfoState extends State<SystemInfo> {
  final mqtt = MQTT();
  List<NetworkDeviceInfo> devices = [];
  bool _showProgress = true;

  @override
  void initState() {

    _connect();
    scanWifi();
    super.initState();
  }

  void scanWifi() {
    /// calling twice to make sure its going through all available frequencies
    mqtt.publish(Topic.scanWifi, '');
    mqtt.publish(Topic.scanWifi, '');
  }

  void networkDeviceInfo(String message) {
    final deviceInfo = jsonDecode(message);
    devices.clear();
    for (final d in deviceInfo) {
      final device = NetworkDeviceInfo.fromJson(d);
      devices.add(device);
    }
    if (mounted) {
      setState(() { _showProgress = false;});
    }
  }

  void _connect() async {
    try {
      await mqtt.connect();
      mqtt.subscribe(
          "everest_api/setup/var/network_device_info", networkDeviceInfo);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');

    }
    setState(() {
      _showProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.4;
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
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                        child: const Text(
                          'System Info',
                          style: AppTextStyles.heading6,
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
                    ],
                  ),
            const PionixCloseButton(),
          ],
        ),
      ),
    );
  }
}

class NetworkDeviceInfoWidget extends StatelessWidget {
  final NetworkDeviceInfo info;

  const NetworkDeviceInfoWidget({Key? key, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.03),
          Row(
            children: [
              Container(
                height: 1,
                width: screenWidth * 0.1,
                color: AppColors.primaryBlue,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Interface: ${info.interface}',
                  style: AppTextStyles.heading3
                      .copyWith(color: AppColors.primaryBlue),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'IPV4: ${info.ipv4.isEmpty ? '----------' : info.ipv4}',
              style: AppTextStyles.subTitle4
                  .copyWith(color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}
