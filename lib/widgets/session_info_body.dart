import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../theme/app_text_styles.dart';
import '../utils/constants/keys.dart';
import '../utils/helper.dart';
import 'buttons.dart';

class SessionInfoBody extends StatelessWidget {
  final double energy;
  final String duration;
  final String totalEnergy;
  final String state;
  final String latestTotalw;
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
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
                            height: state == 'Unplugged' ? null : 200,
                            width: state == 'Unplugged' ? null : 200),
                      ),
                      if (state == 'ChargingPausedEVSE' ||
                          state == 'ChargingPausedEV')
                        SvgPicture.asset(
                          'assets/icons/icon_pausecharging.svg',
                            height: state == 'Unplugged' ? null : 100,
                            width: state == 'Unplugged' ? null : 100
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Column(
                  children: [
                    if (state == ChargingState.charging)
                      SecondaryButton(
                          title: 'Pause Charging',
                          onPressed: onPauseCharging,
                          textColor: AppColors.primaryAmber),
                    if (pauseOrResumeChargingTitle(state) !=
                            ChargingState.charging &&
                        pauseOrResumeChargingTitle(state) != '')
                      PrimaryButton(
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 50),
              Text(
                state == 'Unplugged'
                    ? 'Last Session'.toUpperCase()
                    : 'Current Session'.toUpperCase(),
                style: AppTextStyles.subTitle4,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Energy',
                          style: AppTextStyles.heading3,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Duration',
                          style: AppTextStyles.heading3,
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            energy.toStringAsFixed(2) + ' kWh',
                            textAlign: TextAlign.start,
                            style: AppTextStyles.digitsHeading3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            duration + ' h',
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
