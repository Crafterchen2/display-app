import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/main.dart';
import 'package:pionixbox/theme/app_colors.dart';

const everestLogo = 'assets/icons/everest_horizontal_color_logo.svg';
const rpiLogo = 'assets/icons/powered_by_raspberry_pi_logo_black.svg';
final targetPlatform = Platform.environment['PIONIXBOX_TARGET_PLATFORM']??'';

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
            Row(
              children: [
                SvgPicture.asset(
                  everestLogo,
                  width: 100,
                  height: 50,
                ),
                Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                targetPlatform == "rpi"
                    ? SvgPicture.asset(
                        rpiLogo, // FIXME: make this configurable at build time!
                        width: 72,
                        height: 36,
                      )
                    : Container()
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSettingsPressed,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.04,
                    horizontal: screenHeight * 0.05),
                child: Icon(
                  privateMode ? Icons.settings : Icons.language,
                  color: AppColors.primaryBlue,
                  size: 48,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
