import 'package:flutter/material.dart';
import 'package:pionixbox/screens/language_picker_screen.dart';
import 'package:pionixbox/screens/settings_screen.dart';
import 'package:pionixbox/screens/simulation_panel.dart';
import 'package:pionixbox/screens/system_info.dart';
import 'package:pionixbox/screens/wifi_setup_screen.dart';

class AppRoutes {
  static const languagePickerScreen = '/language_picker_screen';
  static const settingScreen = '/settings_screen';
  static const simulationScreen = '/simulation_screen';
  static const wifiSetupScreen = '/wifi_setup_screen';
  static const systemInfo = '/system_info';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings,
  ) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.settingScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SettingsScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.simulationScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SimulationPanel(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.languagePickerScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const LanguagePickerScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.wifiSetupScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const WifiSetupScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.systemInfo:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SystemInfo(),
          settings: settings,
          fullscreenDialog: true,
        );
      // case AppRoutes.entryPage:
      //   final mapArgs = args as Map<String, dynamic>;
      //   final job = mapArgs['job'] as Job;
      //   final entry = mapArgs['entry'] as Entry?;
      //   return MaterialPageRoute<dynamic>(
      //     builder: (_) => EntryPage(job: job, entry: entry),
      //     settings: settings,
      //     fullscreenDialog: true,
      //   );
      default:
        // TODO: Throw
        return null;
    }
  }
}
