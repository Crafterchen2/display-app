import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

class IconTextField extends StatelessWidget {
  final Icon icon;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  const IconTextField({
    Key? key,
    required this.icon,
    required this.controller,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.00),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          icon,
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.heading6.copyWith(color: AppColors.primaryBlue),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                hintText: hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
