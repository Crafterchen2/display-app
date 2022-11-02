import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../theme/app_text_styles.dart';
import '../utils/constants/keys.dart';
import '../utils/datetime_formats.dart';
import '../utils/constants/helper.dart';
import 'buttons.dart';

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
    required this.minCurrentA, required this.stateInfo,
  }) : super(key: key);

  @override
  State<SessionInfoBody> createState() => _SessionInfoBodyState();
}

class _SessionInfoBodyState extends State<SessionInfoBody> {

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    String currentSliderLabel = widget.current.toStringAsFixed(1);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        child: SvgPicture.asset(
                          getChargingSessionIconByState(widget.state),
                          height:
                              widget.state == 'Unplugged' ? null : width * 0.2,
                        ),
                      ),
                      if (widget.state == 'ChargingPausedEVSE' ||
                          widget.state == 'ChargingPausedEV')
                        SvgPicture.asset('assets/icons/icon_pausecharging.svg',
                            height: widget.state == 'Unplugged'
                                ? null
                                : width * 0.08,
                            width: widget.state == 'Unplugged'
                                ? null
                                : width * 0.08),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  children: [
                    if (widget.state == ChargingState.charging)
                      SecondaryButton(
                          width: MediaQuery.of(context).size.width * 0.32,
                          title: 'pause'.tr(),
                          onPressed: widget.onPauseCharging,
                          textColor: AppColors.primaryAmber),
                    if (pauseOrResumeChargingTitle(widget.state) !=
                            ChargingState.charging &&
                        widget.state != ChargingState.authRequired &&
                        pauseOrResumeChargingTitle(widget.state) != '')
                      PrimaryButton(
                        width: MediaQuery.of(context).size.width * 0.32,
                        title: 'resume'.tr(),
                        onPressed: widget.onResumeCharging,
                        textColor: Colors.white,
                      ),

                  ],
                ),
              ),
              if (widget.state != ChargingState.authRequired)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Max Current",
                          style: AppTextStyles.heading3,
                        ),

                        Text(
                          currentSliderLabel,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.digitsHeading3,
                        ),
                      ],
                    ),
                    SizedBox(height: 12,),
                    Slider(
                        min: widget.minCurrentA,
                        max: widget.maxCurrentA,
                        label: currentSliderLabel,
                        activeColor: AppColors.primaryAmber,
                        inactiveColor: Colors.grey,
                        onChanged: (val) {
                          setState(() {});
                          widget.onCurrentChanged(val);
                        },
                        value: widget.current),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: widget.seeMorePressed,
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'status'.tr(),
                      style: AppTextStyles.subTitle4,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Text(
                        chargingStateTitle(widget.state, stateInfo: widget.stateInfo).toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: AppTextStyles.heading6,
                      ),
                    ),
                    widget.state == ChargingState.authRequired
                        ? SizedBox()
                        : SizedBox(height: height * 0.1),
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

                  ],
                ),
                widget.state == ChargingState.authRequired
                    ? SizedBox()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.52,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'energy'.tr(),
                                  style: AppTextStyles.heading3,
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  'power'.tr(),
                                  style: AppTextStyles.heading3,
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  'duration'.tr(),
                                  style: AppTextStyles.heading3,
                                ),
                                SizedBox(height: height * 0.02),
                                Row(
                                  children: [
                                    Text(
                                      widget.online
                                          ? 'online'.tr()
                                          : 'offline'.tr(),
                                      style: AppTextStyles.heading3,
                                    ),
                                    Container(
                                      height: 24,
                                      width: 24,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: width * 0.02),
                                      decoration: BoxDecoration(
                                          color: widget.online
                                              ? AppColors.successLight
                                              : Colors.redAccent,
                                          shape: BoxShape.circle),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.energy.toStringAsFixed(2) + ' kWh',
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.digitsHeading3,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Text(
                                    widget.power.toStringAsFixed(2) + ' kW',
                                    textAlign: TextAlign.start,
                                    style: AppTextStyles.digitsHeading3,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Text(
                                    widget.duration + ' h',
                                    style: AppTextStyles.digitsHeading3,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Text(
                                    dateTimeFormat.format(DateTime.now()),
                                    style: AppTextStyles.digitsHeading3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
