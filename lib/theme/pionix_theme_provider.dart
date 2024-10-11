import 'package:flutter/material.dart';
import 'package:pionixbox/theme/simple_color_scheme.dart';

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
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return scheme.onSurface.withOpacity(backgroundDisabledOpacity);
            }
            return scheme.primary;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return scheme.onSurface.withOpacity(foregroundDisabledOpacity);
            }
            if (states.contains(MaterialState.hovered)) {
              return scheme.onPrimary;
            }
            return scheme.secondary;
          }),
          surfaceTintColor:
              MaterialStateProperty.resolveWith((states) => Colors.transparent),
          elevation: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return 0;
            if (states.contains(MaterialState.pressed)) return 2;
            if (states.contains(MaterialState.hovered)) return 10;
            return 5;
          }),
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return scheme.onSurface.withOpacity(backgroundDisabledOpacity);
            }
            return scheme.secondary;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return scheme.onSurface.withOpacity(foregroundDisabledOpacity);
            }
            return scheme.primary;
          }),
          surfaceTintColor:
              MaterialStateProperty.resolveWith((states) => Colors.transparent),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(
                  width: 1,
                  color:
                      scheme.onSurface.withOpacity(backgroundDisabledOpacity));
            }
            if (states.contains(MaterialState.pressed)) {
              return BorderSide(width: 1, color: scheme.primary);
            }
            if (states.contains(MaterialState.hovered)) {
              return BorderSide(width: 4, color: scheme.primary);
            }
            return BorderSide(width: 2, color: scheme.primary);
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 5,
        backgroundColor: scheme.primary,
        focusElevation: 10,
        foregroundColor: scheme.onPrimary,
      ),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return scheme.onSurface.withOpacity(foregroundDisabledOpacity);
        }
        if (states.contains(MaterialState.selected)) {
          return scheme.onPrimary;
        }
        if (states.contains(MaterialState.hovered)) {
          return scheme.onSurfaceVariant;
        }
        return scheme.primary;
      })),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.resolveWith((states) => true),
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
            MaterialStateProperty.resolveWith((states) => Colors.transparent),
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
