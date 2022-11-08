import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../main.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants/helper.dart';
import '../utils/constants/keys.dart';
import 'buttons.dart';

class SessionInfoBodyPortrait extends StatefulWidget {
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

  const SessionInfoBodyPortrait({
    Key? key,
    required this.energy,
    required this.duration,
    required this.totalEnergy,
    required this.state,
    required this.latestTotalw,
    required this.onPauseCharging,
    required this.onResumeCharging,
    required this.onCurrentChanged,
    this.online = true,
    this.power = 0.0,
    this.seeMorePressed,
    required this.current,
    required this.maxCurrentA,
    required this.minCurrentA,
    required this.stateInfo,
  }) : super(key: key);

  @override
  State<SessionInfoBodyPortrait> createState() =>
      _SessionInfoBodyPortraitState();
}

class _SessionInfoBodyPortraitState extends State<SessionInfoBodyPortrait> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    String currentSliderLabel = widget.current.toStringAsFixed(1);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildStatusWidget(),
          _buildImageWidget(context),
          _buildChargingButton(),
          widget.state == ChargingState.authRequired
              ? SizedBox()
              : _buildSessionInfoWidget(currentSliderLabel),
        ],
      ),
    );
  }

  Widget _buildSessionInfoWidget(String currentLable) {
    return GestureDetector(
        onTap: widget.seeMorePressed,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.state == ChargingState.authRequired
                ? Text(
                    'swipe_your_card_please'.tr(),
                    style: AppTextStyles.heading3,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.state == 'unplugged'.tr()
                            ? 'last_session'.tr()
                            : 'current_session'.tr(),
                        style: AppTextStyles.heading3,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.online
                                  ? AppColors.successLight
                                  : AppColors.errorLight),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 12),
                            child: Text(
                              widget.online ? 'online'.tr() : 'offline'.tr(),
                              style: AppTextStyles.subTitle2
                                  .copyWith(color: Colors.white),
                            ),
                          )),
                    ],
                  ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: AppColors.primaryBlue,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSessionInforCard('assets/icons/icon_power.svg',
                      widget.power.toStringAsFixed(2) + ' kW', 'power'.tr()),
                  _buildSessionInforCard('assets/icons/icon_energy.svg',
                      widget.energy.toStringAsFixed(2) + ' kWh', 'energy'.tr()),
                  _buildSessionInforCard(
                      'assets/icons/icon_charging_duration.svg',
                      widget.duration + ' h',
                      'duration'.tr()),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            if (widget.state != ChargingState.authRequired &&
                widget.current >= widget.minCurrentA &&
                widget.current <= widget.maxCurrentA)
              Align(
                  alignment: Alignment.center,
                  child: _buildSliderWidget(currentLable)),
          ],
        ));
  }

  Widget _buildSessionInforCard(String iconPath, String value, String label) {
    return Container(
      alignment: Alignment.center,
      height: screenWidth * 0.23,
      width: screenWidth * 0.23,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.heading2),
          SizedBox(
            height: 12,
          ),
          SvgPicture.asset(
            iconPath,
            height: screenWidth * 0.1,
            width: screenWidth * 0.1,
            color: AppColors.primaryBlue,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            value,
            style: AppTextStyles.digitsHeading2
                .copyWith(color: AppColors.primaryBlue),
          ),
        ],
      ),
    );
  }

  // Widget _buildSessionInfoWidget() {
  //   return GestureDetector(
  //     onTap: widget.seeMorePressed,
  //     behavior: HitTestBehavior.opaque,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         widget.state == ChargingState.authRequired
  //             ? Text(
  //                 'swipe_your_card_please'.tr(),
  //                 style: AppTextStyles.subTitle4,
  //               )
  //             : Text(
  //                 widget.state == 'unplugged'.tr()
  //                     ? 'last_session'.tr()
  //                     : 'current_session'.tr(),
  //                 style: AppTextStyles.subTitle4,
  //               ),
  //         SizedBox(
  //           height: screenHeight * 0.02,
  //         ),
  //         _buildInfoCard(context,
  //             title: 'energy'.tr(),
  //             value: widget.energy.toStringAsFixed(2) + ' kWh'),
  //         _buildInfoCard(context,
  //             title: 'power'.tr(),
  //             value: widget.power.toStringAsFixed(2) + ' kW'),
  //         _buildInfoCard(context,
  //             title: 'duration'.tr(), value: widget.duration + ' h'),
  //         _buildInfoCard(context,
  //             title: widget.online ? 'online'.tr() : 'offline'.tr(),
  //             value: dateTimeFormat.format(DateTime.now())),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildImageWidget(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: getChargingSessionWidgetByState(widget.state)
              ),
              if (widget.state == 'ChargingPausedEVSE' ||
                  widget.state == 'ChargingPausedEV')
                SvgPicture.asset(
                  'assets/icons/icon_pausecharging.svg',
                  height:
                      widget.state == 'Unplugged' ? null : screenWidth * 0.15,
                  width:
                      widget.state == 'Unplugged' ? null : screenWidth * 0.15,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderWidget(String currentLabel) {
    return SizedBox(
      width: screenWidth * 0.8,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.minCurrentA.toString(),
                style: AppTextStyles.heading2.copyWith(color: Colors.grey),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                      overlayShape: SliderComponentShape.noThumb),
                  child: Slider(
                      min: widget.minCurrentA,
                      max: widget.maxCurrentA,
                      label: currentLabel,
                      activeColor: AppColors.primaryAmber,
                      inactiveColor: Colors.grey.shade300,
                      onChanged: (val) {
                        setState(() {});
                        widget.onCurrentChanged(val);
                      },
                      value: widget.current),
                ),
              ),
              Text(
                widget.maxCurrentA.toString(),
                style: AppTextStyles.heading2.copyWith(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.005,
          ),
          Text(
            'charge_upto'.tr() + ' ' + widget.current.toStringAsFixed(1) + " A",
            style: AppTextStyles.subTitle2,
          )
        ],
      ),
    );
  }

  Widget _buildChargingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
      child: Column(
        children: [
          if (widget.state == ChargingState.charging)
            SecondaryButton(
                title: 'pause'.tr(),
                onPressed: widget.onPauseCharging,
                textColor: AppColors.primaryAmber),
          if (pauseOrResumeChargingTitle(widget.state) !=
                  ChargingState.charging &&
              widget.state != ChargingState.authRequired &&
              pauseOrResumeChargingTitle(widget.state) != '')
            PrimaryButton(
              title: 'resume'.tr(),
              onPressed: widget.onResumeCharging,
              textColor: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'status'.tr(),
              style: AppTextStyles.subTitle4,
            ),
          ),
          Text(
            chargingStateTitle(widget.state, stateInfo: widget.stateInfo)
                .toUpperCase(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: AppTextStyles.heading6.copyWith(fontSize: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppTextStyles.heading3,
            ),
            if (title == 'Online' || title == 'Offline')
              Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: widget.online
                        ? AppColors.successLight
                        : Colors.redAccent,
                    shape: BoxShape.circle),
              ),
          ],
        ),
        Text(
          value,
          textAlign: TextAlign.start,
          style: AppTextStyles.digitsHeading3,
        ),
      ],
    );
  }
}

Widget getChargingSessionWidgetByState(String state) {
  if (state == 'Charging') {
    return ChargingAnimationWidget();
  } else {
    return SvgPicture.asset(
      getChargingSessionIconByState(state),
      height: screenHeight * 0.2,
      width: screenWidth * 0.4,
    );
  }
}

class ChargingAnimationWidget extends StatefulWidget {
  List<String> battery_states = [
    'assets/icons/icon_battery_1.svg',
    'assets/icons/icon_battery_2.svg',
    'assets/icons/icon_battery_3.svg',
    'assets/icons/icon_battery_4.svg',
  ];

  @override
  State<StatefulWidget> createState() => ChargingAnimationWidgetState();
}

class ChargingAnimationWidgetState extends State<ChargingAnimationWidget> {
  int index = 0;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        index = (index + 1) % widget.battery_states.length;
        debugPrint('INDEX: ${index}');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.battery_states[index],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
