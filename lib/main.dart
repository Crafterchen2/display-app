import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pionixbox/screens/initializing_screen.dart';
import 'package:pionixbox/utils/routing/app_router.dart';
import 'package:pionixbox/widgets/restart_widget.dart';

late double screenWidth;
late double screenHeight;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  screenWidth = ui.window.physicalSize.width / ui.window.devicePixelRatio;
  screenHeight = ui.window.physicalSize.height / ui.window.devicePixelRatio;
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
    path: 'assets/translations',
    saveLocale: true,
    fallbackLocale: const Locale('en', 'US'),
    child: const RestartWidget(child: ProviderScope(child: MyApp())),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    return MaterialApp(
      title: 'Pionix Box',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
      home: const InitializingScreen(),
    );
  }
}
