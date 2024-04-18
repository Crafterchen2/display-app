import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ListSectionLabel extends StatelessWidget {
  final String label;

  const ListSectionLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
      child: Row(
        children: [
          Container(
            height: 1,
            width: screenWidth * 0.1,
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Text(
              label,
              style: AppTextStyles.subTitle4
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
