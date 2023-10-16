import 'package:flutter/material.dart';
import 'package:pionixbox/main.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SettingMenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final TextStyle style;

  const SettingMenuButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.style = AppTextStyles.subTitle4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width < (adjustScale(235)*2)+adjustScale(30)) ? null : adjustScale(235),
      height: (MediaQuery.of(context).size.width < (adjustScale(235)*2)+adjustScale(30)) ? null : adjustScale(235),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(adjustScale(12)),
            color: AppColors.primaryAmber, //white --> primaryAmber //NOTE: Weiß nicht ob das besser ist, vermutlich nicht
          ),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    alignment: (MediaQuery.of(context).size.width < (adjustScale(235)*2)+adjustScale(30)) ? WrapAlignment.spaceBetween: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: AppColors.primaryBlue,
                        size: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: (MediaQuery.of(context).size.width < (adjustScale(235)*2)+adjustScale(30)) ? adjustScale(10) : 0,
                        ),
                        child: Text(
                          title,
                          style: style,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
