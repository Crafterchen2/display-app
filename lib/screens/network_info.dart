import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/network_device_info.dart';
import 'package:display_app/data/providers/hostname_provider.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';

class NetworkInfo extends ConsumerStatefulWidget {
  const NetworkInfo({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<NetworkInfo> createState() => _NetworkInfoState();
}

class _NetworkInfoState extends ConsumerState<NetworkInfo> {
  final mqtt = MQTT();
  List<NetworkDeviceInfo> devices = [];
  bool _showProgress = true;
  String hostnameString = "";

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
      setState(() {
        _showProgress = false;
      });
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
    final hostname =
        ref.watch(hostnameStreamProvider).whenOrNull(data: (data) => data);
    if (hostname != null) {
      hostnameString = hostname;
    }
    return Scaffold(
      //floatingActionButton: const PionixCloseButton(),
      body: Stack(
        children: [
          _showProgress
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 15,
                      ),
                      child: Text(
                        'Hostname: $hostnameString',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: devices.length,
                        itemBuilder: (builder, index) {
                          return NetworkDeviceInfoWidget(
                            info: devices[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Row(
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "network_interface".tr() + ": ${info.interface}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 15,
            ),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: info.ipv4.length,
              itemBuilder: (builder, index) {
                if (info.ipv4[index].isNotEmpty) {
                  return Text(
                    'IPv4: ${info.ipv4[index]}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: info.ipv6.length,
              itemBuilder: (builder, index) {
                if (info.ipv6[index].isNotEmpty) {
                  return Text(
                    'IPv6: ${info.ipv6[index]}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'MAC: ${info.mac}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
