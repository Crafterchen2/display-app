import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

class Header extends StatelessWidget {
  final VoidCallback onSettingsPressed;
  final bool showSettingsIcon;

  const Header(
      {Key? key,
      required this.onSettingsPressed,
      this.showSettingsIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding:  EdgeInsets.only(left: width * 0.02),
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
            showSettingsIcon
                ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSettingsPressed,
                  child: Container(
              alignment: Alignment.center,
                    padding:  EdgeInsets.symmetric(vertical: height * 0.04, horizontal: height * 0.05),
                    child:  Icon(
                      Icons.settings,
                      color: AppColors.primaryBlue,
                      size: height * 0.08,

                    ),
                  ),
                )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
