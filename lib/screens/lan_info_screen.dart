import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:display_app/data/models/network_device_info.dart';
import 'package:display_app/screens/landing_screen.dart';
import 'package:display_app/widgets/buttons.dart';

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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 20,
        backgroundColor: _connected
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.errorContainer,
        foregroundColor: _connected
            ? Theme.of(context).colorScheme.onTertiaryContainer
            : Theme.of(context).colorScheme.onErrorContainer,
        title: Text(
          _connected ? 'CONNECTED TO LAN'.tr() : 'NO NETWORK FOUND'.tr(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: _connected
                    ? Theme.of(context).colorScheme.onTertiaryContainer
                    : Theme.of(context).colorScheme.onErrorContainer,
              ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: const PionixCloseButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: PrimaryButton(
                child: const Text('Add WIFI'),
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) =>
                            Theme.of(context).colorScheme.errorContainer,
                      ),
                    ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.wifiSetupScreen, arguments: {
                    'init': true,
                  });
                },
              ),
            ),
            PrimaryButton(
              child: const Text('Done with SETUP'),
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) =>
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                  ),
              onPressed: () {
                setInitialized();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const LandingScreen();
                }), (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _showProgress
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (builder, index) {
                    return NetworkDeviceInfoWidget(
                      info: devices[index],
                    );
                  },
                ),
        ],
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
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Interface: ${info.interface}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
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
