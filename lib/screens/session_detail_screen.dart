import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/widgets/buttons.dart';

import '../mqtt.dart';
import '../theme/app_text_styles.dart';

class SessionDetailScreen extends StatefulWidget {
  const SessionDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final mqtt = MQTT();
  late PowerMeter powerMeter;
  late Limits limits;
  String selectedLanguage = 'english';
  bool showLoader = true;

  void extractArguments(BuildContext context) {
    final i = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    powerMeter = i["powerMeter"];
    limits = i["limits"];
    debugPrint('\n\n ${powerMeter.toJson()}');
    debugPrint('\n ${powerMeter.current_A.toJson()}');
    debugPrint('\n ${powerMeter.power_W.toJson()}');
    debugPrint('\n ${powerMeter.voltage_V.toJson()}');
    debugPrint('\n ${powerMeter.energy_Wh_import.toJson()}');
    debugPrint('\n ${powerMeter.frequency_Hz.toJson()}');
    debugPrint('\n\n ${limits.toJson()} \n\n');
    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    extractArguments(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
        padding: EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Powermeter',
                      style: AppTextStyles.subTitle4,
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'L1'.tr(),
                            style: AppTextStyles.heading3,
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            'L1'.tr(),
                            style: AppTextStyles.heading3,
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            'L1'.tr(),
                            style: AppTextStyles.heading3,
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            children: [
                              Text(
                               'total',
                                style: AppTextStyles.heading3,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              powerMeter.current_A.L1.toStringAsFixed(2),
                              textAlign: TextAlign.start,
                              style: AppTextStyles.digitsHeading3,
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              powerMeter.current_A.L2.toStringAsFixed(2),
                              textAlign: TextAlign.start,
                              style: AppTextStyles.digitsHeading3,
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              powerMeter.current_A.L3.toStringAsFixed(2),
                              style: AppTextStyles.digitsHeading3,
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              powerMeter.current_A.N.toStringAsFixed(2),
                              style: AppTextStyles.digitsHeading3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const PionixCloseButton(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
