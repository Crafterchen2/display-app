import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'empty.dart';

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
  final Color? color;
  final Color? borderColor;
  final Color? highlightBorderColor;
  final Color? textColor;
  final double borderThickness;

  const SecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
    this.borderColor,
    this.highlightBorderColor,
    this.textColor,
    this.borderThickness = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: borderColor ?? Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: onPressed,
        highlightColor:
            highlightBorderColor ?? Theme.of(context).colorScheme.primary,
        splashColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(borderThickness),
          child: Container(
            color: color ?? Theme.of(context).colorScheme.surface,
            child: Center(
              child: Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: textColor ?? Theme.of(context).colorScheme.primary,
                    ),
              ),
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

  static String getHeroTag() {
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
        textScaler: const TextScaler.linear(2),
      ),
      heroTag: getHeroTag(),
      icon: const Icon(Icons.cancel),
      foregroundColor: (inverted)
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onPrimary,
      backgroundColor: (inverted)
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.primary,
    );
  }
}

class CircularLabeledIconButton extends StatelessWidget {
  final String iconUrl;
  final String label;
  final VoidCallback onPressed;

  const CircularLabeledIconButton({
    super.key,
    required this.iconUrl,
    required this.label,
    required this.onPressed,
  });

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
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class PionixAppBar extends AppBar {

  // leadingSize default value is the same as the default value of
  // leadingWidth.
  PionixAppBar(String title, {super.key, double leadingSize = 56.0, bool hideBackButton = false}) : super(
    title: Text(title),
    leadingWidth: leadingSize,
    leading: (hideBackButton) ? Empty() : BackButton(),
  );

}