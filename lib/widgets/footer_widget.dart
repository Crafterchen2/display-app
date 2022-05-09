import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

import '../theme/app_colors.dart';
import '../utils/datetime_formats.dart';

class Footer extends StatefulWidget {
  final bool isOnline;

  const Footer({
    Key? key,
    this.isOnline = true,
  }) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

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
                Text(
                  widget.isOnline ? 'Online' : 'Offline',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(width: 8),
                Container(
                  height: 16,
                  width: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: widget.isOnline
                          ? AppColors.successLight
                          : Colors.redAccent,
                      shape: BoxShape.circle),
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
                  style: AppTextStyles.digitsHeading3,
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
