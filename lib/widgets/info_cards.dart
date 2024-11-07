import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/session_detail_graphs.dart';
import '../theme/app_colors.dart';
import '../utils/circular_queue.dart';

class SessionDetailCardWidget extends StatelessWidget {
  final bool expanded;
  final String sectionTitle;
  final Widget expandContent;
  final VoidCallback? onExpendPressed;

  ///This value already respects the [uiScale] principle. [adjustScale] must not be applied.
  final double cardWidth;

  ///This value already respects the [uiScale] principle. [adjustScale] must not be applied.
  ///Indicates, when a card should change to its stretched form.
  ///If null, then this value is equal to [cardWidth].
  final double? stretchThreshold;

  ///This value already respects the [uiScale] principle. [adjustScale] must not be applied.
  ///decreases the amount of space where the card form may be applied. a smaller number might cause
  ///a 'twitchy' behaviour whereas a higher number can cause the stretched form to early.
  final double stretchSensitivity;

  const SessionDetailCardWidget({
    Key? key,
    required this.sectionTitle,
    required this.expandContent,
    this.cardWidth = 240,
    this.stretchThreshold,
    this.stretchSensitivity = 36,
    this.expanded = false,
    this.onExpendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width <
              ((adjustScale(stretchThreshold ?? cardWidth) * 2) +
                  adjustScale(stretchSensitivity)))
          ? null
          : adjustScale(cardWidth),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2, color: Colors.white30),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onExpendPressed ?? () {},
                    child: Container(
                      color: Colors.transparent,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            sectionTitle,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          Icon(
                            (expanded)
                                ? Icons.keyboard_arrow_down_sharp
                                : Icons.keyboard_arrow_right,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: adjustScale(40),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            expanded ? const Divider() : Container(),
            if (expanded)
              expandContent, //...populateList(context) --> ListCardContent(unit: unit, map: map) --> expandContent
          ],
        ),
      ),
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
    return Row(
      children: [
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              Text(
                value,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ListCardContent extends StatelessWidget {
  final String unit;
  final Map<String, dynamic>? map;

  const ListCardContent({
    super.key,
    required this.unit,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: populateList(context),
    );
  }

  List<Widget> populateList(BuildContext context) {
    int i = 0;
    List<Widget> items = [];
    if (map == null) {
      return items;
    }
    for (final item in map!.entries) {
      var val = item.value;
      if (val == null) {
        i++;
        continue;
      }
      if (item.value.runtimeType == double) {
        val = val.toStringAsFixed(2);
      } else {
        val = val.toString();
      }
      items.add(SingleInfoCard(title: item.key, value: val + ' $unit'));
      if (i != map!.length - 1) {
        items.add(const Divider(
          color: Colors.white10,
          thickness: 2,
        ));
      }
      i++;
    }
    return items;
  }
}

class LineChartCardContent extends StatefulWidget {
  final String unit;
  final List<ChartValues> values;
  final VoidCallback onShowOverlayPressed;
  final bool showPopup;
  final double chartHeight;

  const LineChartCardContent({
    super.key,
    required this.unit,
    required this.onShowOverlayPressed,
    required this.values,
    this.showPopup = true,
    this.chartHeight = 184,
  });

  @override
  State<StatefulWidget> createState() => _LineChartCardContent();
}

class _LineChartCardContent extends State<LineChartCardContent> {
  @override
  Widget build(BuildContext context) {
    return makeLineGraph(context);
  }

  Widget getTitlesWidget(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.white);
    String text = value.toStringAsFixed(1);

    if (widget.unit.isNotEmpty) {
      text += " " + widget.unit;
    }

    if (bufferedPowerMeter.ac) {
      if (value == meta.max || value == meta.min) {
        return Container();
      }
    }

    return Text(text, style: style);
  }

  Widget makeLineGraph(BuildContext context) {
    List<double> minimums = [];
    List<double> maximums = [];
    List<List<FlSpot>> points = [];

    List<Color> colors = [
      Theme.of(context).colorScheme.secondary,
      AppColors.chartTomato,
      AppColors.chartFuchsiaRose,
      AppColors.chartImperial,
      Theme.of(context).colorScheme.primary,
      const Color.fromARGB(255, 255, 0, 0),
      const Color.fromARGB(255, 0, 255, 0),
      const Color.fromARGB(255, 0, 0, 255),
      const Color.fromARGB(255, 255, 0, 255),
      const Color.fromARGB(255, 0, 255, 255),
      const Color.fromARGB(255, 255, 255, 0),
    ];

    for (var element in widget.values) {
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

    for (var i = 0; i < widget.values.length; i++) {
      points.add([]);
      labels.add(Text(
        widget.values[i].label,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: colors[i % colors.length]),
      ));
      for (var j = 0; j < widget.values[i].values.length; j++) {
        points[i].add(FlSpot(j.toDouble(), widget.values[i].values[j]));
      }
    }

    List<LineChartBarData> lineBarsData = [];
    for (var i = 0; i < points.length; i++) {
      lineBarsData.add(drawLine(points[i], colors[i % colors.length]));
    }

    SizedBox chart = SizedBox(
      height: (widget.showPopup)
          ? widget.chartHeight
          : MediaQuery.of(context).size.height * getChartHeightPercent(),
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
      ),
    );

    Widget chartContainer = SizedBox(
      //color: Colors.green,
      width: double.infinity,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...labels,
                  ],
                ),
              ),
              Expanded(
                child: chart,
              ),
            ],
          ),
          if (widget.showPopup)
            TextButton(
              onPressed: widget.onShowOverlayPressed,
              style: const ButtonStyle(
                overlayColor:
                    MaterialStatePropertyAll<Color>(Colors.transparent),
              ),
              child: Container(
                height: chart.height,
              ),
            ),
          //FloatingActionButton(onPressed: (){debugPrint("test");}),
          //SizedBox(
          //  height: 100,
          //  child: GestureDetector(
          //    onTap: () => (false) ? widget.onShowOverlayPressed : (){debugPrint("test");},
          //    //behavior: HitTestBehavior.opaque,
          //  ),
          //),
        ],
      ),
    );
    return chartContainer;
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
