import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/data/providers/limits_provider.dart';
import 'package:pionixbox/data/providers/powermeter_provider.dart';
import 'package:pionixbox/screens/general_detail_screen.dart';
import 'package:pionixbox/utils/circular_queue.dart';

import '../main.dart';
import '../mqtt.dart';
import '../utils/datetime_formats.dart';
import '../widgets/info_cards.dart';

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
  late PowerMeter powerMeter;
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: adjustScale(10)),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleInfoCard(
                    title: 'Powermeter ID', value: powerMeter.meter_id.toString()),
                const Divider(
                  color: Colors.white10,
                  thickness: 2,
                ),
                SingleInfoCard(
                    title: 'Phase sequence error',
                    value: (powerMeter.phase_seq_error ?? false)
                        ? 'Error state'
                        : 'No Error'),
                const Divider(
                  color: Colors.white10,
                  thickness: 2,
                ),
                SingleInfoCard(
                    title: 'Time',
                    value: dateTimeFormat
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            powerMeter.timestamp.round() * 1000))
                        .toString()),
                const Divider(
                  color: Colors.white10,
                  thickness: 2,
                ),
              ],
            ),
            GeneralDetailScreen(
              infoCards: [
                SessionDetailCardWidget(
                  expanded: currentListExpanded,
                  sectionTitle: 'current'.tr(),
                  onExpendPressed: () {
                    setState(() {
                      currentListExpanded = !currentListExpanded;
                    });
                  },
                  expandContent: ListCardContent(
                    unit: 'A',
                    map: powerMeter.current_A?.toJson(),
                  ),
                ),
                SessionDetailCardWidget(
                  expanded: powerListExpanded,
                  sectionTitle: 'power'.tr(),
                  onExpendPressed: () {
                    setState(() {
                      powerListExpanded = !powerListExpanded;
                    });
                  },
                  expandContent: ListCardContent(
                    unit: 'W',
                    map: powerMeter.power_W?.toJson(),
                  ),
                ),
                SessionDetailCardWidget(
                  expanded: energyListExpanded,
                  sectionTitle: 'energy'.tr(),
                  onExpendPressed: () {
                    setState(() {
                      energyListExpanded = !energyListExpanded;
                    });
                  },
                  expandContent: ListCardContent(
                    unit: 'Wh',
                    map: powerMeter.energy_Wh_import.toJson(),
                  ),
                ),
                if (bufferedPowerMeter.ac)
                  SessionDetailCardWidget(
                    expanded: frequencyListExpanded,
                    sectionTitle: 'frequency'.tr(),
                    onExpendPressed: () {
                      setState(() {
                        frequencyListExpanded = !frequencyListExpanded;
                      });
                    },
                    expandContent: ListCardContent(
                      unit: 'Hz',
                      map: powerMeter.frequency_Hz?.toJson(),
                    ),
                  ),
                SessionDetailCardWidget(
                  expanded: voltageListExpanded,
                  sectionTitle: 'voltage'.tr(),
                  onExpendPressed: () {
                    setState(() {
                      voltageListExpanded = !voltageListExpanded;
                    });
                  },
                  expandContent: ListCardContent(
                    unit: 'V',
                    map: powerMeter.voltage_V?.toJson(),
                  ),
                ),
              ],
              fullInfoCards: [
                SessionDetailCardWidget(
                  expanded: limitsListExpanded,
                  sectionTitle: 'Limits',
                  onExpendPressed: () {
                    setState(() {
                      limitsListExpanded = !limitsListExpanded;
                    });
                  },
                  expandContent: ListCardContent(
                    unit: '',
                    map: limits!.toJson(),
                  ),
                ),
                if (!bufferedTelemetry.isEmpty())
                  SessionDetailCardWidget(
                    expanded: telemetryListExpanded,
                    sectionTitle: 'telemetry'.tr(),
                    onExpendPressed: () {
                      setState(() {
                        telemetryListExpanded = !telemetryListExpanded;
                      });
                    },
                    expandContent: ListCardContent(
                      unit: '',
                      map: {
                        "fan".tr():
                            bufferedTelemetry.fanRPM.last().toStringAsFixed(0) +
                                " RPM",
                        "rcd_current".tr():
                            bufferedTelemetry.rcdCurrent.last().toStringAsFixed(3) +
                                " A",
                        "relais_on".tr(): bufferedTelemetry.relaisOn.last(),
                        "supply_voltage_12V".tr(): bufferedTelemetry.supplyVoltage12V
                                .last()
                                .toStringAsFixed(2) +
                            " V",
                        "supply_voltage_minus_12V".tr(): bufferedTelemetry
                                .supplyVoltage12V
                                .last()
                                .toStringAsFixed(2) +
                            " V",
                        "temperature".tr():
                            bufferedTelemetry.temperature.last().toStringAsFixed(1) +
                                " °C",
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
