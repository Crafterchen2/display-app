import 'dart:ui';

import 'package:easy_localization/easy_localization.dart'
as _virtual_keyboard_backspace_event_period;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/mqtt.dart';
import 'package:pionixbox/utils/enums.dart';
import 'package:pionixbox/utils/globals.dart';
import 'package:pionixbox/utils/number_tools.dart';
import 'package:pionixbox/utils/routing/app_router.dart';

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
      mqtt.subscribe(
          "everest_external/umwc/output_voltage", parseOutputVoltage);
      mqtt.subscribe("everest_external/umwc/cp_hi", parseCpHi);
      mqtt.subscribe("everest_external/umwc/cp_lo", parseCpLo);
      mqtt.subscribe("everest_external/umwc/pwm_dc", parsePwmDc);
      mqtt.subscribe(
          "everest_external/nodered/1/state/state_string", parseStateString);
    } catch (e) {
      debugPrint('Loading failed, Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentSliderLabel = widget.current.toStringAsFixed(1);
    //Change the snapping behavior below is sufficient.
    double snapped = 300;
    double offset = 20;
    NumberSnap carSideWidth = NumberSnap(
      parameter: MediaQuery.of(context).size.width - adjustScale(snapped),
      snapped: adjustScale(snapped - offset),
      threshold: adjustScale(150),
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
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Text(
                              chargingStateTitle(widget.state)
                                  .toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        ),
                        _buildImageWidget(context),
                        if (widget.chargingMode == ChargingMode.unknown ||
                            widget.chargingMode == ChargingMode.basicAC)
                          SizedBox(
                            height: adjustScale(60),
                            width: carSideWidth.snapNumber(),
                            child: (widget.state == ChargingState.charging) ?
                            OutlinedButton(
                              child: Text(
                                'pause'.tr(),
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              onPressed: widget.onPauseCharging,
                              //textColor: AppColors.primaryAmber,
                            )
                                : (pauseOrResumeChargingTitle(widget.state) != ChargingState.charging &&
                                widget.state != ChargingState.authRequired &&
                                pauseOrResumeChargingTitle(widget.state) != '') ?
                            FilledButton(
                              child: Text(
                                'resume'.tr(),
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              onPressed: widget.onResumeCharging,
                              //textColor: Colors.white,
                            )
                                : Container(),
                          ),
                        if (widget.state != ChargingState.authRequired &&
                            widget.current >= widget.minCurrentA &&
                            widget.current <= widget.maxCurrentA)
                          Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    'charge_upto'.tr() + ' ',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        currentSliderLabel,
                                        textAlign: TextAlign.start,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontFeatures: [
                                          const FontFeature.tabularFigures(),
                                        ],
                                      ),
                                      ),
                                      Text(
                                        ' A',
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context).textTheme.headlineSmall,
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
                                  value: widget.current),
                            ],
                          ),
                      ],
                    ),
                  ),
                  //TODO fix err "Null check operator used on a null value"
                  if (carSideWidth.isSnapped())
                    SizedBox(
                      height: adjustScale(350),
                      child: VerticalDivider(
                        thickness: adjustScale(2),
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            if (!carSideWidth.isSnapped())
              Divider(
                thickness: adjustScale(2),
                color: Colors.grey,
              ),
            SizedBox(
              width:
              carSideWidth.snapNumber(ovrSnapped: carSideWidth.parameter),
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
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                        : Text(
                      widget.state == 'unplugged'.tr()
                          ? 'last_session'.tr()
                          : 'current_session'.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  widget.state == ChargingState.authRequired
                      ? Container()
                      : GestureDetector(
                        onTap: widget.seeMorePressed,
                        behavior: HitTestBehavior.opaque,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: carSideWidth.threshold,
                          ),
                          child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                            ),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            children:
                            _buildInfoCards(widget.chargerModelName),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -2, 0),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () async {
                            /*final result = */ await Navigator.of(context)
                                .pushNamed(AppRoutes.hlcLogScreen,
                                arguments: {}).then((value) {
                              setState(() {});
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "See HLC comm log", //TODO Localisation
                              style:
                              Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.grey,
                              ),
                              softWrap: true,
                              maxLines: 4,
                            ),
                          ),
                        )),
                  ),
                  if (widget.chargerModelName == "MicroMegaWattCharger")
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: PrimaryButton(
                            //width: screenWidth * 0.3,
                            onPressed: () {
                              mqtt.publish(
                                  "everest_external/nodered/1/cmd/pause_charging",
                                  "1");
                            },
                            child: const Text("Pause"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: PrimaryButton(
                            //width: screenWidth * 0.3,
                            onPressed: () {
                              mqtt.publish(
                                  "everest_external/nodered/1/cmd/resume_charging",
                                  "1");
                            },
                            child: const Text("Resume"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: PrimaryButton(
                            //width: screenWidth * 0.3,
                            onPressed: () {
                              mqtt.publish(
                                  "everest_external/nodered/1/cmd/stop_transaction",
                                  "1");
                            },
                            child: const Text("Stop transaction"),
                          ),
                        ),
                      ],
                    ),
                  if (widget.chargerModelName == "MicroMegaWattCharger")
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: PrimaryButton(
                            //width: screenWidth * 0.3,
                            onPressed: () {
                              mqtt.publish(
                                  "everest_external/nodered/1/cmd/emergency_stop",
                                  "1");
                            },
                            child: const Text("Emerg.Stp"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: PrimaryButton(
                            //width: screenWidth * 0.3,
                            onPressed: () {
                              mqtt.publish(
                                  "everest_external/nodered/1/cmd/evse_malfunction",
                                  "1");
                            },
                            child: const Text("EVSE malf"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: PrimaryButton(
                            //width: screenWidth * 0.3,
                            onPressed: () {
                              mqtt.publish(
                                  "everest_external/nodered/1/cmd/evse_utility_int",
                                  "1");
                            },
                            child: const Text("EVSEutil int"),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionInfoCard(String? iconPath, String value, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: adjustScale(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(label,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (iconPath != null)
            SizedBox(
              height: adjustScale(10.0),
            ),
          if (iconPath != null)
            SvgPicture.asset(
              iconPath,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (iconPath != null)
            SizedBox(
              height: adjustScale(10),
            ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          if (iconPath == null)
            SizedBox(
              height: adjustScale(10),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildInfoCards(String chargerModelName) {
    if (chargerModelName == "MicroMegaWattCharger") {
      return [
        _buildSessionInfoCard(
            null, outputVoltage.toStringAsFixed(2) + ' V', 'Output Voltage'),
        _buildSessionInfoCard(null, relaisState, 'Relais'),
        _buildSessionInfoCard(null, pwmDc.toStringAsFixed(0) + ' %', 'PWM DC'),
        _buildSessionInfoCard(null, cpHi.toStringAsFixed(2), 'CP Hi'),
        _buildSessionInfoCard(null, cpLo.toStringAsFixed(2), 'CP Lo'),
        _buildSessionInfoCard(null, stateString, 'State'),
      ];
    }
    return [
      _buildSessionInfoCard('assets/icons/icon_power.svg',
          widget.power.toStringAsFixed(2) + ' kW', 'power'.tr()),
      _buildSessionInfoCard('assets/icons/icon_energy.svg',
          widget.energy.toStringAsFixed(2) + ' kWh', 'energy'.tr()),
      _buildSessionInfoCard('assets/icons/icon_charging_duration.svg',
          widget.duration + ' h', 'duration'.tr())
    ];
  }

  Widget _buildImageWidget(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: getChargingSessionWidgetByState(context, widget.state, adjustScale(96), adjustScale(320), widget.soc)),
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
                  ..color = Theme.of(context).colorScheme.primary,
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
      width: width,
    );
  }
}
