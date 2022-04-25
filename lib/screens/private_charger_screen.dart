import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/data/models/session_info.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

import '../widgets/buttons.dart';
import '../widgets/header_widget.dart';

class PrivateChargerScreen extends StatelessWidget {
  const PrivateChargerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Header(),
          Spacer(flex: 1),
          SessionInfoBody(),
          Spacer(flex: 2),
          Footer(),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          PrimaryButton(
            title: 'Full of charge',
            onPressed: () {},
            color: AppColors.successLight,
          ),
          PrimaryButton(
            title: 'Pause by car',
            onPressed: () {},
            color: AppColors.errorLight,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Online',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                height: 16,
                width: 16,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                    color: AppColors.successLight, shape: BoxShape.circle),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateTime.now().toIso8601String(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SessionInfoBody extends StatelessWidget {
  final SessionInfo? info;

  const SessionInfoBody({Key? key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(
          flex: 2,
        ),
        Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: SvgPicture.asset('assets/icons/icon_charging.svg'),
                ),
                SvgPicture.asset('assets/icons/icon_pausecharging.svg'),
              ],
            ),
            const SizedBox(height: 36),
            SecondaryButton(title: 'Resume Charging', onPressed: () {}),
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'STATUS',
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                'Unplugged'.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTextStyles.heading6,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Current Session'.toUpperCase(),
              style: AppTextStyles.subTitle2,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Energy',
                        style: AppTextStyles.heading1,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Duration',
                        style: AppTextStyles.heading1,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Energy',
                        style: AppTextStyles.heading1,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Duration',
                        style: AppTextStyles.heading1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
