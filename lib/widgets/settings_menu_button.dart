import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SettingMenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final TextStyle style;

  const SettingMenuButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.style = AppTextStyles.subTitle4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: screenWidth * 0.2,
        width: screenWidth * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primaryBlue,
              size: 60,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: style,
              textAlign: TextAlign.center,
            )
          ],
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
