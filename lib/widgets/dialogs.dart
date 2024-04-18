import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

import '../main.dart';

showPionixBottomSheet({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  String? barrierLabel,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
  double? heightPercent,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor ?? AppColors.white,
    barrierLabel: barrierLabel,
    elevation: elevation ?? 20,
    shape: shape ?? RoundedRectangleBorder(
      side: const BorderSide(
        width: 2,
        color: Colors.white30,
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(adjustScale(12)),
        topRight: Radius.circular(adjustScale(12)),
      ),
    ),
    clipBehavior: clipBehavior,
    constraints: constraints,
    barrierColor: barrierColor,
    isScrollControlled: (heightPercent != null)? true : isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle ?? true,
    useSafeArea: useSafeArea,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    anchorPoint: anchorPoint,
    builder: (context){
      return SizedBox(
        height: MediaQuery.of(context).size.height * (heightPercent ?? 0.5),
        child: builder.call(context),
      );
    },
  );
}

class BasicDialog extends StatelessWidget {
  final String title;
  final String content;
  final String positiveText;
  final String negativeText;
  final VoidCallback onPositivePressed;
  final VoidCallback onNegativePressed;

  const BasicDialog({
    Key? key,
    required this.title,
    this.content = '',
    required this.positiveText,
    required this.negativeText,
    required this.onPositivePressed,
    required this.onNegativePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 40),
      ),
      content: Text(content,
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 30)),
      actions: <Widget>[
        TextButton(
            // color: Colors.green,
            onPressed: onNegativePressed,
            child: Text(
              negativeText,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 36),
            )),
        const SizedBox(
          width: 50,
        ),
        TextButton(
            // color: Colors.redAccent,
            onPressed: onPositivePressed,
            child: Text(
              positiveText,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 36),
            ))
      ],
    );
  }
}
