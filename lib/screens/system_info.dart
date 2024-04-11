import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/data/models/network_device_info.dart';
import 'package:pionixbox/screens/about.dart';
import 'package:pionixbox/screens/control.dart';
import 'package:pionixbox/screens/network_info.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../widgets/buttons.dart';

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
      setState(() {});
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            floatingActionButton: const PionixCloseButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            appBar: AppBar(
              //toolbarHeight: 70,
              automaticallyImplyLeading: false,
              flexibleSpace: TabBar(
                labelStyle: AppTextStyles.subTitle4,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.info),
                    text: "about".tr(),
                  ),
                  Tab(
                    icon: const Icon(Icons.network_wifi_sharp),
                    text: "network".tr(),
                  ),
                  Tab(
                    icon: const Icon(Icons.tune),
                    text: "control".tr(),
                  )
                ],
              ),
            ),
            body: const TabBarView(children: [About(), NetworkInfo(), Control()])));
  }
}
