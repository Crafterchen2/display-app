import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../theme/app_text_styles.dart';

class PrimaryButton extends ElevatedButton {

  const PrimaryButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    required super.child,
  });

}

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final Color highlightBorderColor;
  final Color textColor;
  final double borderThickness;

  const SecondaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color = AppColors.white,
    this.borderColor = AppColors.primaryAmber,
    this.highlightBorderColor = AppColors.primaryBlue,
    this.textColor = AppColors.primaryBlue,
    this.borderThickness = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: borderColor,
      child: InkWell(
        onTap: onPressed,
        highlightColor: highlightBorderColor,
        splashColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(borderThickness),
          child: Container(
            color: color,
            child: Center(
              child: Text(title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: textColor)),
            ),
          ),
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
  final Color backgroundColor;

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
              Switch(
                activeColor: Theme.of(context).colorScheme.secondary,
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
  final Color backgroundColor;
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
  final String title;

  ///if [inverted] == false, then the background will have the themes primary color
  ///and the text will have the themes onPrimary color.
  ///If [inverted] == true, then the text will have the themes primary color
  ///and the background will have the themes onPrimary color.
  final bool inverted;
  final Color color;
  final VoidCallback? onPressed;

  const PionixCloseButton({
    super.key,
    this.color = Colors.green,
    this.inverted = false,
    this.title = 'close',
    this.onPressed,
  });

  static String getHeroTag(){
    return "PionixClose";
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed ??
          () {
            Navigator.pop(context);
          },
      label: Text(
        title.tr(),
        textScaleFactor: 2,
      ),
      heroTag: getHeroTag(),
      icon: const Icon(Icons.cancel),
      foregroundColor: (inverted) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
      backgroundColor: (inverted) ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
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
                width: 10,
                height: 10,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.subTitle2,
        )
      ],
    );
  }
}