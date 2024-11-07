import 'package:flutter/material.dart';

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
