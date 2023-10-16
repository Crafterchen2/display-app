import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/data/providers/limits_provider.dart';
import 'package:pionixbox/data/providers/powermeter_provider.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/screens/general_detail_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/utils/circular_queue.dart';
import '../widgets/info_cards.dart';

class ChartValues {
  String label;
  List<double> values;

  ChartValues(this.label, this.values);
}

class SessionDetailGraphs extends ConsumerStatefulWidget {
  OverlayEnum overlay = OverlayEnum.none;

  SessionDetailGraphs({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SessionDetailGraphs> createState() =>
      _SessionDetailGraphsState();

  void resetOverlay() {
    overlay = OverlayEnum.none;
  }

  void close(BuildContext context) {
    try {
      if (overlay == OverlayEnum.none) Navigator.pop(context);
      overlay = OverlayEnum.none;
    } catch (e) {
      Navigator.pop(context);
    }
  }
}

enum OverlayEnum { none, current, power, frequency, voltage }

class _SessionDetailGraphsState extends ConsumerState<SessionDetailGraphs> {
  PowerMeter? powerMeter;
  Limits? limits;
  bool currentListExpanded = true;
  bool powerListExpanded = true;
  bool frequencyListExpanded = true;
  bool energyListExpanded = true;
  bool voltageListExpanded = true;
  bool telemetryListExpanded = true;
  bool limitsListExpanded = true;

  //OverlayEnum overlay = OverlayEnum.none;

  late SessionDetailCardWidget chart;
  late ValueNotifier<SessionDetailCardWidget> chartNotifier;

  @override
  void initState() {
    super.initState();
    chart = makeBottomSheetChart();
    chartNotifier = ValueNotifier<SessionDetailCardWidget>(chart);
  }

  @override
  void didChangeDependencies() {
    extractArguments(context);
    super.didChangeDependencies();
  }

  void extractArguments(BuildContext context) {
    setState(() {});
  }

  SessionDetailCardWidget getCurrentChart(bool allowOverlay) {
    List<ChartValues> values = [];
    if (bufferedPowerMeter.ac) {
      values = [
        ChartValues("L1", bufferedPowerMeter.currentL1.toList()),
        ChartValues("L2", bufferedPowerMeter.currentL2.toList()),
        ChartValues("L3", bufferedPowerMeter.currentL3.toList())
      ];
    } else {
      values = [ChartValues("DC", bufferedPowerMeter.currentDC.toList())];
    }
    return SessionDetailCardWidget(
      //stretchThreshold: 70,
      cardWidth: 400,
      expanded: currentListExpanded,
      sectionTitle: 'current'.tr(),
      onExpendPressed: (allowOverlay)
          ? () {
              setState(() {
                currentListExpanded = !currentListExpanded;
              });
            }
          : () {
              widget.overlay = OverlayEnum.none;
            },
      expandContent: LineChartCardContent(
        unit: 'A',
        values: values,
        showPopup: allowOverlay,
        onShowOverlayPressed: () {
          widget.overlay = OverlayEnum.current;
          chart = makeBottomSheetChart();
          chartNotifier.value = chart;
          showOverlay();
        },
      ),
    );
  }

  SessionDetailCardWidget getPowerChart(bool allowOverlay) {
    List<ChartValues> values = [];
    if (bufferedPowerMeter.ac) {
      values = [
        ChartValues("L1", bufferedPowerMeter.powerL1.toList()),
        ChartValues("L2", bufferedPowerMeter.powerL2.toList()),
        ChartValues("L3", bufferedPowerMeter.powerL3.toList())
      ];
    } else {
      values = [ChartValues("total", bufferedPowerMeter.powerTotal.toList())];
    }
    return SessionDetailCardWidget(
      //stretchThreshold: 50,
      cardWidth: 400,
      expanded: powerListExpanded,
      sectionTitle: 'power'.tr(),
      onExpendPressed: (allowOverlay)
          ? () {
              setState(() {
                powerListExpanded = !powerListExpanded;
              });
            }
          : () {
              widget.overlay = OverlayEnum.none;
            },
      expandContent: LineChartCardContent(
        unit: 'W',
        values: values,
        showPopup: allowOverlay,
        onShowOverlayPressed: () {
          widget.overlay = OverlayEnum.power;
          chart = makeBottomSheetChart();
          chartNotifier.value = chart;
          showOverlay();
        },
      ),
    );
  }

  SessionDetailCardWidget getFrequencyChart(bool allowOverlay) {
    List<ChartValues> values = [];
    if (bufferedPowerMeter.ac) {
      values = [
        ChartValues("L1", bufferedPowerMeter.freqL1.toList()),
        ChartValues("L2", bufferedPowerMeter.freqL2.toList()),
        ChartValues("L3", bufferedPowerMeter.freqL3.toList())
      ];
    } else {
      values = [];
    }
    return SessionDetailCardWidget(
      //stretchThreshold: 50,
      cardWidth: 400,
      expanded: frequencyListExpanded,
      sectionTitle: 'frequency'.tr(),
      onExpendPressed: (allowOverlay)
          ? () {
              setState(() {
                frequencyListExpanded = !frequencyListExpanded;
              });
            }
          : () {
              widget.overlay = OverlayEnum.none;
            },
      expandContent: LineChartCardContent(
        unit: 'Hz',
        values: values,
        showPopup: allowOverlay,
        onShowOverlayPressed: () {
          widget.overlay = OverlayEnum.frequency;
          chart = makeBottomSheetChart();
          chartNotifier.value = chart;
          showOverlay();
        },
      ),
    );
  }

  SessionDetailCardWidget getVoltageChart(bool allowOverlay) {
    List<ChartValues> values = [];
    if (bufferedPowerMeter.ac) {
      values = [
        ChartValues("L1", bufferedPowerMeter.voltageL1.toList()),
        ChartValues("L2", bufferedPowerMeter.voltageL2.toList()),
        ChartValues("L3", bufferedPowerMeter.voltageL3.toList())
      ];
    } else {
      values = [ChartValues("DC", bufferedPowerMeter.voltageDC.toList())];
    }
    return SessionDetailCardWidget(
      cardWidth: 400,
      expanded: voltageListExpanded,
      sectionTitle: 'voltage'.tr(),
      onExpendPressed: (allowOverlay)
          ? () {
              setState(() {
                voltageListExpanded = !voltageListExpanded;
              });
            }
          : () {
              widget.overlay = OverlayEnum.none;
            },
      expandContent: LineChartCardContent(
        unit: 'A',
        values: values,
        showPopup: allowOverlay,
        onShowOverlayPressed: () {
          widget.overlay = OverlayEnum.voltage;
          chart = makeBottomSheetChart();
          chartNotifier.value = chart;
          showOverlay();
        },
      ),
    );
  }

  SessionDetailCardWidget makeBottomSheetChart() {
    if (widget.overlay == OverlayEnum.current) {
      return getCurrentChart(false);
    } else if (widget.overlay == OverlayEnum.power) {
      return getPowerChart(false);
    } else if (widget.overlay == OverlayEnum.frequency) {
      return getFrequencyChart(false);
    } else if (widget.overlay == OverlayEnum.voltage) {
      return getVoltageChart(false);
    } else {
      //This exists only due to null safety. if everything works correctly,
      //this *should* never be visible.
      return const SessionDetailCardWidget(
        sectionTitle: "Sorry", //TODO: Localization
        expandContent: SingleInfoCard(
          value: ":(",
          title: "Es ist ein Problem aufgetreten.", //TODO: Localization
        ),
      ); //-->Container()
    }
  }

  void showOverlay() {
    //Widget --> void
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      elevation: 20,
      backgroundColor: AppColors.primaryBlue,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 2,
          color: Colors.white30,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(adjustScale(12)),
          topRight: Radius.circular(adjustScale(12)),
        ),
      ),
      builder: (context) {
        return ValueListenableBuilder<SessionDetailCardWidget>(
          valueListenable: chartNotifier,
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: value.expandContent,
            );
          },
        );
      },
    );
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
    if (widget.overlay != OverlayEnum.none) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          chart = makeBottomSheetChart();
          chartNotifier.value = chart;
        },
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: adjustScale(10)),
        child: GeneralDetailScreen(infoCards: [
          getCurrentChart(true),
          getPowerChart(true),
          SessionDetailCardWidget(
            stretchThreshold: 400,
            expanded: energyListExpanded,
            sectionTitle: 'energy'.tr(),
            onExpendPressed: () {
              setState(() {
                energyListExpanded = !energyListExpanded;
              });
            },
            expandContent: ListCardContent(
              unit: 'Wh',
              map: powerMeter!.energy_Wh_import.toJson(),
            ),
          ),
          if (bufferedPowerMeter.ac) getFrequencyChart(true),
          getVoltageChart(true),
        ], fullInfoCards: [
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
                    bufferedTelemetry.fanRPM.last().toStringAsFixed(0) + " RPM",
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
        ]),
      ),
    );
  }
}
