import 'package:flutter/material.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/theme/app_colors.dart';

class Header extends StatelessWidget {
  final VoidCallback onSettingsPressed;
  final bool showSettingsIcon;
  final bool privateMode;

  const Header(
      {Key? key,
      required this.onSettingsPressed,
      this.showSettingsIcon = false,
      this.privateMode = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: screenWidth * 0.02),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Image(
              image: AssetImage('assets/images/everest_logo.png'),
              width: 200,
              height: 100,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSettingsPressed,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.04, horizontal: screenHeight * 0.05),
                child: Icon(
                  privateMode ? Icons.settings : Icons.language,
                  color: AppColors.primaryBlue,
                  size: screenHeight * 0.06,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
