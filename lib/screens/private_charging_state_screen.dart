import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pionixbox/mqtt.dart';

class PrivateChargingStateScreen extends StatefulWidget {
  const PrivateChargingStateScreen({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<PrivateChargingStateScreen> createState() =>
      _PrivateChargingStateScreenState();
}

class _PrivateChargingStateScreenState
    extends State<PrivateChargingStateScreen> {
  late String _status;
  late String _statusInstruction;
  late String _energy;
  late String _duration;
  late bool _online;
  final mqtt = MQTT();

  void parseSessionInfo(String message) {
    final sessionInfo = jsonDecode(message);
    setState(() {
      _status = sessionInfo["state"];
      final double chargedEnergy = sessionInfo["charged_energy_wh"] / 1000.0;
      _energy = chargedEnergy.toStringAsFixed(1) + " kWh";
      _duration = Duration(seconds: sessionInfo["charging_duration_s"]).toString();
    });
  }

  @override
  void initState() async {
    _status = 'unplugged';
    _energy = '12.3 kWh';
    _online = false;
    _duration = '05:00:01h';
    _statusInstruction = 'Please plug your car';

    await mqtt.connect();

    mqtt.subscribe("everest_api/evse_0/var/session_info", parseSessionInfo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'STATUS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              Text(
                _status.toUpperCase(),
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
              ),
              const SizedBox(height: 12),
              Text(
                _statusInstruction,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),
              const Text(
                'LAST SESSION',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Energy',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      _energy,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Duration',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      _duration,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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
                    decoration: BoxDecoration(
                        color: _online ? Colors.greenAccent : Colors.redAccent,
                        shape: BoxShape.circle),
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Text(
              //       DateTime.now().toIso8601String(),
              //       style: const TextStyle(
              //           fontSize: 16, fontWeight: FontWeight.w500),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
