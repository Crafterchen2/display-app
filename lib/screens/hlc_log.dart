import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/hlc_log.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/data/providers/hlc_log_provider.dart';
import 'package:pionixbox/data/providers/limits_provider.dart';
import 'package:pionixbox/data/providers/powermeter_provider.dart';
import 'package:pionixbox/data/providers/selected_protocol_provider.dart';
import 'package:pionixbox/screens/general_detail_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';
import 'package:pionixbox/utils/circular_queue.dart';
import 'package:pionixbox/widgets/buttons.dart';

import '../main.dart';
import '../mqtt.dart';
import '../utils/datetime_formats.dart';
import '../widgets/info_cards.dart';

class HlcLogScreen extends ConsumerStatefulWidget {
  const HlcLogScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HlcLogScreen> createState() => _HlcLogScreenState();
}

class _HlcLogScreenState extends ConsumerState<HlcLogScreen> {
  final mqtt = MQTT();
  late HlcLog hlcLog;
  String selectedProtocolString = "Unknown";
  bool currentListExpanded = true;
  bool powerListExpanded = true;
  bool frequencyListExpanded = true;
  bool energyListExpanded = true;
  bool voltageListExpanded = true;
  bool telemetryListExpanded = true;
  bool limitsListExpanded = true;
  ScrollController scrollController = ScrollController();
  bool autoscroll = true;

  List<Widget> logEntries = [];

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

  String buildHlcLogString(HlcLog log) {
    String logString = log.origin + " ";
    if (log.iso15118) {
      logString += "ISO ";
    }
    logString += log.msg;
    return logString;
  }

  @override
  Widget build(BuildContext context) {
    if (scrollController.hasClients && autoscroll) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    }
    final selectedProtocol = ref
        .watch(selectedProtocolStreamProvider)
        .whenOrNull(data: (data) => data);
    if (selectedProtocol != null) {
      selectedProtocolString = selectedProtocol;
    }

    final hlclog =
        ref.watch(hlcLogStreamProvider).whenOrNull(data: (data) => data);
    if (hlclog != null) {
      hlcLog = hlclog;

      if (hlcLog.origin == "EVSE") {
        // add to left
        Widget entry = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                child: Text(
              buildHlcLogString(hlcLog),
              style: AppTextStyles.heading3.copyWith(color: Colors.blueAccent),
              softWrap: true,
            ))
          ],
        );
        logEntries.add(entry);
      } else if (hlcLog.origin == "CAR") {
        // add to right
        Widget entry = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
                child: Text(
              buildHlcLogString(hlcLog),
              style:
                  AppTextStyles.heading3.copyWith(color: Colors.yellowAccent),
              softWrap: true,
            ))
          ],
        );
        logEntries.add(entry);
      } else if (hlcLog.origin == "SYS") {
        Widget entry = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Text(
              buildHlcLogString(hlcLog),
              style: AppTextStyles.heading3.copyWith(color: Colors.white),
              softWrap: true,
            ))
          ],
        );
        logEntries.add(entry);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryBlue,
              onPressed: () => autoscroll = !autoscroll,
              heroTag:
                  "pauseHero", //prevent "Same hero tag error"; does not change functionality
              child: autoscroll
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
            ),
            const PionixCloseButton(
              inverted: true,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: adjustScale(10)),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(top: adjustScale(10))),
                SingleInfoCard(
                    title: 'Selected protocol', value: selectedProtocolString),
                const Divider(
                  color: Colors.white10,
                  thickness: 2,
                ),
                SizedBox(
                    height:
                        MediaQuery.of(context).size.height - adjustScale(132),
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: logEntries.length,
                          itemBuilder: (context, index) => logEntries[index],
                        )))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
