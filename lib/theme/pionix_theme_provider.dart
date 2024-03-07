import 'package:flutter/material.dart';

class PionixThemeProvider {
  SimpleColorScheme? schemeSrc;

  late ColorScheme customLightScheme = schemeSrc!.lightScheme;

  late ColorScheme customDarkScheme = schemeSrc!.darkScheme;

  PionixThemeProvider({
    this.schemeSrc,
  }){
    schemeSrc ??= SimpleColorScheme(
      primarySeed: const Color(0xFF092551),
      secondarySeed: const Color(0xffffac02),
      tertiarySeed: const Color(0xff00531f),
      whiteSeed: const Color(0xffffffff),
      blackSeed: const Color(0xff1a1a1a),
    );
  }

  ThemeData getLightTheme() {
    const double backgroundDisabledOpacity = 0.12;
    const double foregroundDisabledOpacity = 0.38;
    const OutlinedBorder buttonShape = ContinuousRectangleBorder();
    return ThemeData(
      colorScheme: customLightScheme,
      sliderTheme: SliderThemeData(
        activeTrackColor: customLightScheme.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return customLightScheme.onSurface.withOpacity(backgroundDisabledOpacity);
            return customLightScheme.secondary;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return customLightScheme.onSurface.withOpacity(foregroundDisabledOpacity);
            if (states.contains(MaterialState.hovered)) return customLightScheme.onSecondary;
            return customLightScheme.primary;
          }),
          surfaceTintColor: MaterialStateProperty.resolveWith((states) {
            return Colors.transparent;
          }),
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
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return BorderSide(width: 1, color: customLightScheme.onSurface.withOpacity(backgroundDisabledOpacity));
            if (states.contains(MaterialState.pressed)) return BorderSide(width: 1, color: customLightScheme.primary);
            if (states.contains(MaterialState.hovered)) return BorderSide(width: 4, color: customLightScheme.primary);
            return BorderSide(width: 2, color: customLightScheme.primary);
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
        backgroundColor: customLightScheme.primary,
        focusElevation: 10,
        foregroundColor: customLightScheme.onPrimary,
      ),
      switchTheme: SwitchThemeData(thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) return customLightScheme.onSurface.withOpacity(foregroundDisabledOpacity);
        if (states.contains(MaterialState.selected)) return customLightScheme.onPrimary;
        if (states.contains(MaterialState.hovered)) return customLightScheme.onSurfaceVariant;
        return customLightScheme.primary;
      })),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.resolveWith((states) {
          return true;
        }),
      ),
      useMaterial3: true,
    );
  }

  ThemeData getDarkTheme() {
    const double backgroundDisabledOpacity = 0.12;
    const double foregroundDisabledOpacity = 0.38;
    const OutlinedBorder buttonShape = ContinuousRectangleBorder();
    return ThemeData(
      colorScheme: customDarkScheme,
      sliderTheme: SliderThemeData(
        activeTrackColor: customDarkScheme.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return customDarkScheme.onSurface.withOpacity(backgroundDisabledOpacity);
            return customDarkScheme.secondary;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return customDarkScheme.onSurface.withOpacity(foregroundDisabledOpacity);
            return customDarkScheme.onSecondary;
          }),
          surfaceTintColor: MaterialStateProperty.resolveWith((states) {
            return Colors.transparent;
          }),
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
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 5,
        backgroundColor: customDarkScheme.primary,
        focusElevation: 10,
        foregroundColor: customDarkScheme.onPrimary,
      ),
      switchTheme: SwitchThemeData(thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) return customDarkScheme.onSurface.withOpacity(foregroundDisabledOpacity);
        if (states.contains(MaterialState.selected)) return customDarkScheme.onPrimary;
        if (states.contains(MaterialState.hovered)) return customDarkScheme.onSurfaceVariant;
        return customDarkScheme.primary;
      })),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.resolveWith((states) {
          return true;
        }),
      ),
      useMaterial3: true,
    );
  }
}

class SimpleColorScheme {
  final Color primarySeed;
  final Color secondarySeed;
  final Color tertiarySeed;
  final Color whiteSeed;
  final Color blackSeed;
  final Color errorSeed;
  final double lighterGreyLerp;
  final double lightGreyLerp;
  final double greyLerp;
  final double darkGreyLerp;
  final double onPrimaryLerp;
  final double onSecondaryLerp;
  final double onTertiaryLerp;
  final double onErrorLerp;
  final bool whiteForPrimaryLerp;
  final bool whiteForSecondaryLerp;
  final bool whiteForTertiaryLerp;
  final bool whiteForErrorLerp;

  late final ColorScheme lightScheme;
  late final ColorScheme darkScheme;
  late final Color lighterGrey;
  late final Color lightGrey;
  late final Color grey;
  late final Color darkGrey;
  late final Color onPrimary;
  late final Color onSecondary;
  late final Color onTertiary;
  late final Color onError;

  SimpleColorScheme({
    required this.primarySeed,
    required this.secondarySeed,
    required this.tertiarySeed,
    required this.whiteSeed,
    required this.blackSeed,
    this.errorSeed = const Color(0xffba1a1a),
    this.lighterGreyLerp = 0.1,
    this.lightGreyLerp = 0.25,
    this.greyLerp = 0.5,
    this.darkGreyLerp = 0.6,
    this.onPrimaryLerp = 0.6,
    this.onSecondaryLerp = 0.6,
    this.onTertiaryLerp = 0.6,
    this.onErrorLerp = 0.6,
    this.whiteForPrimaryLerp = true,
    this.whiteForSecondaryLerp = true,
    this.whiteForTertiaryLerp = true,
    this.whiteForErrorLerp = true,
  }) {
    lighterGrey = Color.lerp(whiteSeed, blackSeed, lighterGreyLerp)!;
    lightGrey = Color.lerp(whiteSeed, blackSeed, lightGreyLerp)!;
    grey = Color.lerp(whiteSeed, blackSeed, greyLerp)!;
    darkGrey = Color.lerp(whiteSeed, blackSeed, darkGreyLerp)!;
    onPrimary = Color.lerp(primarySeed, whiteForPrimaryLerp ? whiteSeed : blackSeed, onPrimaryLerp)!;
    onSecondary = Color.lerp(secondarySeed, whiteForSecondaryLerp ? whiteSeed : blackSeed, onSecondaryLerp)!;
    onTertiary = Color.lerp(tertiarySeed, whiteForTertiaryLerp ? whiteSeed : blackSeed, onTertiaryLerp)!;
    onError = Color.lerp(errorSeed, whiteForErrorLerp ? whiteSeed : blackSeed, onErrorLerp)!;
    lightScheme = makeLightScheme();
    darkScheme = makeDarkScheme();
  }

  ColorScheme makeLightScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: primarySeed,
      onPrimary: whiteSeed,
      primaryContainer: onPrimary,
      onPrimaryContainer: blackSeed,
      secondary: secondarySeed,
      onSecondary: whiteSeed,
      secondaryContainer: onSecondary,
      onSecondaryContainer: blackSeed,
      tertiary: tertiarySeed,
      onTertiary: whiteSeed,
      tertiaryContainer: onTertiary,
      onTertiaryContainer: blackSeed,
      error: errorSeed,
      onError: whiteSeed,
      errorContainer: onError,
      onErrorContainer: blackSeed,
      background: whiteSeed,
      onBackground: blackSeed,
      surface: whiteSeed,
      onSurface: blackSeed,
      surfaceVariant: lighterGrey,
      onSurfaceVariant: blackSeed,
      outline: grey,
      outlineVariant: lightGrey,
      shadow: blackSeed,
      scrim: blackSeed,
      inverseSurface: darkGrey,
      onInverseSurface: whiteSeed,
      inversePrimary: onPrimary,
      surfaceTint: primarySeed,
    );
  }

  ColorScheme makeDarkScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: onPrimary,
      onPrimary: blackSeed,
      primaryContainer: primarySeed,
      onPrimaryContainer: whiteSeed,
      secondary: onSecondary,
      onSecondary: blackSeed,
      secondaryContainer: secondarySeed,
      onSecondaryContainer: whiteSeed,
      tertiary: onTertiary,
      onTertiary: blackSeed,
      tertiaryContainer: tertiarySeed,
      onTertiaryContainer: whiteSeed,
      error: onError,
      onError: blackSeed,
      errorContainer: errorSeed,
      onErrorContainer: whiteSeed,
      background: blackSeed,
      onBackground: whiteSeed,
      surface: blackSeed,
      onSurface: whiteSeed,
      surfaceVariant: darkGrey,
      onSurfaceVariant: whiteSeed,
      outline: lightGrey,
      outlineVariant: grey,
      shadow: blackSeed,
      scrim: blackSeed,
      inverseSurface: lighterGrey,
      onInverseSurface: blackSeed,
      inversePrimary: primarySeed,
      surfaceTint: onPrimary,
    );
  }
}
