import 'package:flutter/material.dart';
import 'package:pionixbox/screens/private_charging_state_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pionix Box',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PrivateChargingStateScreen(title: 'Pionix Box App'),
    );
  }
}


