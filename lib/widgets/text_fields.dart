import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

class IconTextField extends StatelessWidget {
  final Icon icon;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final TextInputType keyboardType;
  final VoidCallback? onTap;

  const IconTextField({
    Key? key,
    required this.icon,
    required this.controller,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(20.00)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          icon,
          Expanded(
            child: TextField(
              readOnly: true,
              onTap: onTap,
              controller: controller,
              focusNode: focusNode,
              style: AppTextStyles.heading6.copyWith(
                  color: AppColors.primaryBlue,
                  fontSize: MediaQuery.of(context).size.height * 0.08),
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  hintText: hintText,
                  hintStyle: AppTextStyles.heading6
                      .copyWith(color: Colors.grey.shade400)),
            ),
          ),
        ],
      ),
    );
  }
}
