import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const PrimaryButton(
      {Key? key,
      this.height,
      required this.title,
      this.color = AppColors.primaryAmber,
      this.textColor = Colors.white,
      required this.onPressed,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        width: width,
        height: height ?? screenHeight * 0.12,
        color: color,
        child: Center(
          child: Text(title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
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
              style: AppTextStyles.primaryButtonText
                  .copyWith(color: textColor, fontSize: 24)),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final double? height;
  final String title;
  final Color color;
  final double? width;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const SecondaryButton({
    Key? key,
    this.height,
    this.width,
    required this.title,
    this.color = Colors.white,
    this.textColor = Colors.white,
    required this.onPressed,
    this.borderColor = AppColors.primaryAmber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height ?? screenHeight * 0.12,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        width: width,
        decoration: BoxDecoration(
            color: color, border: Border.all(width: 3, color: borderColor)),
        child: Center(
          child: Text(title.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style:
                  AppTextStyles.primaryButtonText.copyWith(color: textColor)),
        ),
      ),
    );
  }
}

class SwitchSettingsButton extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsets padding;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final TextStyle titleStyle;
  final Color textColor;
  final double height;
  final backgroundColor;

  const SwitchSettingsButton({
    Key? key,
    this.margin = const EdgeInsets.only(left: 16.0, right: 8.0),
    required this.title,
    required this.value,
    required this.onChanged,
    this.titleStyle = AppTextStyles.subTitle4,
    this.padding = const EdgeInsets.only(
      left: 16.0,
      right: 8.0,
    ),
    this.textColor = Colors.black,
    this.height = 56.0,
    this.backgroundColor = AppColors.primaryBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white10),
        ),
        child: Container(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: titleStyle,
                ),
              ),
              CupertinoSwitch(
                activeColor: AppColors.primaryAmber,
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButtonWithTitleBar extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsets padding;
  final String title;
  final VoidCallback onPressed;
  final TextStyle titleStyle;
  final Color textColor;
  final double height;
  final backgroundColor;
  final Icon icon;

  const ActionButtonWithTitleBar({
    Key? key,
    this.margin = const EdgeInsets.only(left: 16.0, right: 8.0),
    required this.title,
    required this.onPressed,
    this.titleStyle = AppTextStyles.subTitle4,
    this.padding = const EdgeInsets.only(
      left: 16.0,
      right: 8.0,
    ),
    this.textColor = Colors.black,
    this.height = 56.0,
    this.backgroundColor = AppColors.primaryBlue,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        margin: margin,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white10),
          ),
          child: Container(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: titleStyle,
                  ),
                ),
                icon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PionixCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color color;

  const PionixCloseButton(
      {Key? key,
      this.onPressed,
      this.color = AppColors.primaryBlue,
      this.title = 'close'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onPressed ?? Navigator.pop(context),
        child: Container(
          width: width * 0.2,
          height: height * 0.1,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.015),
          margin: EdgeInsets.symmetric(vertical: height * 0.02),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title.tr(),
                style: AppTextStyles.heading3.copyWith(
                    color: color == Colors.white
                        ? AppColors.primaryBlue
                        : Colors.white,
                    fontSize: height * 0.05),
              ),
              SizedBox(width: width * 0.01),
              Icon(
                Icons.cancel,
                color: color == Colors.white
                    ? AppColors.primaryBlue
                    : Colors.white,
                size: height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularLabeledIconButton extends StatelessWidget {
  final String iconUrl;
  final String label;
  final VoidCallback onPressed;

  const CircularLabeledIconButton({
    Key? key,
    required this.iconUrl,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Material(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                iconUrl,
                width: screenHeight * 0.02,
                height: screenHeight * 0.02,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.subTitle2,)
      ],
    );
  }
}
