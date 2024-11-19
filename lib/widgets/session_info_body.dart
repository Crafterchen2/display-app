import 'dart:math';

import 'dart:convert';

import 'package:display_app/widgets/errors_widget.dart';
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
import 'package:display_app/utils/number_tools.dart';
import 'package:display_app/utils/routing/app_router.dart';
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
    double snapped = 300; //Width of left side when unsnapped
    double offset = 20; //This is to accommodate Padding
    double threshold = 180; //The minimum width of the right side when snapped
    NumberSnap carSideWidth = NumberSnap(
      parameter: MediaQuery.of(context).size.width - adjustScale(snapped),
      snapped: adjustScale(snapped - offset),
      threshold: adjustScale(threshold),
    );
    const scaler = TextScaler.linear(1.7);

    var s = MediaQuery.of(context).size;
    //debugPrint(s.toString());

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: adjustScale(offset / 2),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            SizedBox(
              width: carSideWidth.snapNumber(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'status'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                            ),
                            Text(
                              chargingStateTitle(widget.state).toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        ),
                        _buildImageWidget(context),
                        if (widget.chargingMode == ChargingMode.unknown ||
                            widget.chargingMode == ChargingMode.basicAC)
                          makeChargeControlButton(
                              context, carSideWidth.snapNumber()),
                        if (widget.state != ChargingState.authRequired &&
                            widget.current >= widget.minCurrentA &&
                            widget.current <= widget.maxCurrentA)
                          ModelDependent(
                            platforms: const [ChargerModel.belayBox],
                            child: Column(
                              children: [
                                Wrap(
                                  children: [
                                    Text(
                                      '${'charge_upto'.tr()} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          currentSliderLabel,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                            fontFeatures: [
                                              const FontFeature
                                                  .tabularFigures(),
                                            ],
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                        Text(
                                          ' A',
                                          textAlign: TextAlign.end,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Slider(
                                  min: widget.minCurrentA,
                                  max: widget.maxCurrentA,
                                  label: currentSliderLabel,
                                  activeColor:
                                      Theme.of(context).colorScheme.secondary,
                                  inactiveColor: Colors.grey,
                                  onChanged: (val) {
                                    setState(() {});
                                    widget.onCurrentChanged(val);
                                  },
                                  value: widget.current,
                                ),
                              ],
                            ),
                          ),
                        ValueListenableBuilder(
                          valueListenable: ValueNotifier(activeErrorsHash),
                          builder: (context, value, child) =>
                              ErrorsWidget(activeErrors),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: carSideWidth.snapNumber(
                ovrSnapped: carSideWidth.parameter,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          )
                        : Text(
                            widget.state == 'unplugged'.tr()
                                ? 'last_session'.tr()
                                : 'current_session'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                  ),
                  (widget.state == ChargingState.authRequired)
                      ? ModelDependent(
                          platforms: const [ChargerModel.microMegaWattCharger],
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
                                textScaler: scaler,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: InfoLayout(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: widget.seeMorePressed,
                                  child: _buildInfoCards(
                                    chargerModel: widget.chargerModel,
                                    width: (carSideWidth.isSnapped())
                                        ? (MediaQuery.of(context).size.width -
                                                carSideWidth.snapNumber()) /
                                            14
                                        : null,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                  ),
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
                                          textScaler: scaler,
                                        ),
                                      ),
                                      PrimaryButton(
                                        onPressed: () {
                                          mqtt.publish(
                                              "everest_external/nodered/1/cmd/resume_charging",
                                              "1");
                                        },
                                        child: const Text(
                                          "Resume",
                                          textScaler: scaler,
                                        ),
                                      ),
                                      PrimaryButton(
                                        onPressed: () {
                                          mqtt.publish(
                                              "everest_external/nodered/1/cmd/stop_transaction",
                                              "1");
                                        },
                                        child: const Text(
                                          "Stop transaction",
                                          textScaler: scaler,
                                        ),
                                      ),
                                      PrimaryButton(
                                        onPressed: () {
                                          mqtt.publish(
                                              "everest_external/nodered/1/cmd/emergency_stop",
                                              "1");
                                        },
                                        child: const Text(
                                          "Emerg.Stp",
                                          textScaler: scaler,
                                        ),
                                      ),
                                      PrimaryButton(
                                        onPressed: () {
                                          mqtt.publish(
                                              "everest_external/nodered/1/cmd/evse_malfunction",
                                              "1");
                                        },
                                        child: const Text(
                                          "EVSE malf",
                                          textScaler: scaler,
                                        ),
                                      ),
                                      PrimaryButton(
                                        onPressed: () {
                                          mqtt.publish(
                                              "everest_external/nodered/1/cmd/evse_utility_int",
                                              "1");
                                        },
                                        child: const Text(
                                          "EVSEutil int",
                                          textScaler: scaler,
                                        ),
                                      ),
                                      ModelDependent(
                                        platforms: const [
                                          ChargerModel.microMegaWattCharger
                                        ],
                                        child: PrimaryButton(
                                          onPressed: () {
                                            mqtt.publish(
                                                "everest_api/dummy_token_provider/cmd/provide",
                                                "{\"authorization_type\": \"RFID\", \"id_token\": {\"type\": \"ISO14443\", \"value\": \"DEADBEEFUI\"}}");
                                          },
                                          child: const Text(
                                            "Swipe RFID",
                                            textScaler: scaler,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async {
                                    await Navigator.of(context).pushNamed(
                                        AppRoutes.hlcLogScreen,
                                        arguments: {}).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text(
                                    "See HLC comm log", //TODO Localisation
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                        ),
                                    softWrap: true,
                                    maxLines: 4,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ),
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
      height: adjustScale(60),
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
    double? width,
    TextStyle? style,
  }) {
    return ModelDependent.on(
      chargerModel: chargerModel,
      onUMWC: () {
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
            'PWM: ',
            style: style,
          ),
          Text(
            'CP: ',
            style: style,
          ),
          Text(
            'State: ',
            style: style,
          ),
        ];
        List<Text> values = [
          Text(
            '${outputVoltage.toStringAsFixed(0)} V',
            style: style
                ?.copyWith(fontFeatures: [const FontFeature.tabularFigures()]),
          ),
          Text(
            relaisState,
            style: style,
          ),
          Text(
            '${pwmDc.toStringAsFixed(0)} %',
            style: style
                ?.copyWith(fontFeatures: [const FontFeature.tabularFigures()]),
          ),
          Text(
            '${cpHi.toStringAsFixed(2)}V / ${cpLo.toStringAsFixed(2)} V',
            style: style
                ?.copyWith(fontFeatures: [const FontFeature.tabularFigures()]),
          ),
          Text(
            stateString,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ];
        double maxWidth = 200;
        Color? aColor = Color.lerp(Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.onSurface, 0.2)
            ?.withAlpha(160);
        Color? bColor = Color.lerp(Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.onSurface, 0.4)
            ?.withAlpha(160);
        List<Widget> infos = [];
        for (int i = 0; i < min(titles.length, values.length); i++) {
          infos.add(_buildTextInfo(
              (i % 2 == 0) ? aColor : bColor, values[i], titles[i], maxWidth));
        }
        return Wrap(
          alignment: WrapAlignment.start,
          children: infos,
        );
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
                null,
                ampereLabel,
                Text(
                  'Current Demand : ',
                  style: style,
                ),
                ampereWidth,
              ),
              _buildTextInfo(
                null,
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
          alignment: WrapAlignment.spaceAround,
          spacing: (width == null)
              ? 0
              : (MediaQuery.of(context).size.width - width) / 14,
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

  Widget _buildTextInfo(
      Color? background, Text value, Text title, double width) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: background,
      child: SizedBox(
        width: width,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            title,
            value,
          ],
        ),
      ),
    );
  }

  Widget _buildIconInfo(String iconPath, String value, String label) {
    return Padding(
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontFeatures: [
                const FontFeature.tabularFigures(),
              ],
            ),
          ),
        ],
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
