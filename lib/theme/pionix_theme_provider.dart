import 'package:flutter/material.dart';

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
    var text = TextTheme(
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
    );
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
      textTheme: text,
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
    onPrimary = Color.lerp(primarySeed,
        whiteForPrimaryLerp ? whiteSeed : blackSeed, onPrimaryLerp)!;
    onSecondary = Color.lerp(secondarySeed,
        whiteForSecondaryLerp ? whiteSeed : blackSeed, onSecondaryLerp)!;
    onTertiary = Color.lerp(tertiarySeed,
        whiteForTertiaryLerp ? whiteSeed : blackSeed, onTertiaryLerp)!;
    onError = Color.lerp(
        errorSeed, whiteForErrorLerp ? whiteSeed : blackSeed, onErrorLerp)!;
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
      onBackground: primarySeed,
      surface: whiteSeed,
      onSurface: primarySeed,
      surfaceVariant: lighterGrey,
      onSurfaceVariant: blackSeed,
      outline: grey,
      outlineVariant: lightGrey,
      shadow: blackSeed,
      scrim: blackSeed,
      inverseSurface: darkGrey,
      onInverseSurface: onPrimary,
      inversePrimary: onPrimary,
      surfaceTint: primarySeed,
    );
  }

  ColorScheme makeDarkScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
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
      background: blackSeed,
      onBackground: onPrimary,
      surface: blackSeed,
      onSurface: onPrimary,
      surfaceVariant: darkGrey,
      onSurfaceVariant: whiteSeed,
      outline: lightGrey,
      outlineVariant: grey,
      shadow: blackSeed,
      scrim: blackSeed,
      inverseSurface: lighterGrey,
      onInverseSurface: primarySeed,
      inversePrimary: primarySeed,
      surfaceTint: onPrimary,
    );
  }
}
