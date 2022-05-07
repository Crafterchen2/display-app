import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/datetime_formats.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Online',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 16,
                  width: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                      color: AppColors.successLight, shape: BoxShape.circle),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dateTimeFormat.format(DateTime.now()),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
