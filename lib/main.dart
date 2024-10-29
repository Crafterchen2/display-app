import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:display_app/screens/initializing_screen.dart';
import 'package:display_app/theme/pionix_theme_provider.dart';
import 'package:display_app/utils/routing/app_router.dart';
import 'package:display_app/widgets/restart_widget.dart';
import 'package:auto_orientation/auto_orientation.dart';

/// [uiScale] should be used to determine any kind of manual size adjustment of
/// a widget or font or similar. It's not recommended to make f.e. a widget
/// dependant on the size of the screen / window, as weird UI movements will
/// occur which should be avoided to achieve a good and clean user experience.
/// Example:
/// SizedBox(
///   width = adjustScale(1000),
///   height = adjustScale(250),
/// );
///
/// see also: [adjustScale]
double uiScale = 1.0;

///Convenience method.
///Multiplies parameter number with variable [uiScale] and returns the product.
double adjustScale(double number) {
  return number * uiScale;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
    path: 'assets/translations',
    saveLocale: true,
    fallbackLocale: const Locale('en', 'US'),
    child: const RestartWidget(child: ProviderScope(child: MyApp())),
  ));
}

ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    AutoOrientation.fullAutoMode();

    PionixThemeProvider themeProvider = PionixThemeProvider();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, brightnessValue, child) {
        return MaterialApp(
          title: 'Pionix Box',
          debugShowCheckedModeBanner: false,
          themeMode: brightnessValue,
          theme: themeProvider.getLightTheme(),
          darkTheme: themeProvider.getDarkTheme(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
          home: const InitializingScreen(),
        );
      },
    );
  }
}
