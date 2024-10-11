import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/config_paths.dart';
import 'package:pionixbox/data/providers/application_info_provider.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/mqtt.dart';
import 'package:pionixbox/utils/constants/helper.dart';
import 'package:pionixbox/widgets/buttons.dart';

class Control extends ConsumerStatefulWidget {
  const Control({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Control> createState() => _ControlState();
}

class _ControlState extends ConsumerState<Control> {
  final mqtt = MQTT();
  Map<String, List<String>> configInfo = {};
  Map<String, List<String>> configDirInfo = {};
  String loadedConfig = "";

  @override
  void didChangeDependencies() {
    _connect();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  void _connect() async {
    try {
      await mqtt.connect();
      mqtt.subscribe("everest_api/control/var/config_paths", parseConfigPaths);
      mqtt.subscribe("everest_api/control/var/selected_config", parseSelectedConfig);

      mqtt.publish("everest_api/control/cmd/get_config_paths", "0");
      mqtt.publish("everest_api/control/cmd/get_selected_config", "0");

      // mqtt.subscribe(
      //     "everest_api/setup/var/network_device_info", networkDeviceInfo);

      // enableWifiScanning();
      // scanWifi();
      // listConfiguredNetworks();
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
    }
  }

  void parseConfigPaths(String message) {
    final configPaths = ConfigPaths.fromJson(jsonDecode(message));
    configInfo["configs"] = configPaths.configs;
    configDirInfo = configPaths.config_dirs;
  }

  void parseSelectedConfig(String message) {
    loadedConfig = message;
  }

  void loadConfig(String config) {
    Map<String, String> changeConfig = {};
    changeConfig["config_path"] = config;
    mqtt.publish("everest_api/control/cmd/change_config", json.encode(changeConfig).toString());
  }

  @override
  Widget build(BuildContext context) {
    final appInfo = ref.watch(applicationInfoStreamProvider).whenOrNull(data: (data) => data);
    // if (appInfo != null) {
    //   if (appInfo.release_metadata_file != null &&
    //       appInfo.release_metadata_file != releaseMetadataFile) {
    //     releaseMetadataFile =
    //         appInfo.release_metadata_file ?? releaseMetadataFile;
    //     debugPrint("metadata file: $releaseMetadataFile");
    //     _read();
    //   }
    // }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          right: 10,
          left: 10,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        wrapString('Loaded config: $loadedConfig'),
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 20,
                  ),
                  child: Row(
                    children: [
                      PrimaryButton(
                        onPressed: () {
                          mqtt.publish("everest_api/control/cmd/restart", "1");
                        },
                        child: const Text("Restart basecamp-control.service"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: PrimaryButton(
                          onPressed: () {
                            mqtt.publish("everest_api/control/cmd/restart_display_app", "1");
                          },
                          child: const Text("Restart display-app.service"),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "EVerest configurations",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: configInfo.length,
                  itemBuilder: (builder, index) {
                    String header = configInfo.keys.elementAt(index);
                    return ConfigInfoWidget(
                      header: header,
                      configPaths: configInfo.values.elementAt(index),
                      loadConfig: loadConfig,
                    );
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: configDirInfo.length,
                  itemBuilder: (builder, index) {
                    String header = configDirInfo.keys.elementAt(index);
                    return ConfigInfoWidget(
                      header: header,
                      configPaths: configDirInfo.values.elementAt(index),
                      loadConfig: loadConfig,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConfigInfoWidget extends StatelessWidget {
  final String header;
  final List<String> configPaths;
  final Function(String) loadConfig;

  const ConfigInfoWidget({
    Key? key,
    required this.header,
    required this.configPaths,
    required this.loadConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                header,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: configPaths.length,
          itemBuilder: (builder, index) {
            String value = configPaths.elementAt(index);
            return Row(
              children: [
                PrimaryButton(
                  onPressed: () {
                    if (header == "configs") {
                      loadConfig(value);
                    } else {
                      loadConfig(header + "/" + value);
                    }
                  },
                  child: Text('load'.tr()),
                ),
                Text(
                  wrapString(value),
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
