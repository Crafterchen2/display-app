import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/routing/app_router.dart';
import 'package:pionixbox/screens/private_charger_screen_demo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'Pionix Box',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings),
      home: const PrivateChargerScreenDemo(),
    );
  }
}
