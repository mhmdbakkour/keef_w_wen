import "package:flutter/material.dart";

class AppTheme {
  final TextTheme textTheme;

  const AppTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffa90016),
      surfaceTint: Color(0xffc0001a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd31624),
      onPrimaryContainer: Color(0xffffe7e4),
      secondary: Color(0xff974400),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbd5600),
      onSecondaryContainer: Color(0xfffffbff),
      tertiary: Color(0xffaa0068),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd31683),
      onTertiaryContainer: Color(0xfffff1f4),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff281716),
      onSurfaceVariant: Color(0xff5d3f3d),
      outline: Color(0xff916f6c),
      outlineVariant: Color(0xffe6bdb9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3f2b2a),
      inversePrimary: Color(0xffffb3ad),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff410003),
      primaryFixedDim: Color(0xffffb3ad),
      onPrimaryFixedVariant: Color(0xff930011),
      secondaryFixed: Color(0xffffdbc9),
      onSecondaryFixed: Color(0xff331200),
      secondaryFixedDim: Color(0xffffb68d),
      onSecondaryFixedVariant: Color(0xff763300),
      tertiaryFixed: Color(0xffffd9e5),
      onTertiaryFixed: Color(0xff3e0022),
      tertiaryFixedDim: Color(0xffffb0ce),
      onTertiaryFixedVariant: Color(0xff8c0054),
      surfaceDim: Color(0xfff3d3cf),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ef),
      surfaceContainer: Color(0xffffe9e7),
      surfaceContainerHigh: Color(0xffffe2df),
      surfaceContainerHighest: Color(0xfffcdbd8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff73000b),
      surfaceTint: Color(0xffc0001a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd31624),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff5c2600),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffb25100),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff6e0041),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffcf1080),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff1d0d0c),
      onSurfaceVariant: Color(0xff4a2f2d),
      outline: Color(0xff694b48),
      outlineVariant: Color(0xff866562),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3f2b2a),
      inversePrimary: Color(0xffffb3ad),
      primaryFixed: Color(0xffd71a26),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xffae0017),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffb25100),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff8c3e00),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffcf1080),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xffa60065),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdfbfbc),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ef),
      surfaceContainer: Color(0xffffe2df),
      surfaceContainerHigh: Color(0xfff6d5d2),
      surfaceContainerHighest: Color(0xffeacac7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff600008),
      surfaceTint: Color(0xffc0001a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff970012),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4c1f00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7a3500),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5c0035),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff910057),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff3f2523),
      outlineVariant: Color(0xff5f423f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3f2b2a),
      inversePrimary: Color(0xffffb3ad),
      primaryFixed: Color(0xff970012),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6d000a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7a3500),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff572400),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff910057),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff68003d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd0b2af),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffedeb),
      surfaceContainer: Color(0xfffcdbd8),
      surfaceContainerHigh: Color(0xffedcdca),
      surfaceContainerHighest: Color(0xffdfbfbc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb3ad),
      surfaceTint: Color(0xffffb3ad),
      onPrimary: Color(0xff680009),
      primaryContainer: Color(0xffd31624),
      onPrimaryContainer: Color(0xffffe7e4),
      secondary: Color(0xffffb68d),
      onSecondary: Color(0xff532200),
      secondaryContainer: Color(0xffe27122),
      onSecondaryContainer: Color(0xff361300),
      tertiary: Color(0xffffb0ce),
      onTertiary: Color(0xff63003a),
      tertiaryContainer: Color(0xffd31683),
      onTertiaryContainer: Color(0xfffff1f4),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1f0f0e),
      onSurface: Color(0xfffcdbd8),
      onSurfaceVariant: Color(0xffe6bdb9),
      outline: Color(0xffad8885),
      outlineVariant: Color(0xff5d3f3d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffcdbd8),
      inversePrimary: Color(0xffc0001a),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff410003),
      primaryFixedDim: Color(0xffffb3ad),
      onPrimaryFixedVariant: Color(0xff930011),
      secondaryFixed: Color(0xffffdbc9),
      onSecondaryFixed: Color(0xff331200),
      secondaryFixedDim: Color(0xffffb68d),
      onSecondaryFixedVariant: Color(0xff763300),
      tertiaryFixed: Color(0xffffd9e5),
      onTertiaryFixed: Color(0xff3e0022),
      tertiaryFixedDim: Color(0xffffb0ce),
      onTertiaryFixedVariant: Color(0xff8c0054),
      surfaceDim: Color(0xff1f0f0e),
      surfaceBright: Color(0xff493432),
      surfaceContainerLowest: Color(0xff190a09),
      surfaceContainerLow: Color(0xff281716),
      surfaceContainer: Color(0xff2d1b19),
      surfaceContainerHigh: Color(0xff382523),
      surfaceContainerHighest: Color(0xff44302e),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd2ce),
      surfaceTint: Color(0xffffb3ad),
      onPrimary: Color(0xff540006),
      primaryContainer: Color(0xffff544f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd3bd),
      onSecondary: Color(0xff421a00),
      secondaryContainer: Color(0xffe27122),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd0e0),
      onTertiary: Color(0xff50002e),
      tertiaryContainer: Color(0xffff44a5),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1f0f0e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffdd2ce),
      outline: Color(0xffd0a9a5),
      outlineVariant: Color(0xffac8884),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffcdbd8),
      inversePrimary: Color(0xff950012),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff2d0002),
      primaryFixedDim: Color(0xffffb3ad),
      onPrimaryFixedVariant: Color(0xff73000b),
      secondaryFixed: Color(0xffffdbc9),
      onSecondaryFixed: Color(0xff220a00),
      secondaryFixedDim: Color(0xffffb68d),
      onSecondaryFixedVariant: Color(0xff5c2600),
      tertiaryFixed: Color(0xffffd9e5),
      onTertiaryFixed: Color(0xff2b0016),
      tertiaryFixedDim: Color(0xffffb0ce),
      onTertiaryFixedVariant: Color(0xff6e0041),
      surfaceDim: Color(0xff1f0f0e),
      surfaceBright: Color(0xff553f3d),
      surfaceContainerLowest: Color(0xff110404),
      surfaceContainerLow: Color(0xff2b1917),
      surfaceContainer: Color(0xff362321),
      surfaceContainerHigh: Color(0xff422e2c),
      surfaceContainerHighest: Color(0xff4e3836),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffecea),
      surfaceTint: Color(0xffffb3ad),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffaea7),
      onPrimaryContainer: Color(0xff220001),
      secondary: Color(0xffffece4),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffb184),
      onSecondaryContainer: Color(0xff190600),
      tertiary: Color(0xffffebf0),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffaacb),
      onTertiaryContainer: Color(0xff20000f),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1f0f0e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffecea),
      outlineVariant: Color(0xffe2b9b5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffcdbd8),
      inversePrimary: Color(0xff950012),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb3ad),
      onPrimaryFixedVariant: Color(0xff2d0002),
      secondaryFixed: Color(0xffffdbc9),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb68d),
      onSecondaryFixedVariant: Color(0xff220a00),
      tertiaryFixed: Color(0xffffd9e5),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb0ce),
      onTertiaryFixedVariant: Color(0xff2b0016),
      surfaceDim: Color(0xff1f0f0e),
      surfaceBright: Color(0xff624b48),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff2d1b19),
      surfaceContainer: Color(0xff3f2b2a),
      surfaceContainerHigh: Color(0xff4b3634),
      surfaceContainerHighest: Color(0xff58413f),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
