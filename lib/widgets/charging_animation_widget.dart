import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChargingAnimationWidget extends StatefulWidget {
  final List<String> batteryStates = [
    'assets/icons/icon_battery_1.svg',
    'assets/icons/icon_battery_2.svg',
    'assets/icons/icon_battery_3.svg',
    'assets/icons/icon_battery_4.svg',
  ];

  ChargingAnimationWidget({super.key});

  @override
  State<StatefulWidget> createState() => ChargingAnimationWidgetState();
}

class ChargingAnimationWidgetState extends State<ChargingAnimationWidget> {
  int index = 0;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        index = (index + 1) % widget.batteryStates.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.batteryStates[index],
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
