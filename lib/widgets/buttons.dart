import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final double height;
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const PrimaryButton(
      {Key? key,
      this.height = 54,
      required this.title,
      this.color = const Color(0xFFFFAC02),
      this.textColor = Colors.white,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding:const EdgeInsets.symmetric(horizontal: 20),
        height: height,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 3, color: AppColors.primaryAmber)),
        child: Center(
          child: Text(title.toUpperCase(),
              style:
                  AppTextStyles.primaryButtonText.copyWith(color: textColor)),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const SecondaryButton(
      {Key? key,
      this.height = 54,
      this.width = 200,
      required this.title,
      this.color = Colors.white,
      this.textColor = Colors.white,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 3, color: AppColors.primaryAmber)),
        child: Center(
          child: Text(title.toUpperCase(),
              style:
                  AppTextStyles.primaryButtonText.copyWith(color: textColor)),
        ),
      ),
    );
  }
}
