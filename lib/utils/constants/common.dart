import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

class PionixSnackBar {
  static infoSnackBar(BuildContext context, String message,
      {Color backgroundColor = AppColors.primaryBlue,
      Color textColor = Colors.white}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: AppTextStyles.heading2.copyWith(color: textColor),
      ),
    ));
  }

  static errorSnackBar(BuildContext context, String message,
      {Color backgroundColor = AppColors.errorLight,
      Color textColor = Colors.white}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: AppTextStyles.heading2.copyWith(color: textColor),
      ),
    ));
  }

  static successSnackBar(BuildContext context, String message,
      {Color backgroundColor = AppColors.successLight,
      Color textColor = Colors.white}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: AppTextStyles.heading2.copyWith(color: textColor),
      ),
    ));
  }
}
