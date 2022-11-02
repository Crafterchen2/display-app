import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/utils/constants/helper.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class NetworkCardWidget extends StatelessWidget {
  final String ssid;
  final bool isConnected;
  final int? signalLevel;
  final String strength;
  final Color strengthColor;
  final VoidCallback onPressed;

  const NetworkCardWidget(
      {Key? key,
      required this.ssid,
      required this.onPressed,
      this.isConnected = false,
      this.strength = '',
      this.strengthColor = Colors.white,
      this.signalLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
            child: Row(
              children: [
                ssid != 'Hidden SSID'
                    ? SvgPicture.asset(
                        getWifiIcon(signalLevel ?? -50),
                        height: 40,
                        width: 40,
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.block_rounded,
                          size: 40,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ssid,
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    (signalLevel == null && !isConnected)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Saved',
                              style: AppTextStyles.subTitle2.copyWith(
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                )),
                isConnected
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text('Connected',
                              style: AppTextStyles.heading3
                                  .copyWith(fontSize: 18, color: Colors.white)),
                        ),
                      )
                    : const SizedBox(),
                strength.isNotEmpty
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: strengthColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(strength,
                              style: AppTextStyles.heading3
                                  .copyWith(fontSize: 18, color: Colors.white)),
                        ),
                      )
                    : const SizedBox(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.chevron_right,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 0.2,
            width: double.infinity,
            color: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
