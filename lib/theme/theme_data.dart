import 'package:flutter/material.dart';

/// 主题配置
/// 颜色
/// 组件样式

const double contrastLevel = 0;
lightColorScheme() {
  return ColorScheme.fromSeed(
    brightness: Brightness.light,
    contrastLevel: contrastLevel,
    dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    seedColor: const Color(0xFF529DFF),
    primary: const Color(0xFF529DFF),
    secondary: const Color(0xff00A667),
    tertiary: const Color(0xffB6A400),
    error: const Color(0xffFF5449),
    // 背景色
    surface: const Color(0xfff0f0f0),
    onSurface: const Color(0xff000000),
    surfaceDim: const Color(0xffd0d0d0),
    surfaceBright: const Color(0xffFFFFFF),
    surfaceContainerLowest: const Color(0xffe0e0e0),
    surfaceContainerLow: const Color(0xffeeeeee),
    surfaceContainer: const Color(0xfff7f7f7),
    surfaceContainerHigh: const Color(0xfffafafa),
    surfaceContainerHighest: const Color(0xffFFFFFF),
    onSurfaceVariant: const Color(0xff333333),
    inverseSurface: const Color(0xff1a1a1a),
    onInverseSurface: const Color(0xffFFFFFF),
  );
}

darkColorScheme() {
  return ColorScheme.fromSeed(
    brightness: Brightness.dark,
    contrastLevel: contrastLevel,
    dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    seedColor: const Color(0xFF529DFF),
    primary: const Color(0xFF529DFF),
    secondary: const Color(0xff00A667),
    tertiary: const Color(0xffB6A400),
    error: const Color(0xffFF5449),
  );
}

buildThemeData(ColorScheme scheme) {
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    // appBarTheme: AppBarTheme(
    //   backgroundColor: scheme.primary,
    //   foregroundColor: scheme.onPrimary,
    // ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(color: scheme.primary, fontSize: 14);
          }
          return TextStyle(color: scheme.inverseSurface, fontSize: 14);
        },
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      filled: true,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: CircleBorder(),
      elevation: 2,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: scheme.surfaceContainer,
      selectedTileColor: scheme.surfaceContainerHigh,
      selectedColor: scheme.primary,
      dense: true,
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 8,
      activeTrackColor: scheme.primaryContainer,
      inactiveTrackColor: scheme.primaryContainer.withOpacity(0.12),
      thumbColor: scheme.primary,
      // trackShape: const RectangularSliderTrackShape(),
      showValueIndicator: ShowValueIndicator.always,
    ),
  );
}
