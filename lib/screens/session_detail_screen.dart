import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/data/providers/limits_provider.dart';
import 'package:pionixbox/data/providers/powermeter_provider.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/utils/circular_queue.dart';
import 'package:pionixbox/utils/datetime_formats.dart';
import 'package:pionixbox/widgets/buttons.dart';

import '../mqtt.dart';
import '../theme/app_text_styles.dart';

class SessionDetailScreen extends ConsumerStatefulWidget {
  const SessionDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SessionDetailScreen> createState() =>
      _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  final mqtt = MQTT();
  PowerMeter? powerMeter;
  Limits? limits;
  bool currentListExpanded = true;
  bool powerListExpanded = true;
  bool frequencyListExpanded = true;
  bool energyListExpanded = true;
  bool voltageListExpanded = true;
  bool telemetryListExpanded = true;
  bool limitsListExpanded = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    extractArguments(context);
    super.didChangeDependencies();
  }

  void extractArguments(BuildContext context) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final powermeter =
        ref.watch(powermeterStreamProvider).whenOrNull(data: (data) => data);
    if (powermeter != null) {
      powerMeter = powermeter;
    }
    final l = ref.watch(limitsStreamProvider).whenOrNull(data: (data) => data);
    if (l != null) {
      limits = l;
    }
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryBlue,
        ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            powerMeter == null || limits == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleInfoCard(
                          title: 'Powermeter ID',
                          value: powerMeter!.meter_id.toString()),
                      powerMeter!.phase_seq_error != null
                          ? SingleInfoCard(
                              title: 'Phase sequence error',
                              value: powerMeter!.phase_seq_error!
                                  ? 'Error state'
                                  : 'No Error')
                          : bufferedPowerMeter.ac
                              ? const SingleInfoCard(
                                  title: 'Phase sequence error',
                                  value: 'Unknown')
                              : Container(),
                      SingleInfoCard(
                          title: 'Time',
                          value: dateTimeFormat
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  powerMeter!.timestamp.round() * 1000))
                              .toString()),
                      GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          shrinkWrap: true,
                          children: [
                            SessionDetailCardWidget(
                              expanded: currentListExpanded,
                              sectionTitle: 'current'.tr(),
                              map: powerMeter!.current_A?.toJson(),
                              unit: 'A',
                              onExpendPressed: () {
                                setState(() {
                                  currentListExpanded = !currentListExpanded;
                                });
                              },
                            ),
                            SessionDetailCardWidget(
                              expanded: powerListExpanded,
                              sectionTitle: 'power'.tr(),
                              map: powerMeter!.power_W?.toJson(),
                              unit: 'W',
                              onExpendPressed: () {
                                setState(() {
                                  powerListExpanded = !powerListExpanded;
                                });
                              },
                            ),
                            SessionDetailCardWidget(
                              expanded: energyListExpanded,
                              sectionTitle: 'energy'.tr(),
                              unit: 'Wh',
                              map: powerMeter!.energy_Wh_import.toJson(),
                              onExpendPressed: () {
                                setState(() {
                                  energyListExpanded = !energyListExpanded;
                                });
                              },
                            ),
                            bufferedPowerMeter.ac
                                ? SessionDetailCardWidget(
                                    expanded: frequencyListExpanded,
                                    sectionTitle: 'frequency'.tr(),
                                    unit: 'Hz',
                                    map: powerMeter!.frequency_Hz?.toJson(),
                                    onExpendPressed: () {
                                      setState(() {
                                        frequencyListExpanded =
                                            !frequencyListExpanded;
                                      });
                                    },
                                  )
                                : Container(),
                            SessionDetailCardWidget(
                              expanded: voltageListExpanded,
                              sectionTitle: 'voltage'.tr(),
                              unit: 'V',
                              map: powerMeter!.voltage_V?.toJson(),
                              onExpendPressed: () {
                                setState(() {
                                  voltageListExpanded = !voltageListExpanded;
                                });
                              },
                            ),
                          ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Limits',
                          style: AppTextStyles.heading3
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      SessionDetailCardWidget(
                        expanded: limitsListExpanded,
                        sectionTitle: 'Limits',
                        map: limits!.toJson(),
                        onExpendPressed: () {
                          setState(() {
                            limitsListExpanded = !limitsListExpanded;
                          });
                        },
                      ),
                      SessionDetailCardWidget(
                        expanded: telemetryListExpanded,
                        sectionTitle: 'telemetry'.tr(),
                        unit: '',
                        map: {
                          "fan".tr(): bufferedTelemetry.fanRPM
                                  .last()
                                  .toStringAsFixed(0) +
                              " RPM",
                          "rcd_current".tr(): bufferedTelemetry.rcdCurrent
                                  .last()
                                  .toStringAsFixed(3) +
                              " A",
                          "relais_on".tr(): bufferedTelemetry.relaisOn.last(),
                          "supply_voltage_12V".tr(): bufferedTelemetry
                                  .supplyVoltage12V
                                  .last()
                                  .toStringAsFixed(2) +
                              " V",
                          "supply_voltage_minus_12V".tr(): bufferedTelemetry
                                  .supplyVoltage12V
                                  .last()
                                  .toStringAsFixed(2) +
                              " V",
                          "temperature".tr(): bufferedTelemetry.temperature
                                  .last()
                                  .toStringAsFixed(1) +
                              " °C",
                        },
                        onExpendPressed: () {
                          setState(() {
                            telemetryListExpanded = !telemetryListExpanded;
                          });
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.15,
                      )
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

class SessionDetailCardWidget extends StatelessWidget {
  final bool expanded;
  final String sectionTitle;
  final String unit;
  final Map<String, dynamic>? map;
  final VoidCallback? onExpendPressed;

  const SessionDetailCardWidget(
      {Key? key,
      required this.sectionTitle,
      required this.map,
      this.expanded = false,
      this.onExpendPressed,
      this.unit = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2, color: Colors.white30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onExpendPressed ?? () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    sectionTitle,
                    style:
                        AppTextStyles.subTitle4.copyWith(color: Colors.white),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_down_sharp
                      : Icons.keyboard_arrow_right,
                  color: Colors.white,
                  size: screenHeight * 0.08,
                )
              ],
            ),
          ),
          expanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 0, top: 0),
                  child: Container(
                    height: 2,
                    color: Colors.white10,
                  ),
                )
              : const SizedBox(),
          if (expanded) ...populateList(context),
        ],
      ),
    );
  }

  List<Widget> populateList(BuildContext context) {
    List<Widget> items = [];
    if (map == null) {
      return items;
    }
    for (final item in map!.entries) {
      var val = item.value;
      if (val == null) {
        continue;
      }
      if (item.value.runtimeType == double) {
        val = val.toStringAsFixed(2);
      } else {
        val = val.toString();
      }
      items.add(SingleInfoCard(title: item.key, value: val + ' $unit'));
    }
    return items;
  }
}

class SingleInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const SingleInfoCard({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.heading3.copyWith(color: Colors.white),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
          const Spacer(),
          SizedBox(
            // width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.digitsHeading3
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
