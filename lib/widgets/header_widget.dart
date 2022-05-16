import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_colors.dart';

class Header extends StatelessWidget {
  final VoidCallback onSettingsPressed;

  const Header({Key? key, required this.onSettingsPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      margin: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage('assets/images/everest_logo.png'),
              width: 200,
              height: 100,
            ),
            IconButton(
                onPressed: onSettingsPressed,
                icon: const Icon(
                  Icons.settings,
                  color: AppColors.primaryBlue,
                  size: 40,
                ))
          ],
        ),
      ),
    );
  }
}
