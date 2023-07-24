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
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_text_styles.dart';

class ChartValues {
  String label;
  List<double> values;

  ChartValues(this.label, this.values);
}

class SessionDetailGraphs extends ConsumerStatefulWidget {
  const SessionDetailGraphs({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SessionDetailGraphs> createState() =>
      _SessionDetailGraphsState();
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

  OverlayEnum overlay = OverlayEnum.none;

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

  LineChartCardWidget getCurrentChart() {
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
    return LineChartCardWidget(
      expanded: currentListExpanded,
      sectionTitle: 'current'.tr(),
      values: values,
      unit: 'A',
      onExpendPressed: () {
        setState(() {
          currentListExpanded = !currentListExpanded;
        });
      },
      onShowOverlayPressed: () {
        overlay = OverlayEnum.current;
      },
    );
  }

  LineChartCardWidget getPowerChart() {
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
    return LineChartCardWidget(
      expanded: powerListExpanded,
      sectionTitle: 'power'.tr(),
      values: values,
      unit: 'W',
      onExpendPressed: () {
        setState(() {
          powerListExpanded = !powerListExpanded;
        });
      },
      onShowOverlayPressed: () {
        overlay = OverlayEnum.power;
      },
    );
  }

  LineChartCardWidget getFrequencyChart() {
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
    return LineChartCardWidget(
      expanded: frequencyListExpanded,
      sectionTitle: 'frequency'.tr(),
      unit: 'Hz',
      values: values,
      onExpendPressed: () {
        setState(() {
          frequencyListExpanded = !frequencyListExpanded;
        });
      },
      onShowOverlayPressed: () {
        overlay = OverlayEnum.frequency;
      },
    );
  }

  LineChartCardWidget getVoltageChart() {
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
    return LineChartCardWidget(
      expanded: voltageListExpanded,
      sectionTitle: 'voltage'.tr(),
      unit: 'V',
      values: values,
      onExpendPressed: () {
        setState(() {
          voltageListExpanded = !voltageListExpanded;
        });
      },
      onShowOverlayPressed: () {
        overlay = OverlayEnum.voltage;
      },
    );
  }

  Widget showOverlay() {
    LineChartCardWidget chart;
    if (overlay == OverlayEnum.current) {
      chart = getCurrentChart();
    } else if (overlay == OverlayEnum.power) {
      chart = getPowerChart();
    } else if (overlay == OverlayEnum.frequency) {
      chart = getFrequencyChart();
    } else if (overlay == OverlayEnum.voltage) {
      chart = getVoltageChart();
    } else {
      return Container();
    }

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color: Colors.black, width: 1.0)),
        child: Column(children: [
          Text(
            chart.sectionTitle,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.white),
          ),
          chart
        ]));
  }

  void close() {
    debugPrint("close pressed");
    if (overlay == OverlayEnum.none) {
      Navigator.pop(context);
    }
    overlay = OverlayEnum.none;
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
                            getCurrentChart(),
                            getPowerChart(),
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
                                ? getFrequencyChart()
                                : Container(),
                            getVoltageChart()
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
                      ),
                    ],
                  ),
            showOverlay(),
            PionixCloseButton(
              onPressed: () {
                close();
              },
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
        children: <Widget>[
          Column(
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
                        style: AppTextStyles.subTitle4
                            .copyWith(color: Colors.white),
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

// ignore: must_be_immutable
class LineChartCardWidget extends StatelessWidget {
  final bool expanded;
  final String sectionTitle;
  final String unit;
  final List<ChartValues> values;
  final VoidCallback? onExpendPressed;
  final VoidCallback onShowOverlayPressed;

  Widget? chartContainer;

  LineChartCardWidget(
      {Key? key,
      required this.sectionTitle,
      required this.values,
      required this.onShowOverlayPressed,
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
        children: <Widget>[
          Column(
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
                        style: AppTextStyles.subTitle4
                            .copyWith(color: Colors.white),
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
              if (expanded) populateList(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget getTitlesWidget(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.white);
    String text = value.toStringAsFixed(1);

    if (unit.isNotEmpty) {
      text += " " + unit;
    }

    if (bufferedPowerMeter.ac) {
      if (value == meta.max || value == meta.min) {
        return Container();
      }
    }

    return Text(text, style: style);
  }

  Widget populateList(BuildContext context) {
    List<double> minimums = [];
    List<double> maximums = [];
    List<List<FlSpot>> points = [];

    List<Color> colors = [
      AppColors.primaryAmber,
      AppColors.chartTomato,
      AppColors.chartFuchsiaRose,
      AppColors.chartImperial,
      AppColors.primaryBlue,
      const Color.fromARGB(255, 255, 0, 0),
      const Color.fromARGB(255, 0, 255, 0),
      const Color.fromARGB(255, 0, 0, 255),
      const Color.fromARGB(255, 255, 0, 255),
      const Color.fromARGB(255, 0, 255, 255),
      const Color.fromARGB(255, 255, 255, 0),
    ];

    for (var element in values) {
      if (element.values.isNotEmpty) {
        minimums.add(element.values
            .reduce((value, element) => value < element ? value : element));
        maximums.add(element.values
            .reduce((value, element) => value > element ? value : element));
      }
    }

    minimums.sort();
    maximums.sort();

    List<Widget> labels = [];

    for (var i = 0; i < values.length; i++) {
      points.add([]);
      labels.add(Text(
        values[i].label,
        style:
            AppTextStyles.heading3.copyWith(color: colors[i % colors.length]),
      ));
      for (var j = 0; j < values[i].values.length; j++) {
        points[i].add(FlSpot(j.toDouble(), values[i].values[j]));
      }
    }

    List<LineChartBarData> lineBarsData = [];
    for (var i = 0; i < points.length; i++) {
      lineBarsData.add(drawLine(points[i], colors[i % colors.length]));
    }

    Widget chart = SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        // width: 100,
        child: LineChart(
          LineChartData(
            minY: minimums.first,
            maxY: maximums.last,
            minX: points[0].first.x,
            maxX: points[0].last.x,
            lineTouchData: LineTouchData(enabled: false),
            clipData: FlClipData.all(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: lineBarsData,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(),
              topTitles: AxisTitles(),
              bottomTitles: AxisTitles(),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 80,
                      getTitlesWidget: getTitlesWidget)),
              show: true,
            ),
          ),
          swapAnimationDuration: Duration.zero,
        ));

    chartContainer = GestureDetector(
        onTap: () => onShowOverlayPressed(),
        child: SizedBox(
            width: double.infinity,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...labels,
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      )),
                  Expanded(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      // height: 100,
                      child: chart)
                ])));
    return chartContainer!;
  }

  LineChartBarData drawLine(List<FlSpot> points, Color color) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [color, color],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
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
