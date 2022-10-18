import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../main.dart';
import '../theme/app_text_styles.dart';
import '../utils/constants/keys.dart';
import '../utils/datetime_formats.dart';
import '../utils/helper.dart';
import 'buttons.dart';

class SessionInfoBodyPortrait extends StatelessWidget {
  final double energy;
  final String duration;
  final String totalEnergy;
  final double power;
  final String state;
  final double latestTotalw;
  final bool online;
  final VoidCallback? seeMorePressed;
  final VoidCallback onPauseCharging;
  final VoidCallback onResumeCharging;

  const SessionInfoBodyPortrait({
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                chargingStateTitle(state).toUpperCase(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTextStyles.heading6,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              _buildCentreWidget(context),
            ],
          ),
          state == ChargingState.authRequired
              ? SizedBox()
              : GestureDetector(
                  onTap: state == 'unplugged'.tr() ? () {} : seeMorePressed,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state == ChargingState.authRequired
                          ? Text(
                              'swipe_your_card_please'.tr(),
                              style: AppTextStyles.subTitle4,
                            )
                          : Text(
                              state == 'unplugged'.tr()
                                  ? 'last_session'.tr()
                                  : 'current_session'.tr(),
                              style: AppTextStyles.subTitle4,
                            ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      _buildInfoCard(context,
                          title: 'energy'.tr(),
                          value: energy.toStringAsFixed(2) + ' kWh'),
                      _buildInfoCard(context,
                          title: 'power'.tr(),
                          value: power.toStringAsFixed(2) + ' kW'),
                      _buildInfoCard(context,
                          title: 'duration'.tr(), value: duration + ' h'),
                      _buildInfoCard(context,
                          title: online ? 'online'.tr() : 'offline'.tr(),
                          value: dateTimeFormat.format(DateTime.now())),
                    ],
                  ),
                ),
          // SizedBox(
          //   // width: screenWidth * 0.52,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'energy'.tr(),
          //             style: AppTextStyles.heading3,
          //           ),
          //           SizedBox(height: height * 0.02),
          //           Text(
          //             'power'.tr(),
          //             style: AppTextStyles.heading3,
          //           ),
          //           SizedBox(height: height * 0.02),
          //           Text(
          //             'duration'.tr(),
          //             style: AppTextStyles.heading3,
          //           ),
          //           SizedBox(height: height * 0.02),
          //           Row(
          //             children: [
          //               Text(
          //                 online ? 'online'.tr() : 'offline'.tr(),
          //                 style: AppTextStyles.heading3,
          //               ),
          //               Container(
          //                 height: 24,
          //                 width: 24,
          //                 margin:
          //                     EdgeInsets.symmetric(horizontal: width * 0.02),
          //                 decoration: BoxDecoration(
          //                     color: online
          //                         ? AppColors.successLight
          //                         : Colors.redAccent,
          //                     shape: BoxShape.circle),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //       const Spacer(),
          //       SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.35,
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.end,
          //           children: [
          //             Text(
          //               energy.toStringAsFixed(2) + ' kWh',
          //               textAlign: TextAlign.start,
          //               style: AppTextStyles.digitsHeading3,
          //             ),
          //             SizedBox(height: height * 0.02),
          //             Text(
          //               power.toStringAsFixed(2) + ' kW',
          //               textAlign: TextAlign.start,
          //               style: AppTextStyles.digitsHeading3,
          //             ),
          //             SizedBox(height: height * 0.02),
          //             Text(
          //               duration + ' h',
          //               style: AppTextStyles.digitsHeading3,
          //             ),
          //             SizedBox(height: height * 0.02),
          //             Text(
          //               dateTimeFormat.format(DateTime.now()),
          //               style: AppTextStyles.digitsHeading3,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildCentreWidget(BuildContext context) {
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
                  getChargingSessionIconByState(state),
                  // height: state == 'Unplugged' ? null : screenHeight * 0.2,
                  // width: screenHeight * 0.2,
                ),
              ),
              if (state == 'ChargingPausedEVSE' || state == 'ChargingPausedEV')
                SvgPicture.asset('assets/icons/icon_pausecharging.svg',
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
              if (state == ChargingState.charging)
                SecondaryButton(
                    title: 'pause'.tr(),
                    onPressed: onPauseCharging,
                    textColor: AppColors.primaryAmber),
              if (pauseOrResumeChargingTitle(state) != ChargingState.charging &&
                  state != ChargingState.authRequired &&
                  pauseOrResumeChargingTitle(state) != '')
                PrimaryButton(
                  title: 'resume'.tr(),
                  onPressed: onResumeCharging,
                  textColor: Colors.white,
                ),
            ],
          ),
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
                    color: online ? AppColors.successLight : Colors.redAccent,
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
