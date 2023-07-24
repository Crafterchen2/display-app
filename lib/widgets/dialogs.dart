import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

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
        style: const TextStyle(color: AppColors.primaryBlue, fontSize: 40),
      ),
      content: Text(content,
          style: const TextStyle(color: AppColors.primaryBlue, fontSize: 30)),
      actions: <Widget>[
        TextButton(
            // color: Colors.green,
            onPressed: onNegativePressed,
            child: Text(
              negativeText,
              style:
                  const TextStyle(color: AppColors.primaryBlue, fontSize: 36),
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
                  const TextStyle(color: AppColors.primaryBlue, fontSize: 36),
            ))
      ],
    );
  }
}
