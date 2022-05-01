import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/screens/private_charger_screen.dart';
import 'package:pionixbox/screens/private_charger_screen_demo.dart';
import 'package:pionixbox/screens/private_charging_state_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'Pionix Box',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PrivateChargerScreenDemo(),
    );
  }
}
