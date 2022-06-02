import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SettingMenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const SettingMenuButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: screenWidth * 0.1,
            width: screenWidth * 0.1,
            child: Center(
              child: Icon(
                icon,
                color: AppColors.primaryBlue,
                size: screenWidth * 0.08,
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          SizedBox(
            height: screenWidth * 0.02,
          ),
          Text(
            title,
            style: AppTextStyles.subTitle4.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
