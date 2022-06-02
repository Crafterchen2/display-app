import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../theme/app_text_styles.dart';
import '../utils/constants/keys.dart';
import '../utils/datetime_formats.dart';
import '../utils/helper.dart';
import 'buttons.dart';

class SessionInfoBody extends StatelessWidget {
  final double energy;
  final String duration;
  final String totalEnergy;
  final String state;
  final String latestTotalw;
  final bool online;
  final VoidCallback onPauseCharging;
  final VoidCallback onResumeCharging;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                          getChargingSessionIconByState(state),
                          height: state == 'Unplugged' ? null : width * 0.2,
                        ),
                      ),
                      if (state == 'ChargingPausedEVSE' ||
                          state == 'ChargingPausedEV')
                        SvgPicture.asset('assets/icons/icon_pausecharging.svg',
                            height: state == 'Unplugged' ? null : width * 0.08,
                            width: state == 'Unplugged' ? null : width * 0.08),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Column(
                  children: [
                    if (state == ChargingState.charging)
                      SecondaryButton(
                          width: MediaQuery.of(context).size.width * 0.32,
                          title: 'Pause Charging',
                          onPressed: onPauseCharging,
                          textColor: AppColors.primaryAmber),
                    if (pauseOrResumeChargingTitle(state) !=
                            ChargingState.charging &&
                        pauseOrResumeChargingTitle(state) != '')
                      PrimaryButton(
                        width: MediaQuery.of(context).size.width * 0.32,
                        title: 'Resume Charging',
                        onPressed: onResumeCharging,
                        textColor: Colors.white,
                      ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'STATUS',
                style: AppTextStyles.subTitle4,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Text(
                  chargingStateTitle(state).toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: AppTextStyles.heading6,
                ),
              ),
              SizedBox(height: height * 0.1),
              Text(
                state == 'Unplugged'
                    ? 'Last Session'.toUpperCase()
                    : 'Current Session'.toUpperCase(),
                style: AppTextStyles.subTitle4,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Energy',
                          style: AppTextStyles.heading3,
                        ),
                        SizedBox(height: height * 0.02),
                        const Text(
                          'Duration',
                          style: AppTextStyles.heading3,
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            Text(
                              online ? 'Online' : 'Offline',
                              style: AppTextStyles.heading3,
                            ),
                            Container(
                              height: 24,
                              width: 24,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              decoration: BoxDecoration(
                                  color: online
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
                            energy.toStringAsFixed(2) + ' kWh',
                            textAlign: TextAlign.start,
                            style: AppTextStyles.digitsHeading3,
                          ),
                          SizedBox(height: height * 0.02),
                          Text(
                            duration + ' h',
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
        ],
      ),
    );
  }
}
