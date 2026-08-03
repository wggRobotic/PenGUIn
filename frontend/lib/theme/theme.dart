import "package:flutter/material.dart";

class PenGUInTheme {
  final TextTheme textTheme;

  const PenGUInTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8b4f24),
      surfaceTint: Color(0xff8b4f24),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdcc7),
      onPrimaryContainer: Color(0xff6e390e),
      secondary: Color(0xff755846),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdcc7),
      onSecondaryContainer: Color(0xff5b4130),
      tertiary: Color(0xff606134),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffe6e6ad),
      onTertiaryContainer: Color(0xff48491f),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color.fromARGB(255, 255, 73, 53),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff221a15),
      onSurfaceVariant: Color(0xff52443c),
      outline: Color(0xff84746a),
      outlineVariant: Color(0xffd7c3b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb787),
      primaryFixed: Color(0xffffdcc7),
      onPrimaryFixed: Color(0xff311300),
      primaryFixedDim: Color(0xffffb787),
      onPrimaryFixedVariant: Color(0xff6e390e),
      secondaryFixed: Color(0xffffdcc7),
      onSecondaryFixed: Color(0xff2b1708),
      secondaryFixedDim: Color(0xffe5bfa8),
      onSecondaryFixedVariant: Color(0xff5b4130),
      tertiaryFixed: Color(0xffe6e6ad),
      onTertiaryFixed: Color(0xff1c1d00),
      tertiaryFixedDim: Color(0xffcaca93),
      onTertiaryFixedVariant: Color(0xff48491f),
      surfaceDim: Color(0xffe7d7ce),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ea),
      surfaceContainer: Color(0xfffcebe2),
      surfaceContainerHigh: Color(0xfff6e5dc),
      surfaceContainerHighest: Color(0xfff0dfd7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4a2100),
      surfaceTint: Color(0xff8b4f24),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff713b10),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3e2717),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5e4332),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2d2e06),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4a4b21),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff362a22),
      outlineVariant: Color(0xff54463e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb787),
      primaryFixed: Color(0xff713b10),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff542600),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5e4332),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff452d1d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4a4b21),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff34350c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5b6ae),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffede5),
      surfaceContainer: Color(0xfff0dfd7),
      surfaceContainerHigh: Color(0xffe1d1c9),
      surfaceContainerHighest: Color(0xffd3c3bb),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb787),
      surfaceTint: Color(0xffffb787),
      onPrimary: Color(0xff502400),
      primaryContainer: Color(0xff6e390e),
      onPrimaryContainer: Color(0xffffdcc7),
      secondary: Color(0xffe5bfa8),
      onSecondary: Color(0xff422b1b),
      secondaryContainer: Color(0xff5b4130),
      onSecondaryContainer: Color(0xffffdcc7),
      tertiary: Color(0xffcaca93),
      onTertiary: Color(0xff31320a),
      tertiaryContainer: Color(0xff48491f),
      onTertiaryContainer: Color(0xffe6e6ad),
      error: Color.fromARGB(255, 255, 124, 110),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff19120d),
      onSurface: Color(0xfff0dfd7),
      onSurfaceVariant: Color(0xffd7c3b8),
      outline: Color(0xff9f8d83),
      outlineVariant: Color(0xff52443c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff8b4f24),
      primaryFixed: Color(0xffffdcc7),
      onPrimaryFixed: Color(0xff311300),
      primaryFixedDim: Color(0xffffb787),
      onPrimaryFixedVariant: Color(0xff6e390e),
      secondaryFixed: Color(0xffffdcc7),
      onSecondaryFixed: Color(0xff2b1708),
      secondaryFixedDim: Color(0xffe5bfa8),
      onSecondaryFixedVariant: Color(0xff5b4130),
      tertiaryFixed: Color(0xffe6e6ad),
      onTertiaryFixed: Color(0xff1c1d00),
      tertiaryFixedDim: Color(0xffcaca93),
      onTertiaryFixedVariant: Color(0xff48491f),
      surfaceDim: Color(0xff19120d),
      surfaceBright: Color(0xff413731),
      surfaceContainerLowest: Color(0xff140d08),
      surfaceContainerLow: Color(0xff221a15),
      surfaceContainer: Color(0xff261e19),
      surfaceContainerHigh: Color(0xff312823),
      surfaceContainerHighest: Color(0xff3d332d),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffece3),
      surfaceTint: Color(0xffffb787),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb17d),
      onPrimaryContainer: Color(0xff180700),
      secondary: Color(0xffffece3),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe1bba5),
      onSecondaryContainer: Color(0xff170700),
      tertiary: Color(0xfff4f3ba),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffc6c690),
      onTertiaryContainer: Color(0xff0c0c00),
      error: Color.fromARGB(255, 152, 61, 47),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff19120d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffece3),
      outlineVariant: Color(0xffd3bfb4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff6f3a0f),
      primaryFixed: Color(0xffffdcc7),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb787),
      onPrimaryFixedVariant: Color(0xff210b00),
      secondaryFixed: Color(0xffffdcc7),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe5bfa8),
      onSecondaryFixedVariant: Color(0xff1f0c02),
      tertiaryFixed: Color(0xffe6e6ad),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcaca93),
      onTertiaryFixedVariant: Color(0xff121200),
      surfaceDim: Color(0xff19120d),
      surfaceBright: Color(0xff594e47),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff261e19),
      surfaceContainer: Color(0xff382e29),
      surfaceContainerHigh: Color(0xff433933),
      surfaceContainerHighest: Color(0xff4f453e),
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


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.dark,
    required this.darkHighContrast,
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
