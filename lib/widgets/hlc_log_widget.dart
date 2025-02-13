import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/data/models/hlc_log.dart';
import 'dart:io';

import 'package:display_app/data/providers/selected_protocol_provider.dart';

import 'package:display_app/utils/globals.dart';

import 'package:display_app/widgets/keyboard.dart';
import 'package:display_app/widgets/text_fields.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../main.dart';
import '../mqtt.dart';
import 'info_cards.dart';
import 'package:async/async.dart';

class HlcLogWidget extends ConsumerStatefulWidget {
  final void Function()? scrollDown;
  const HlcLogWidget({
    this.scrollDown,
    super.key,
  });

  @override
  ConsumerState<HlcLogWidget> createState() => _HlcLogWidgetState();
}

class _HlcLogWidgetState extends ConsumerState<HlcLogWidget> {
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
  late CancelableOperation<void> refresh;

  bool expanded = false;

  @override
  void initState() {
    inLogScreen = true;
    super.initState();
    refresh = CancelableOperation.fromFuture(refreshLoop());
  }

  @override
  void dispose() {
    inLogScreen = false;
    refresh.cancel();
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

  // periodically refresh to update logs
  Future<void> refreshLoop() async {
    while (true) {
      setState(() {});
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  String buildHlcLogString(HlcLog log) {
    String logString = "${log.origin} ";
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
        widgets.add(
          Row(
            key: UniqueKey(),
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  buildHlcLogString(hlcLog),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.blueAccent),
                  softWrap: true,
                ),
              ),
            ],
          ),
        );
      } else if (hlcLog.origin == "CAR") {
        // add to right
        widgets.add(
          Row(
            key: UniqueKey(),
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  buildHlcLogString(hlcLog),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.yellowAccent),
                  softWrap: true,
                ),
              ),
            ],
          ),
        );
      } else if (hlcLog.origin == "SYS") {
        widgets.add(
          Row(
            key: UniqueKey(),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  buildHlcLogString(hlcLog),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        );
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

    return Container(
      color: Theme.of(context).colorScheme.primary,
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width - 40,
      height: expanded
          ? MediaQuery.sizeOf(context).height -
              130 // the height of the bottom bar and top bar
          : MediaQuery.sizeOf(context).height -
              (130 + 192), // additionally the height of the status info
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: adjustScale(10)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(top: adjustScale(10))),
                SingleInfoCard(
                    title: 'Selected protocol', value: selectedProtocolString),
                const Divider(
                  color: Colors.white10,
                  thickness: 2,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logEntries.length,
                      itemBuilder: (context, index) => logEntries[index],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          setState(() {
                            autoscroll = !autoscroll;
                          });
                        },
                        heroTag:
                            "pauseHero", //prevent "Same hero tag error"; doesn't change functionality
                        child: autoscroll
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FloatingActionButton(
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            onPressed: () => hlcLogList.clear(),
                            heroTag:
                                "clearHero", //prevent "Same hero tag error"; doesn't change functionality
                            child: const Icon(Icons.delete),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                          if (expanded)
                            FloatingActionButton(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              onPressed: () => annotateButtonPressed(),
                              heroTag:
                                  "annotateHero", //prevent "Same hero tag error"; doesn't change functionality
                              child: const Icon(Icons.message),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                expanded = !expanded;
                              });
                              if (expanded) {
                                Future.delayed(Duration(milliseconds: 50), () {
                                  widget.scrollDown?.call();
                                });
                              }
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Icon(expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          !_showKeyboard
              ? Container()
              : OrientationBuilder(
                  builder: (context, orientation) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconTextField(
                          hintText: 'Enter annotation',
                          onTap: () {
                            setState(() {
                              _showKeyboard = true;
                            });
                          },
                          visible: true,
                          hidden: false,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          icon: Icon(
                            Icons.message,
                            color: Colors.grey.shade400,
                            size: 28,
                          ),
                          controller: annotateController,
                        ),
                        orientation == Orientation.landscape
                            ? Container(
                                color: Theme.of(context).colorScheme.secondary,
                                child: PionixVirtualKeyboard(
                                    height: 300,
                                    fontSize: 32,
                                    textColor:
                                        Theme.of(context).colorScheme.primary,
                                    textController: annotateController,
                                    customLayoutKeys:
                                        VirtualKeyboardPionixLayoutKeys(),
                                    type: VirtualKeyboardType.Alphanumeric,
                                    onKeyPress: (key) => _onKeyPress(key)),
                              )
                            : Container(
                                color: Theme.of(context).colorScheme.secondary,
                                child: PionixVirtualKeyboard(
                                  height: 500,
                                  fontSize: 32,
                                  textColor:
                                      Theme.of(context).colorScheme.primary,
                                  textController: annotateController,
                                  defaultLayouts: const [
                                    VirtualKeyboardDefaultLayouts.English
                                  ],
                                  type: VirtualKeyboardType.Alphanumeric,
                                  onKeyPress: (key) => _onKeyPress(key),
                                ),
                              ),
                      ],
                    );
                  },
                ),
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
            String annotationPath =
                "$loggingPath/annotation_${DateTime.now().toUtc().toIso8601String()}.txt";
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
