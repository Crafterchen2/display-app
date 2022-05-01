import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pionixbox/data/models/session_info.dart';
import 'package:pionixbox/data/providers/session_info_provider.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

import '../mqtt.dart';
import '../widgets/buttons.dart';
import '../widgets/header_widget.dart';

class PrivateChargerScreenDemo extends StatefulWidget {
  const PrivateChargerScreenDemo({Key? key}) : super(key: key);

  @override
  State<PrivateChargerScreenDemo> createState() =>
      _PrivateChargerScreenDemoState();
}

class _PrivateChargerScreenDemoState extends State<PrivateChargerScreenDemo> {
  late String _status;
  late String _energyTotal;
  late double _chargedEnergy;
  late double _latestTotalw;
  late String _duration;
  late bool _online;
  late String _statusInstruction;
  late SessionInfo _info;
  final mqtt = MQTT();

  @override
  void initState() {
    _status = 'unplugged';
    _energyTotal = '12.3';
    _chargedEnergy = 12.3;
    _latestTotalw = 1000;
    _online = false;
    _duration = '800';
    _statusInstruction = 'Please plug your car';
    // _info = SessionInfo(_energy, _duration, DateTime.now(), _energy, _status);
    _connectMqtt();

    mqtt.subscribe(
        "everest_api/evse_manager/var/session_info", parseSessionInfo);

    super.initState();
  }

  // SessionInfo prepareInfo(dynamic i) {
  //   return SessionInfo(
  //       i["charged_energy_wh"] / 1000.0 as double,
  //       i["charging_duration_s"],
  //       DateTime.now(),
  //       i["charged_energy_wh"].toStringAsFixed(1) + " kWh",
  //       i["state"]);
  // }

  void parseSessionInfo(String message) {
    final i = jsonDecode(message);
    debugPrint(i.toString());
    setState(() {
      _status = i["state"];
      _chargedEnergy = i["charged_energy_wh"] / 1000.0;
      _latestTotalw = i["latest_total_w"] / 1000.0;
      _energyTotal = (_chargedEnergy.toStringAsFixed(1) + " kWh");
      _duration = Duration(seconds: i["charging_duration_s"]).toString();

      // _info = SessionInfo(
      //     chargedEnergy, _duration, DateTime.now(), _energyTotal, _status);
    });
  }

  Future<void> _connectMqtt() async {
    await mqtt.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          const Spacer(flex: 1),
          SessionInfoBody(
            state: _status,
            energy: _chargedEnergy,
            totalEnergy: _energyTotal,
            latestTotalw: _latestTotalw.toString(),
            duration: _duration,
            onPauseCharging: pauseCharging,
            onResumeCharging: resumeCharging,
          ),
          const Spacer(flex: 2),
          const Footer(),
        ],
      ),
    );
  }

  void pauseCharging() {
    const pauseChargingTopic = '/external/cmd/pause_charging';
    mqtt.publish(pauseChargingTopic, "");
    setState(() {});
  }

  void resumeCharging() {
    const resumeChargingTopic = '/external/cmd/resume_charging';
    mqtt.publish(resumeChargingTopic, "");
    setState(() {});
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
  final double energy;
  final String duration;
  final String totalEnergy;
  final String state;
  final String latestTotalw;
  final VoidCallback onPauseCharging;
  final VoidCallback onResumeCharging;

  const SessionInfoBody({
    Key? key,
    required this.energy,
    required this.duration,
    required this.totalEnergy,
    required this.state,
    required this.latestTotalw,
    required this.onPauseCharging,
    required this.onResumeCharging,
  }) : super(key: key);

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
            SecondaryButton(
                title:
                    state == 'Charging' ? 'Pause Charging' : 'Resume Charging',
                onPressed:
                    state == 'Charging' ? onPauseCharging : onResumeCharging),
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
                state,
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
                    children: [
                      Text(
                        latestTotalw.toString(),
                        style: AppTextStyles.heading1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        duration,
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
