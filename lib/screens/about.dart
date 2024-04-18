import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/network_device_info.dart';
import 'package:pionixbox/data/models/release_component.dart';
import 'package:pionixbox/data/models/release_info.dart';
import 'package:pionixbox/data/providers/application_info_provider.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

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
      //floatingActionButton: const PionixCloseButton(),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                Text(
                  "EVerest " +
                      releaseInfo.version +
                      " @ " +
                      releaseInfo.channel +
                      " " +
                      "channel".tr(),
                  style: AppTextStyles.heading3
                      .copyWith(color: AppColors.primaryBlue),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: releaseInfo.components.length,
                      itemBuilder: (builder, index) {
                        return ReleaseComponentInfoWidget(
                          component: releaseInfo.components[index],
                        );
                      }),
                ),
              ],
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
                color: Theme.of(context).colorScheme.primary,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  component.name,
                  style: AppTextStyles.heading3
                      .copyWith(color: AppColors.primaryBlue),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                component.description,
                style: AppTextStyles.subTitle4
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "version".tr() + ": ${component.version}",
                style: AppTextStyles.subTitle4
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "license".tr() + ": ${component.license}",
                style: AppTextStyles.subTitle4
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ))
        ],
      ),
    );
  }
}