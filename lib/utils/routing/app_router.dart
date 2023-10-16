import 'package:flutter/material.dart';
import 'package:pionixbox/screens/charging_dashboard_screen.dart';
import 'package:pionixbox/screens/hlc_log.dart';
import 'package:pionixbox/screens/lan_info_screen.dart';
import 'package:pionixbox/screens/landing_screen.dart';
import 'package:pionixbox/screens/language_picker_screen.dart';
import 'package:pionixbox/screens/session_detail.dart';
import 'package:pionixbox/screens/settings_screen.dart';
import 'package:pionixbox/widgets/simulation_panel.dart';
import 'package:pionixbox/screens/system_info.dart';
import 'package:pionixbox/screens/wifi_setup_screen.dart';

class AppRoutes {
  static const languagePickerScreen = '/language_picker_screen';
  static const settingScreen = '/settings_screen';
  static const landingScreen = '/landing_screen';
  static const lanInfoScreen = '/lan_info_screen';
  static const simulationScreen = '/simulation_screen';
  static const wifiSetupScreen = '/wifi_setup_screen';
  static const systemInfo = '/system_info';
  static const sessionDetailScreen = '/session_detail_screen';
  static const hlcLogScreen = '/hlc_log_screen';
  static const chargingDashboardScreen = '/charging_dashboard_screen';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case AppRoutes.settingScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SettingsScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.landingScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const LandingScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.lanInfoScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const LanInfoScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.chargingDashboardScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const ChargingDashboardScreen(),
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
      case AppRoutes.sessionDetailScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SessionDetail(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.hlcLogScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HlcLogScreen(),
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
