import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../main.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants/keys.dart';
import '../utils/datetime_formats.dart';
import '../utils/constants/helper.dart';
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
    required this.minCurrentA, required this.stateInfo,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'status'.tr(),
                style: AppTextStyles.subTitle4,
              ),
              Text(
                chargingStateTitle(widget.state, stateInfo: widget.stateInfo).toUpperCase(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTextStyles.heading6,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              _buildCentreWidget(context, currentSliderLabel),
            ],
          ),
          widget.state == ChargingState.authRequired
              ? SizedBox()
              : GestureDetector(
                  onTap: widget.seeMorePressed,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.state == ChargingState.authRequired
                          ? Text(
                              'swipe_your_card_please'.tr(),
                              style: AppTextStyles.subTitle4,
                            )
                          : Text(
                              widget.state == 'unplugged'.tr()
                                  ? 'last_session'.tr()
                                  : 'current_session'.tr(),
                              style: AppTextStyles.subTitle4,
                            ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      _buildInfoCard(context,
                          title: 'energy'.tr(),
                          value: widget.energy.toStringAsFixed(2) + ' kWh'),
                      _buildInfoCard(context,
                          title: 'power'.tr(),
                          value: widget.power.toStringAsFixed(2) + ' kW'),
                      _buildInfoCard(context,
                          title: 'duration'.tr(),
                          value: widget.duration + ' h'),
                      _buildInfoCard(context,
                          title: widget.online ? 'online'.tr() : 'offline'.tr(),
                          value: dateTimeFormat.format(DateTime.now())),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCentreWidget(BuildContext context, String currentLabel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: SvgPicture.asset(
                  getChargingSessionIconByState(widget.state),
                  // height: state == 'Unplugged' ? null : screenHeight * 0.2,
                  // width: screenHeight * 0.2,
                ),
              ),
              if (widget.state == 'ChargingPausedEVSE' ||
                  widget.state == 'ChargingPausedEV')
                SvgPicture.asset(
                  'assets/icons/icon_pausecharging.svg',
                  // height: state == 'Unplugged' ? null : screenWidth * 0.12,
                  // width: state == 'Unplugged' ? null : screenWidth * 0.12
                ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
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
        ),
        if (widget.state != ChargingState.authRequired &&
            widget.current >= widget.minCurrentA &&
            widget.current <= widget.maxCurrentA)
          Column(
            children: [
              _buildInfoCard(context,
                  title: 'Max Current', value: currentLabel),
              Slider(
                      min: widget.minCurrentA,
                      max: widget.maxCurrentA,
                      label: currentLabel,
                      activeColor: AppColors.primaryAmber,
                      inactiveColor: Colors.grey,
                      onChanged: (val) {
                        setState(() {});
                        widget.onCurrentChanged(val);
                      },
                      value: widget.current),
            ],
          ),
      ],
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

  Widget getChargingAnimatedCell() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {});
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SvgPicture.asset(
          'assets/icons/icon_battery_3',
        );
      },
    );
  }
}
