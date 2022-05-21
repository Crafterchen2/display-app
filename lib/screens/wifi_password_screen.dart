import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/buttons.dart';
import '../widgets/text_fields.dart';

class WifiPasswordScreen extends StatelessWidget {
  final TextEditingController passwordController;

  const WifiPasswordScreen({Key? key, required this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.1),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
              width: double.infinity,
              child: IconTextField(
                hintText: 'Enter Password',
                icon: const Icon(
                  Icons.vpn_key,
                  size: 40,
                ),
                controller: passwordController,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                alignment: Alignment.bottomRight,
                color: AppColors.primaryBlue,
                width: double.infinity,
                height: screenHeight * 0.1,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                      width: 200,
                      color: AppColors.primaryAmber,
                      onPressed: () => Navigator.pop(context),
                      title: 'Back',
                    ),
                    const SizedBox(width: 12),
                    PrimaryButton(
                      width: 200,
                      color: AppColors.primaryAmber,
                      onPressed: () {},
                      title: 'Connect',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
