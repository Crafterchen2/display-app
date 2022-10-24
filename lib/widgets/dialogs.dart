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
    const yesColor = Color(0xFFFFA800);
    const noColor = Color(0xFF4C4C4C);
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(color: AppColors.primaryBlue),
      ),
      content: Text(content,
          style: const TextStyle(
            color: AppColors.primaryBlue,
          )),
      actions: <Widget>[
        TextButton(
            // color: Colors.green,
            onPressed: onNegativePressed,
            child: Text(
              negativeText,
              style: const TextStyle(color: Colors.white),
            )),
        TextButton(
            // color: Colors.redAccent,
            onPressed: onPositivePressed,
            child: Text(
              positiveText,
              style: const TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
