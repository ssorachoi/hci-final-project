import 'package:flutter/material.dart';

@immutable
class AppSizes extends ThemeExtension<AppSizes> {
  const AppSizes({required this.appBarHeight, required this.bottomNavHeight});

  final double appBarHeight;
  final double bottomNavHeight;

  @override
  AppSizes copyWith({double? appBarHeight, double? bottomNavHeight}) {
    return AppSizes(
      appBarHeight: appBarHeight ?? this.appBarHeight,
      bottomNavHeight: bottomNavHeight ?? this.bottomNavHeight,
    );
  }

  @override
  AppSizes lerp(ThemeExtension<AppSizes>? other, double t) {
    if (other is! AppSizes) return this;
    return AppSizes(
      appBarHeight: _lerpDouble(appBarHeight, other.appBarHeight, t),
      bottomNavHeight: _lerpDouble(bottomNavHeight, other.bottomNavHeight, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

ThemeData buildAppTheme() {
  const primary = Color(0xFF395886);
  const surface = Color(0xFFBFC7D1);
  const appSizes = AppSizes(appBarHeight: 66, bottomNavHeight: 72);

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: surface,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      toolbarHeight: appSizes.appBarHeight,
      backgroundColor: primary,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 25,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
    extensions: const [appSizes],
  );
}
