import 'package:flutter/material.dart';
import 'package:display_app/theme/simple_color_scheme.dart';

class PionixThemeProvider {
  SimpleColorScheme? schemeSrc;

  late ColorScheme customLightScheme = schemeSrc!.lightScheme;

  late ColorScheme customDarkScheme = schemeSrc!.darkScheme;

  PionixThemeProvider({
    this.schemeSrc,
  }) {
    schemeSrc ??= SimpleColorScheme(
      primarySeed: const Color(0xFF092551),
      secondarySeed: const Color(0xffffac02),
      tertiarySeed: const Color(0xff00531f),
      whiteSeed: const Color(0xFFFFFFFF),
      blackSeed: const Color(0xff262626),
    );
  }

  ThemeData getTheme({
    required Brightness brightness,
    ColorScheme? colorScheme,
  }) {
    bool isLight = brightness == Brightness.light;
    ColorScheme scheme =
        colorScheme ?? ((isLight) ? customLightScheme : customDarkScheme);

    const double backgroundDisabledOpacity = 0.12;
    const double foregroundDisabledOpacity = 0.38;
    const OutlinedBorder buttonShape = ContinuousRectangleBorder();
    const TextStyle urbanistFont = TextStyle(
      fontFamily: 'Urbanist',
      textBaseline: TextBaseline.alphabetic,
      fontStyle: FontStyle.normal,
    );
    const TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );
    TextStyle primaryTextColor = TextStyle(color: scheme.primary);
    return ThemeData(
      colorScheme: scheme,
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.onSurface
                  .withValues(alpha: backgroundDisabledOpacity);
            }
            return scheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.onSurface
                  .withValues(alpha: foregroundDisabledOpacity);
            }
            if (states.contains(WidgetState.hovered)) {
              return scheme.onPrimary;
            }
            return scheme.secondary;
          }),
          surfaceTintColor:
              WidgetStateProperty.resolveWith((states) => Colors.transparent),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return 0;
            if (states.contains(WidgetState.pressed)) return 2;
            if (states.contains(WidgetState.hovered)) return 10;
            return 5;
          }),
          shape: WidgetStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith((states) => buttonShape),
          elevation: WidgetStateProperty.resolveWith((states) => 0),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.onSurface
                  .withValues(alpha: backgroundDisabledOpacity);
            }
            return scheme.secondary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return scheme.onSurface
                  .withValues(alpha: foregroundDisabledOpacity);
            }
            return scheme.primary;
          }),
          surfaceTintColor:
              WidgetStateProperty.resolveWith((states) => Colors.transparent),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith((states) => buttonShape),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                  width: 1,
                  color: scheme.onSurface
                      .withValues(alpha: backgroundDisabledOpacity));
            }
            if (states.contains(WidgetState.pressed)) {
              return BorderSide(width: 1, color: scheme.primary);
            }
            if (states.contains(WidgetState.hovered)) {
              return BorderSide(width: 4, color: scheme.primary);
            }
            return BorderSide(width: 2, color: scheme.primary);
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 5,
        backgroundColor: scheme.primary,
        focusElevation: 10,
        foregroundColor: scheme.onPrimary,
      ),
      switchTheme:
          SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withValues(alpha: foregroundDisabledOpacity);
        }
        if (states.contains(WidgetState.selected)) {
          return scheme.onPrimary;
        }
        if (states.contains(WidgetState.hovered)) {
          return scheme.onSurfaceVariant;
        }
        return scheme.primary;
      })),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.resolveWith((states) => true),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: scheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: scheme.secondaryContainer,
        elevation: 20,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.primaryContainer,
        endIndent: 10,
        indent: 10,
        space: 6,
        thickness: 2,
      ),
      tabBarTheme: TabBarTheme(
        overlayColor:
            WidgetStateProperty.resolveWith((states) => Colors.transparent),
        labelColor: scheme.onPrimary,
        unselectedLabelColor: scheme.primaryContainer,
        indicatorColor: scheme.secondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        elevation: 20,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 70,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.secondary,
        actionBackgroundColor: scheme.primary,
        actionTextColor: scheme.onPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: bold.copyWith(
          color: scheme.secondary,
          height: 1.3,
          fontSize: 32,
        ),
        displayMedium: primaryTextColor.copyWith(
          height: 1.3,
          fontWeight: FontWeight.w500,
        ),
        displaySmall: primaryTextColor,
        headlineLarge: primaryTextColor.merge(bold),
        headlineMedium: primaryTextColor.copyWith(fontWeight: FontWeight.w500),
        headlineSmall: primaryTextColor,
        titleLarge: urbanistFont.merge(primaryTextColor),
        titleMedium: urbanistFont.merge(primaryTextColor),
        titleSmall: urbanistFont.merge(primaryTextColor),
        labelLarge: primaryTextColor,
        labelMedium: primaryTextColor,
        labelSmall: primaryTextColor,
        bodyLarge: primaryTextColor,
        bodyMedium: primaryTextColor,
        bodySmall: primaryTextColor,
      ),
      useMaterial3: true,
    );
  }

  ThemeData getLightTheme() {
    return getTheme(brightness: Brightness.light);
  }

  ThemeData getDarkTheme() {
    return getTheme(brightness: Brightness.dark);
  }
}
