
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/hlc_log.dart';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/data/models/hlc_log.dart';
import 'package:pionixbox/data/models/limits.dart';
import 'package:pionixbox/data/models/power_meter.dart';
import 'package:pionixbox/data/providers/connector_provider.dart';

import 'package:pionixbox/data/providers/hlc_log_provider.dart';
import 'package:pionixbox/data/providers/selected_protocol_provider.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

import 'package:pionixbox/utils/circular_queue.dart';
import 'package:pionixbox/utils/globals.dart';

import 'package:pionixbox/widgets/buttons.dart';
import 'package:pionixbox/widgets/keyboard.dart';
import 'package:pionixbox/widgets/text_fields.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../main.dart';
import '../mqtt.dart';
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
  bool _showKeyboard = false;
  TextEditingController annotateController = TextEditingController();

  // List<Widget> logEntries = [];
  // List<HlcLog> hlcLogList = [];

  @override
  void initState() {
    inLogScreen = true;
    super.initState();
  }

  @override
  void dispose() {
    inLogScreen = false;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    extractArguments(context);
    // _connect();
    super.didChangeDependencies();
  }

  void extractArguments(BuildContext context) {
    setState(() {});
  }

  // void parseHlcLogMsg(String message) {
  //   // debugPrint("Parsing $message");
  //   HlcLog log = parseHlcLog(message);
  //   hlcLogList.add(log);
  // }

  // void _connect() async {
  //   try {
  //     await mqtt.connect();
  //     final connector = ref.watch(connectorProvider);
  //     mqtt.subscribe(
  //         "everest_api/" + connector + "/var/hlc_log", parseHlcLogMsg);
  //   } catch (e) {
  //     debugPrint('Loading failed, Error: $e');
  //   }
  // }

  String buildHlcLogString(HlcLog log) {
    String logString = log.origin + " ";
    if (log.iso15118) {
      logString += "ISO ";
    }
    logString += log.msg;
    return logString;
  }

  List<Widget> makeHlcLog() {
    List<Widget> widgets = [];
    for (var hlcLog in hlcLogList) {
      if (hlcLog.origin == "EVSE") {
        // add to left
        widgets.add(Row(
          key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                child: Text(
              buildHlcLogString(hlcLog),
              style: AppTextStyles.heading3.copyWith(color: Colors.blueAccent),
              softWrap: true,
            ))
          ],
        ));
      } else if (hlcLog.origin == "CAR") {
        // add to right
        widgets.add(Row(
          key: UniqueKey(),
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
        ));
      } else if (hlcLog.origin == "SYS") {
        widgets.add(Row(
          key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Text(
              buildHlcLogString(hlcLog),
              style: AppTextStyles.heading3.copyWith(color: Colors.white),
              softWrap: true,
            ))
          ],
        ));
      }
    }

    return widgets;
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

    List<Widget> logEntries = makeHlcLog();

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
            FloatingActionButton(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryBlue,
              onPressed: () => hlcLogList.clear(),
              heroTag:
                  "clearHero", //prevent "Same hero tag error"; does not change functionality
              child: const Icon(Icons.delete),
            ),
            FloatingActionButton(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryBlue,
              onPressed: () => annotateButtonPressed(),
              heroTag:
                  "annotateHero", //prevent "Same hero tag error"; does not change functionality
              child: const Icon(Icons.message),
            ),
            const PionixCloseButton(
              inverted: true,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: adjustScale(10)),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: EdgeInsets.only(top: adjustScale(10))),
                    SingleInfoCard(
                        title: 'Selected protocol',
                        value: selectedProtocolString),
                    const Divider(
                      color: Colors.white10,
                      thickness: 2,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height -
                            adjustScale(132),
                        child: SingleChildScrollView(
                            controller: scrollController,
                            child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: logEntries.length,
                              itemBuilder: (context, index) =>
                                  logEntries[index],
                            )))
                  ],
                ),
              ],
            ),
          ),
          _showKeyboard
              ? OrientationBuilder(builder: (context, orientation) {
                  return SizedBox(
                      height:
                          MediaQuery.of(context).size.height - adjustScale(132),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                width: double.infinity,
                                child: IconTextField(
                                  hintText: 'Enter annotation',
                                  onTap: () {
                                    setState(() {
                                      _showKeyboard = true;
                                    });
                                  },
                                  visible: true,
                                  hidden: false,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  icon: Icon(
                                    Icons.message,
                                    color: Colors.grey.shade400,
                                    size: 28,
                                  ),
                                  controller: annotateController,
                                ),
                              ),
                            ),
                            orientation == Orientation.landscape
                                ? Container(
                                    color: AppColors.primaryAmber,
                                    child: PionixVirtualKeyboard(
                                        height: 300,
                                        fontSize: 32,
                                        textColor: AppColors.primaryBlue,
                                        textController: annotateController,
                                        customLayoutKeys:
                                            VirtualKeyboardPionixLayoutKeys(),
                                        type: VirtualKeyboardType.Alphanumeric,
                                        onKeyPress: (key) => _onKeyPress(key)),
                                  )
                                : Container(
                                    color: AppColors.primaryAmber,
                                    child: PionixVirtualKeyboard(
                                        height: 500,
                                        fontSize: 32,
                                        textColor: AppColors.primaryBlue,
                                        textController: annotateController,
                                        defaultLayouts: const [
                                          VirtualKeyboardDefaultLayouts.English
                                        ],
                                        type: VirtualKeyboardType.Alphanumeric,
                                        onKeyPress: (key) => _onKeyPress(key)),
                                  )
                          ]));
                })
              : const SizedBox(),
        ],
      ),
    );
  }

  void annotateButtonPressed() {
    _showKeyboard = !_showKeyboard;
    annotateController.clear();
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(PionixVirtualKeyboardKey key) async {
    if (key.keyType == VirtualKeyboardKeyType.String) {
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case PionixVirtualKeyboardKeyAction.Return:
          setState(() {
            _showKeyboard = false;
          });

          if (loggingPath != "") {
            String annotationPath = loggingPath + "/annotation_" + DateTime.now().toUtc().toIso8601String() + ".txt";
            final File file = File(annotationPath);
            await file.create(recursive: true, exclusive: false);
            await file.writeAsString(annotateController.text);
            annotateController.clear();
          }

          debugPrint('Enter key pressed');

          break;
        case PionixVirtualKeyboardKeyAction.SwitchLanguage:
          debugPrint("Switch language");
          break;
        default:
      }
    }
  }
}
