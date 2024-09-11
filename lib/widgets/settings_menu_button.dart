import 'package:flutter/material.dart';
import 'package:pionixbox/main.dart';

class SettingMenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final TextStyle? style;

  const SettingMenuButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width <
              (adjustScale(235) * 2) + adjustScale(30))
          ? null
          : adjustScale(235),
      height: (MediaQuery.of(context).size.width <
              (adjustScale(235) * 2) + adjustScale(30))
          ? null
          : adjustScale(235),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(adjustScale(12)),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    alignment: (MediaQuery.of(context).size.width <
                            (adjustScale(235) * 2) + adjustScale(30))
                        ? WrapAlignment.spaceBetween
                        : WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Theme.of(context).colorScheme.primary,
                        size: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: (MediaQuery.of(context).size.width <
                                  (adjustScale(235) * 2) + adjustScale(30))
                              ? adjustScale(10)
                              : 0,
                        ),
                        child: Text(
                          title,
                          style:
                              style ?? Theme.of(context).textTheme.displaySmall,
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
