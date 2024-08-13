import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' as _virtual_keyboard_backspace_event_period;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/mqtt.dart';
import 'package:pionixbox/utils/enums.dart';
import 'package:pionixbox/utils/globals.dart';
import 'package:pionixbox/utils/number_tools.dart';
import 'package:pionixbox/utils/routing/app_router.dart';
import 'package:pionixbox/widgets/layout.dart';

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
  final String chargerModelName;

  const SessionInfoBody({
    Key? key,
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
    required this.chargerModelName,
  }) : super(key: key);

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

  void _connect() async {
    try {
      await mqtt.connect();
      mqtt.subscribe("everest_external/umwc/relais_on", parseRelaisOn);
      mqtt.subscribe("everest_external/umwc/output_voltage", parseOutputVoltage);
      mqtt.subscribe("everest_external/umwc/cp_hi", parseCpHi);
      mqtt.subscribe("everest_external/umwc/cp_lo", parseCpLo);
      mqtt.subscribe("everest_external/umwc/pwm_dc", parsePwmDc);
      mqtt.subscribe("everest_external/nodered/1/state/state_string", parseStateString);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentSliderLabel = widget.current.toStringAsFixed(1);
    //Change the snapping behavior below is sufficient.
    double snapped = 300; //Width of left side when unsnapped
    double offset = 20; //This is to accommodate Padding
    double threshold = 180;
    NumberSnap carSideWidth = NumberSnap(
      parameter: MediaQuery.of(context).size.width - adjustScale(snapped),
      snapped: adjustScale(snapped - offset),
      threshold: adjustScale(threshold),
    );
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
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onBackground,
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
                        if (widget.chargingMode == ChargingMode.unknown || widget.chargingMode == ChargingMode.basicAC)
                          makeChargeControlButton(context, carSideWidth.snapNumber()),
                        if (widget.state != ChargingState.authRequired && widget.current >= widget.minCurrentA && widget.current <= widget.maxCurrentA)
                          Column(
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    'charge_upto'.tr() + ' ',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onBackground,
                                        ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        currentSliderLabel,
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontFeatures: [
                                            const FontFeature.tabularFigures(),
                                          ],
                                          color: Theme.of(context).colorScheme.onBackground,
                                        ),
                                      ),
                                      Text(
                                        ' A',
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                              color: Theme.of(context).colorScheme.onBackground,
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
                                activeColor: Theme.of(context).colorScheme.secondary,
                                inactiveColor: Colors.grey,
                                onChanged: (val) {
                                  setState(() {});
                                  widget.onCurrentChanged(val);
                                },
                                value: widget.current,
                              ),
                            ],
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
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                          )
                        : Text(
                            widget.state == 'unplugged'.tr() ? 'last_session'.tr() : 'current_session'.tr(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                          ),
                  ),
                  (widget.state == ChargingState.authRequired)
                      ? Container()
                      : SizedBox(
                          width: double.infinity,
                          child: InfoLayout(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: widget.seeMorePressed,
                                  child: _buildInfoCards(
                                    name: widget.chargerModelName,
                                    width: (carSideWidth.isSnapped()) ? (MediaQuery.of(context).size.width - carSideWidth.snapNumber()) / 14 : null,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onBackground,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18
                                    ),
                                  ),
                                ),
                              ),
                              (widget.chargerModelName != "MicroMegaWattCharger")
                                  ? null
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Wrap(
                                        runSpacing: 10,
                                        spacing: 10,
                                        children: [
                                          PrimaryButton(
                                            onPressed: () {
                                              mqtt.publish("everest_external/nodered/1/cmd/pause_charging", "1");
                                            },
                                            child: const Text(
                                              "Pause",
                                              textScaler: TextScaler.linear(2),
                                            ),
                                          ),
                                          PrimaryButton(
                                            onPressed: () {
                                              mqtt.publish("everest_external/nodered/1/cmd/resume_charging", "1");
                                            },
                                            child: const Text(
                                              "Resume",
                                              textScaler: TextScaler.linear(2),
                                            ),
                                          ),
                                          PrimaryButton(
                                            onPressed: () {
                                              mqtt.publish("everest_external/nodered/1/cmd/stop_transaction", "1");
                                            },
                                            child: const Text(
                                              "Stop transaction",
                                              textScaler: TextScaler.linear(2),
                                            ),
                                          ),
                                          PrimaryButton(
                                            onPressed: () {
                                              mqtt.publish("everest_external/nodered/1/cmd/emergency_stop", "1");
                                            },
                                            child: const Text(
                                              "Emerg.Stp",
                                              textScaler: TextScaler.linear(2),
                                            ),
                                          ),
                                          PrimaryButton(
                                            onPressed: () {
                                              mqtt.publish("everest_external/nodered/1/cmd/evse_malfunction", "1");
                                            },
                                            child: const Text(
                                              "EVSE malf",
                                              textScaler: TextScaler.linear(2),
                                            ),
                                          ),
                                          PrimaryButton(
                                            onPressed: () {
                                              mqtt.publish("everest_external/nodered/1/cmd/evse_utility_int", "1");
                                            },
                                            child: const Text(
                                              "EVSEutil int",
                                              textScaler: TextScaler.linear(2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async {
                                    await Navigator.of(context).pushNamed(AppRoutes.hlcLogScreen, arguments: {}).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text(
                                    "See HLC comm log", //TODO Localisation
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
    var showResumeButton = pauseOrResumeChargingTitle(widget.state) != ChargingState.charging
        && widget.state != ChargingState.authRequired
        && pauseOrResumeChargingTitle(widget.state) != '';
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
              child: Text(
                'pause'.tr(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: widget.onPauseCharging,
            )
          : (showResumeButton)
              ? FilledButton(
                  child: Text(
                    'resume'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  onPressed: widget.onResumeCharging,
                )
              : Container(),
    );
  }

  Widget _buildInfoCards({
    required String name,
    double? width,
    TextStyle? style,
  }) {
    if (name == "MicroMegaWattCharger" || true) {
      List<Text> titles = [
        Text(
          'Output Voltage : ',
          style: style,
        ),
        Text(
          'Relais : ',
          style: style,
        ),
        Text(
          'PWM DC : ',
          style: style,
        ),
        Text(
          'CP Hi : ',
          style: style,
        ),
        Text(
          'CP Lo : ',
          style: style,
        ),
        Text(
          'State : ',
          style: style,
        ),
      ];
      List<Text> values = [
        Text(
          outputVoltage.toStringAsFixed(2) + ' V',
          style: style,
        ),
        Text(
          relaisState,
          style: style,
        ),
        Text(
          pwmDc.toStringAsFixed(0) + ' %',
          style: style,
        ),
        Text(
          cpHi.toStringAsFixed(2),
          style: style,
        ),
        Text(
          cpLo.toStringAsFixed(2),
          style: style,
        ),
        Text(
          stateString,
          style: style,
        ),
      ];
      double maxWidth = 0.0;
      for (int i = 0; i < min(titles.length, values.length); i++) {
        TextPainter tp = TextPainter(
          text: TextSpan(
            text: titles[i].data,
            style: titles[i].style,
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        double w = tp.width;
        tp = TextPainter(
          text: TextSpan(
            text: values[i].data,
            style: values[i].style,
          ),
          textDirection: TextDirection.rtl,
        );
        tp.layout();
        w += tp.width + 20;
        maxWidth = max(maxWidth, w);
      }
      Color? aColor = Color.lerp(Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.onBackground, 0.2)?.withAlpha(160);
      Color? bColor = Color.lerp(Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.onBackground, 0.4)?.withAlpha(160);
      List<Widget> infos = [];
      for (int i = 0; i < min(titles.length, values.length); i++) {
        infos.add(_buildTextInfo((i % 2 == 0) ? aColor : bColor, values[i], titles[i], maxWidth));
      }
      return Wrap(
        alignment: WrapAlignment.start,
        children: infos,
      );
    } else {
      return Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: (width == null) ? 0 : (MediaQuery.of(context).size.width - width) / 14,
        children: [
          _buildIconInfo('assets/icons/icon_power.svg', widget.power.toStringAsFixed(2) + ' kW', 'power'.tr()),
          _buildIconInfo('assets/icons/icon_energy.svg', widget.energy.toStringAsFixed(2) + ' kWh', 'energy'.tr()),
          _buildIconInfo('assets/icons/icon_charging_duration.svg', widget.duration + ' h', 'duration'.tr())
        ],
      );
    }
  }

  Widget _buildTextInfo(Color? background, Text value, Text title, double width) {
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
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: SvgPicture.asset(
              iconPath,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontFeatures: [
                const FontFeature.tabularFigures(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

Widget getChargingSessionWidgetByState(BuildContext context, String state, double height, double width, double? soc) {
  if (state == 'Charging') {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      ChargingAnimationWidget(),
      if (soc != null)
        Stack(
          children: <Widget>[
            Text(
              soc.toStringAsFixed(0) + "%",
              style: TextStyle(
                fontSize: 60,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 8
                  ..color = Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Text(
              soc.toStringAsFixed(0) + "%",
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
