import 'dart:convert';

import 'package:display_app/data/providers/charger_info_provider.dart';
import 'package:display_app/widgets/model_dependent.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:display_app/data/models/network_device_info.dart';
import 'package:display_app/screens/about.dart';
import 'package:display_app/screens/control.dart';
import 'package:display_app/screens/network_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mqtt.dart';
import '../utils/constants/keys.dart';
import '../widgets/buttons.dart';

class SystemInfo extends ConsumerWidget {
  final int initialTab;

  SystemInfo({
    this.initialTab = 0,
    super.key,
  }) {
    scanWifi();
  }

  final mqtt = MQTT();

  void scanWifi() {
    /// calling twice to make sure its going through all available frequencies
    mqtt.publish(Topic.scanWifi, '');
    mqtt.publish(Topic.scanWifi, '');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chargerInfo =
        ref.watch(chargerInfoStreamProvider).whenOrNull(data: (data) => data);
    var supportsConfig = ModelDependent.on(
      chargerModel: chargerInfo?.model_name ?? ChargerModel.unknown,
      defaultValue: false,
      onUMWC: true,
      onUMWCar: true,
    );

    return DefaultTabController(
      initialIndex: initialTab,
      length: supportsConfig ? 3 : 2,
      child: Scaffold(
        floatingActionButton: const PionixCloseButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: TabBar(
            labelStyle: Theme.of(context).textTheme.titleLarge,
            tabs: [
              Tab(
                icon: const Icon(Icons.info),
                text: "about".tr(),
              ),
              Tab(
                icon: const Icon(Icons.network_wifi_sharp),
                text: "network".tr(),
              ),
              if (supportsConfig)
                Tab(
                  icon: const Icon(Icons.tune),
                  text: "control".tr(),
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            About(),
            NetworkInfo(),
            if (supportsConfig) Control(),
          ],
        ),
      ),
    );
  }
}
