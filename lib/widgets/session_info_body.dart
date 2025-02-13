import 'dart:math';

import 'dart:convert';

import 'package:display_app/widgets/access_dependent.dart';
import 'package:display_app/widgets/empty.dart';
import 'package:display_app/widgets/hlc_log_widget.dart';
import 'package:display_app/widgets/model_dependent.dart';
import 'package:easy_localization/easy_localization.dart'
    as virtual_keyboard_backspace_event_period;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:display_app/data/models/ev_info.dart';
import 'package:display_app/mqtt.dart';
import 'package:display_app/utils/enums.dart';
import 'package:display_app/utils/globals.dart';
import 'package:display_app/widgets/layout.dart';

import '../main.dart';
import '../utils/constants/helper.dart';
import '../utils/constants/keys.dart';
import 'buttons.dart';
import 'charging_animation_widget.dart';

class SessionInfoBody extends StatefulWidget {
  final double energy;
  final String duration;
  final String totalEnergy;
  final double power;
  final String state;
  final String stateInfo;
  final double latestTotalw;
  final double current;
  final double maxCurrentA;
  final double minCurrentA;

  final bool online;
  final VoidCallback? seeMorePressed;
  final VoidCallback onPauseCharging;
  final VoidCallback onResumeCharging;
  final ValueChanged onCurrentChanged;
  final ChargingMode chargingMode;
  final double? soc;
  final ChargerModel chargerModel;

  const SessionInfoBody({
    super.key,
    required this.energy,
    required this.duration,
    required this.totalEnergy,
    required this.state,
    required this.latestTotalw,
    required this.onPauseCharging,
    required this.onResumeCharging,
    this.online = true,
    this.power = 0.0,
    this.seeMorePressed,
    required this.onCurrentChanged,
    required this.current,
    required this.maxCurrentA,
    required this.minCurrentA,
    required this.stateInfo,
    required this.chargingMode,
    this.soc,
    required this.chargerModel,
  });

  @override
  State<SessionInfoBody> createState() => _SessionInfoBodyState();
}

class _SessionInfoBodyState extends State<SessionInfoBody> {
  final mqtt = MQTT();
  String relaisState = "Unknown";
  double outputVoltage = 0;
  double cpHi = 0;
  double cpLo = 0;
  double pwmDc = 0;
  String stateString = "Unknown";
  double batteryPercentage = 0;
  double targetVoltage = 0;
  double targetCurrent = 0;
  EvInfo? evManagerInfo;
  late double currentSliderValue;
  ScrollController scrollController = ScrollController();

  /// This is a map of actions that can be performed on the charger.
  Map<Widget, void Function()> actions = {};

  @override
  void initState() {
    currentSliderValue = widget.current;
    super.initState();
    actions = {
      const Text(
        "Stop transaction",
      ): () {
        mqtt.publish("everest_external/nodered/1/cmd/stop_transaction", "1");
      },
      const Text(
        "Emerg.Stp",
      ): () {
        mqtt.publish("everest_external/nodered/1/cmd/emergency_stop", "1");
      },
      const Text(
        "EVSE malf",
      ): () {
        mqtt.publish("everest_external/nodered/1/cmd/evse_malfunction", "1");
      },
      const Text(
        "EVSEutil int",
      ): () {
        mqtt.publish("everest_external/nodered/1/cmd/evse_utility_int", "1");
      },
      const Text(
        "Swipe RFID",
      ): () {
        mqtt.publish("everest_api/dummy_token_provider/cmd/provide",
            "{\"authorization_type\": \"RFID\", \"id_token\": {\"type\": \"ISO14443\", \"value\": \"DEADBEEFUI\"}}");
      },
    };
  }

  @override
  void didChangeDependencies() {
    _connect();
    super.didChangeDependencies();
  }

  void parseRelaisOn(String message) {
    // why is this a float? does 0 mean "off" ?
    double rs = double.parse(message);
    if (rs > 0) {
      relaisState = "On";
    } else {
      relaisState = "Off";
    }
  }

  void parseOutputVoltage(String message) {
    outputVoltage = double.parse(message);
  }

  void parseCpHi(String message) {
    cpHi = double.parse(message);
  }

  void parseCpLo(String message) {
    cpLo = double.parse(message);
  }

  void parsePwmDc(String message) {
    pwmDc = double.parse(message) * 100;
  }

  void parseStateString(String message) {
    stateString = message;
    if (stateString == "Idle") {
      debugPrint("Idle, clearing HLC log");
      clearHlcLog();
    }
  }

  void parseBatteryPercentage(String message) {
    batteryPercentage = double.parse(message);
  }

  void parseEvinfo(String message) {
    evManagerInfo = EvInfo.fromJson(jsonDecode(message));
    batteryPercentage = evManagerInfo?.soc ?? 0;
    targetCurrent = evManagerInfo?.target_current ?? 0;
    targetVoltage = evManagerInfo?.target_voltage ?? 0;
  }

  void _connect() async {
    try {
      await mqtt.connect();
      mqtt.subscribe("everest_external/umwc/relais_on", parseRelaisOn);
      mqtt.subscribe(
          "everest_external/umwc/output_voltage", parseOutputVoltage);
      mqtt.subscribe("everest_external/umwc/cp_hi", parseCpHi);
      mqtt.subscribe("everest_external/umwc/cp_lo", parseCpLo);
      mqtt.subscribe("everest_external/umwc/pwm_dc", parsePwmDc);
      mqtt.subscribe(
          "everest_external/nodered/1/state/state_string", parseStateString);
      mqtt.subscribe(
          "everest_api/umwcar/var/battery_percentage", parseBatteryPercentage);
      mqtt.subscribe("everest_api/ev_manager/var/ev_info", parseEvinfo);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentSliderLabel = widget.current.toStringAsFixed(1);
    //Changing the snapping behavior below is sufficient.
    double offset = 20; //This is to accommodate Padding

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: adjustScale(offset / 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // direction: Axis.horizontal,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // direction: Axis.horizontal,
              // crossAxisAlignment: WrapCrossAlignment.start,
              // alignment: WrapAlignment.start,
              // runAlignment: WrapAlignment.start,
              children: [
                // SizedBox(
                //   width: carSideWidth.snapNumber(),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [],
                //   ),
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - 40,
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: adjustScale(5),
                              ),
                              child: widget.state == ChargingState.authRequired
                                  ? Text(
                                      'swipe_your_card_please'.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                    )
                                  : Text(
                                      widget.state == ChargingState.unplugged
                                          ? 'last_session'.tr()
                                          : 'current_session'.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                    ),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.chargingMode ==
                                          ChargingMode.unknown ||
                                      widget.chargingMode ==
                                          ChargingMode.basicAC)
                                    makeChargeControlButton(context, 150),
                                  if (widget.state !=
                                          ChargingState.authRequired &&
                                      widget.current >= widget.minCurrentA &&
                                      widget.current <= widget.maxCurrentA)
                                    ModelDependent(
                                      platforms: const [
                                        ChargerModel.belayBox,
                                        ChargerModel.unknown
                                      ], // TODO remove unknown when the belaybox reports its devicetype via mqtt
                                      child: Column(
                                        children: [
                                          Text(
                                            '${'charge_upto'.tr()} $currentSliderLabel A',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                          ),
                                          AccessDependent(
                                            onPrivate: SizedBox(
                                              height: 30,
                                              child: Slider(
                                                min: widget.minCurrentA,
                                                max: widget.maxCurrentA,
                                                label: currentSliderLabel,
                                                activeColor: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                inactiveColor: Colors.grey,
                                                onChanged: (val) {
                                                  setState(() {
                                                    currentSliderValue = val;
                                                  });
                                                  widget.onCurrentChanged(val);
                                                },
                                                value: currentSliderValue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${'status'.tr()}: ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                Text(
                                  chargingStateTitle(widget.state)
                                      .toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    (widget.state == ChargingState.authRequired)
                        ? ModelDependent(
                            platforms: const [
                              ChargerModel.microMegaWattCharger
                            ],
                            child: SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                onPressed: () {
                                  mqtt.publish(
                                      "everest_api/dummy_token_provider/cmd/provide",
                                      "{\"authorization_type\": \"RFID\", \"id_token\": {\"type\": \"ISO14443\", \"value\": \"DEADBEEFUI\"}}");
                                },
                                child: const Text(
                                  "Swipe RFID",
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.sizeOf(context).width - 40,
                            child: InfoLayout(
                              children: [
                                TextButton(
                                  onPressed: widget.seeMorePressed,
                                  child: _buildInfoCards(
                                    chargerModel: widget.chargerModel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            fontFamily: "RobotoMono"),
                                  ),
                                ),
                                ModelDependent(
                                  platforms: const [
                                    ChargerModel.microMegaWattCharger
                                  ],
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceAround,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      runSpacing: 10,
                                      spacing: 10,
                                      children: [
                                        PrimaryButton(
                                            onPressed: () {
                                              mqtt.publish(
                                                  "everest_external/nodered/1/cmd/pause_charging",
                                                  "1");
                                            },
                                            child: const Text(
                                              "Pause",
                                            )),
                                        PrimaryButton(
                                            onPressed: () {
                                              mqtt.publish(
                                                  "everest_external/nodered/1/cmd/resume_charging",
                                                  "1");
                                            },
                                            child: const Text(
                                              "Resume",
                                            )),
                                        Container(
                                          height: 32,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          child: DropdownButton(
                                            elevation: 2,
                                            underline: Empty(),
                                            icon: Icon(Icons.menu),
                                            hint: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                "More Actions",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                            ),
                                            iconEnabledColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            items: actions.keys.map((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: e,
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              actions[value]?.call();
                                            },
                                            dropdownColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                            // color: Color.fromARGB(
                                            //     255, 247, 5, 5)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: double.infinity,
                                //   child: TextButton(
                                //     onPressed: () async {
                                //       await Navigator.of(context).pushNamed(
                                //           AppRoutes.hlcLogScreen,
                                //           arguments: {}).then((value) {
                                //         setState(() {});
                                //       });
                                //     },
                                //     child: Text(
                                //       "See HLC comm log", //TODO Localisation
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .displaySmall
                                //           ?.copyWith(
                                //             color: Colors.grey,
                                //           ),
                                //       softWrap: true,
                                //       maxLines: 4,
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
            ),
            HlcLogWidget(
              scrollDown: () {
                scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.fastOutSlowIn);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget makeChargeControlButton(BuildContext context, double? width) {
    var isChargingState = widget.state == ChargingState.charging;
    var showResumeButton =
        pauseOrResumeChargingTitle(widget.state) != ChargingState.charging &&
            widget.state != ChargingState.authRequired &&
            pauseOrResumeChargingTitle(widget.state) != '';
    if (!isChargingState && !showResumeButton) {
      return SizedBox(
        width: width,
      );
    }
    return SizedBox(
      height: 44,
      width: width,
      child: (isChargingState)
          ? OutlinedButton(
              onPressed: widget.onPauseCharging,
              child: Text(
                'pause'.tr(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          : (showResumeButton)
              ? FilledButton(
                  onPressed: widget.onResumeCharging,
                  child: Text(
                    'resume'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
              : Container(),
    );
  }

  Widget _buildInfoCards({
    required ChargerModel chargerModel,
    TextStyle? style,
  }) {
    return ModelDependent.on(
      chargerModel: chargerModel,
      onUMWC: () {
        List<IconData?> icons = [
          Icons.bolt,
          Icons.power_settings_new,
          Icons.bolt,
          Icons.percent,
          Icons.settings,
          Icons.bolt,
        ];
        List<Text> titles = [
          Text(
            'Voltage: ',
            style: style,
          ),
          Text(
            'Relais: ',
            style: style,
          ),
          Text(
            'CP high: ',
            style: style,
          ),
          Text(
            'PWM: ',
            style: style,
          ),
          Text(
            'State: ',
            style: style,
          ),
          Text(
            "CP low: ",
            style: style,
          ),
        ];
        List<Text> values = [
          Text(
            '${outputVoltage.toStringAsFixed(0)} V',
            style: style,
          ),
          Text(
            relaisState,
            style: style,
          ),
          Text(
            '${cpHi.toStringAsFixed(2)} V',
            style: style,
          ),
          Text(
            '${pwmDc.toStringAsFixed(0)} %',
            style: style,
          ),
          Text(
            stateString,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${cpLo.toStringAsFixed(2)} V",
            style: style,
          ),
        ];
        double maxWidth = 230;
        List<Widget> infos = [];
        // using the max value here instantly shows errors
        for (int i = 0;
            i < [titles.length, values.length, icons.length].reduce(max);
            i++) {
          infos.add(
            _buildTextInfo(
              values[i],
              titles[i],
              maxWidth,
              icon: icons[i],
            ),
          );
        }
        return LayoutBuilder(builder: (context, constraints) {
          int itemsPerRow = constraints.maxWidth ~/ maxWidth;
          int fillerCount = infos.length % itemsPerRow == 0
              ? 0 // prevents adding a full row of empty widgets
              : itemsPerRow - infos.length % itemsPerRow;
          for (var i = 0; i < fillerCount; i++) {
            infos.add(
              SizedBox(
                width: maxWidth,
              ),
            );
          }
          var seperator = Container(
            width: 2,
            height: 40,
            color: Theme.of(context).colorScheme.primary,
          );
          List<Widget> seperatedInfos = [];
          for (var i = 0; i < infos.length; i++) {
            seperatedInfos.add(infos[i]);
            if (i % itemsPerRow != itemsPerRow - 1) {
              seperatedInfos.add(seperator);
            }
          }
          return Wrap(
            alignment: WrapAlignment.start,
            children: seperatedInfos,
          );
        });
      },
      onUMWCar: () {
        Text ampereLabel = Text(
          '${(targetCurrent).toStringAsFixed(2)} A',
          style: style
              ?.copyWith(fontFeatures: [const FontFeature.tabularFigures()]),
        );
        TextPainter tp = TextPainter(
          text: TextSpan(
            text: "${ampereLabel.data!}Current Demand",
            style: ampereLabel.style,
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        double ampereWidth = tp.width;
        return Column(children: [
          Text(
            'battery_percentage'.tr(),
            style: const TextStyle(fontSize: 20),
          ),
          LinearGauge(
            start: 0,
            steps: 10,
            end: 100,
            customLabels: const [
              CustomRulerLabel(text: "0", value: 0),
              CustomRulerLabel(text: "10", value: 10),
              CustomRulerLabel(text: "20", value: 20),
              CustomRulerLabel(text: "30", value: 30),
              CustomRulerLabel(text: "40", value: 40),
              CustomRulerLabel(text: "50", value: 50),
              CustomRulerLabel(text: "60", value: 60),
              CustomRulerLabel(text: "70", value: 70),
              CustomRulerLabel(text: "80", value: 80),
              CustomRulerLabel(text: "90", value: 90),
              CustomRulerLabel(text: "100", value: 100)
            ],
            valueBar: [
              ValueBar(
                value: batteryPercentage,
                valueBarThickness: 10,
              )
            ],
            rulers: RulerStyle(
                rulerPosition: RulerPosition.bottom,
                textStyle: const TextStyle(fontSize: 20)),
          ),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            children: [
              _buildTextInfo(
                ampereLabel,
                Text(
                  'Current Demand : ',
                  style: style,
                ),
                ampereWidth,
              ),
              _buildTextInfo(
                Text(
                  '${(targetCurrent * targetVoltage).toStringAsFixed(2)} W',
                  style: style,
                ),
                Text(
                  'Current Demand : ',
                  style: style,
                ),
                ampereWidth,
              )
            ],
          ),
        ]);
      },
      defaultValue: () {
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            _buildIconInfo('assets/icons/icon_power.svg',
                '${widget.power.toStringAsFixed(2)} kW', 'power'.tr()),
            _buildIconInfo('assets/icons/icon_energy.svg',
                '${widget.energy.toStringAsFixed(2)} kWh', 'energy'.tr()),
            _buildIconInfo('assets/icons/icon_charging_duration.svg',
                '${widget.duration} h', 'duration'.tr())
          ],
        );
      },
    )(); // runs the functions provided for each platform
  }

  Widget _buildTextInfo(Text value, Text title, double width,
      {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width - 16, // adjusted for the padding
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
              ),
            title,
            Spacer(),
            value,
          ],
        ),
      ),
    );
  }

  Widget _buildIconInfo(String iconPath, String value, String label) {
    return Container(
      constraints: BoxConstraints(maxWidth: 140),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: adjustScale(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: SvgPicture.asset(
                iconPath,
                height: 50,
                theme: SvgTheme(
                  currentColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 103),
              child: Center(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFeatures: [
                        const FontFeature.tabularFigures(),
                      ],
                      fontFamily: "RobotoMono"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // VERY UNSURE WHAT TODO HERE :( the method had two different implementations and i went for the one from bd-ui-refactor branch

  // List<Widget> _buildInfoCards(String chargerModelName) {
  //   if (chargerModelName == ChargerModelName.microMegaWattCharger) {
  //     return [
  //       _buildSessionInfoCard(
  //           null, outputVoltage.toStringAsFixed(2) + ' V', 'Output Voltage'),
  //       _buildSessionInfoCard(null, relaisState, 'Relais'),
  //       _buildSessionInfoCard(null, pwmDc.toStringAsFixed(0) + ' %', 'PWM DC'),
  //       _buildSessionInfoCard(null, cpHi.toStringAsFixed(2), 'CP Hi'),
  //       _buildSessionInfoCard(null, cpLo.toStringAsFixed(2), 'CP Lo'),
  //       _buildSessionInfoCard(null, stateString, 'State'),
  //     ];
  //   }
  //   if (chargerModelName == ChargerModelName.microMegaWattCar) {
  //     return [
  //       Column(children: [
  //         Text(
  //           'battery_percentage'.tr(),
  //           style: const TextStyle(fontSize: 20),
  //         ),
  //         LinearGauge(
  //           start: 0,
  //           steps: 10,
  //           end: 100,
  //           customLabels: const [
  //             CustomRulerLabel(text: "0", value: 0),
  //             CustomRulerLabel(text: "10", value: 10),
  //             CustomRulerLabel(text: "20", value: 20),
  //             CustomRulerLabel(text: "30", value: 30),
  //             CustomRulerLabel(text: "40", value: 40),
  //             CustomRulerLabel(text: "50", value: 50),
  //             CustomRulerLabel(text: "60", value: 60),
  //             CustomRulerLabel(text: "70", value: 70),
  //             CustomRulerLabel(text: "80", value: 80),
  //             CustomRulerLabel(text: "90", value: 90),
  //             CustomRulerLabel(text: "100", value: 100)
  //           ],
  //           valueBar: [
  //             ValueBar(
  //               value: batteryPercentage,
  //               valueBarThickness: 10,
  //             )
  //           ],
  //           rulers: RulerStyle(
  //               rulerPosition: RulerPosition.bottom,
  //               textStyle: TextStyle(fontSize: 20)),
  //         ),
  //         Row(
  //           children: [
  //             _buildSessionInfoCard(null,
  //                 (targetCurrent).toStringAsFixed(2) + ' A', 'CurrentDemand'),
  //             _buildSessionInfoCard(
  //                 null,
  //                 (targetCurrent * targetVoltage).toStringAsFixed(2) + ' W',
  //                 'CurrentDemand')
  //           ],
  //         ),
  //       ])
  //     ];
  //   }
  //   return [
  //     _buildSessionInfoCard('assets/icons/icon_power.svg',
  //         widget.power.toStringAsFixed(2) + ' kW', 'power'.tr()),
  //     _buildSessionInfoCard('assets/icons/icon_energy.svg',
  //         widget.energy.toStringAsFixed(2) + ' kWh', 'energy'.tr()),
  //     _buildSessionInfoCard('assets/icons/icon_charging_duration.svg',
  //         widget.duration + ' h', 'duration'.tr())
  //   ];
  // }

  Widget _buildImageWidget(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //is this stack still required?
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: getChargingSessionWidgetByState(
                  context,
                  widget.state,
                  adjustScale(96),
                  adjustScale(320),
                  widget.soc,
                ),
              ),
              // if (widget.state == 'ChargingPausedEVSE' ||
              //     widget.state == 'ChargingPausedEV')
              // SvgPicture.asset(
              //   'assets/icons/icon_pausecharging.svg',
              //   height:
              //       widget.state == 'Unplugged' ? null : screenWidth * 0.15,
              //   width:
              //       widget.state == 'Unplugged' ? null : screenWidth * 0.15,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget getChargingSessionWidgetByState(BuildContext context, String state,
    double height, double width, double? soc) {
  if (state == 'Charging') {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      ChargingAnimationWidget(),
      if (soc != null)
        Stack(
          children: <Widget>[
            Text(
              "${soc.toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 60,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 8
                  ..color = Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              "${soc.toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 60,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        )
    ]);
  } else {
    return SvgPicture.asset(
      getChargingSessionIconByState(state),
      height: height,
      //width: width,
    );
  }
}
