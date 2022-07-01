import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/utils/helper.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class NetworkCardWidget extends StatelessWidget {
  final String ssid;
  final bool isConnected;
  final int signalLevel;
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
      this.signalLevel = -50})
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SvgPicture.asset(
                    getWifiIcon(signalLevel),
                  ),

                  // Icon(
                  //   ssid == 'Hidden SSID' ? Icons.block_rounded : Icons.wifi,
                  //   size: 40,
                  //   color: AppColors.primaryBlue,
                  // ),
                ),
                Expanded(
                    child: Text(
                  ssid,
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primaryBlue,
                  ),
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
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        color: strengthColor,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(strength,
                        style: AppTextStyles.heading3
                            .copyWith(fontSize: 18, color: Colors.white)),
                  ),
                ),
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
