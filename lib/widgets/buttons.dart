import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const PrimaryButton(
      {Key? key,
      this.height = 64,
      required this.title,
      this.color = AppColors.primaryAmber,
      this.textColor = Colors.white,
      required this.onPressed,
      this.width = 400})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        width: width,
        height: height,
        color: color,
        child: Center(
          child: Text(title.toUpperCase(),
              style:
                  AppTextStyles.primaryButtonText.copyWith(color: textColor)),
        ),
      ),
    );
  }
}

class PrimaryButton2 extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const PrimaryButton2(
      {Key? key,
        this.height = 78,
        required this.title,
        this.color = AppColors.primaryAmber,
        this.textColor = Colors.white,
        required this.onPressed,
        this.width = 500})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        width: width,
        height: height,
        color: color,
        child: Center(
          child: Text(title.toUpperCase(),
              style:
              AppTextStyles.primaryButtonText.copyWith(color: textColor, fontSize: 24)),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final double height;
  final String title;
  final Color color;
  final double width;

  final Color textColor;
  final VoidCallback onPressed;

  const SecondaryButton(
      {Key? key,
      this.height = 64,
      this.width = 300,
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
        width: width,
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
