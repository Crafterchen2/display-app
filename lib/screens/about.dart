import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/network_device_info.dart';
import 'package:display_app/data/models/release_component.dart';
import 'package:display_app/data/models/release_info.dart';
import 'package:display_app/data/providers/application_info_provider.dart';

class About extends ConsumerStatefulWidget {
  const About({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<About> createState() => _AboutState();
}

class _AboutState extends ConsumerState<About> {
  List<NetworkDeviceInfo> devices = [];
  ReleaseInfo releaseInfo = ReleaseInfo(
      "unknown".tr(), DateTime.now().toUtc(), "version_unknown".tr(), []);
  String releaseMetadataFile = '';

  @override
  void initState() {
    super.initState();
  }

  void _read() async {
    try {
      final File file = File(releaseMetadataFile);
      releaseInfo = ReleaseInfo.fromJson(jsonDecode(await file.readAsString()));
      setState(() {
        releaseInfo;
      });
    } catch (e) {
      debugPrint('Could not read file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appInfo = ref
        .watch(applicationInfoStreamProvider)
        .whenOrNull(data: (data) => data);
    if (appInfo != null) {
      if (appInfo.release_metadata_file != null &&
          appInfo.release_metadata_file != releaseMetadataFile) {
        releaseMetadataFile =
            appInfo.release_metadata_file ?? releaseMetadataFile;
        debugPrint("metadata file: $releaseMetadataFile");
        _read();
      }
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          right: 10,
          left: 10,
        ),
        child: Column(
          children: [
            Text(
              "EVerest ${releaseInfo.version} @ ${releaseInfo.channel} channel"
                  .tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: releaseInfo.components.length,
                itemBuilder: (builder, index) {
                  return ReleaseComponentInfoWidget(
                    component: releaseInfo.components[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReleaseComponentInfoWidget extends StatelessWidget {
  final ReleaseComponent component;

  const ReleaseComponentInfoWidget({Key? key, required this.component})
      : super(key: key);

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
                component.name,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            component.description,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "version".tr() + ": ${component.version}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "license".tr() + ": ${component.license}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
      ],
    );
  }
}
