import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主题持久化
class ThemeModePersistance {
  static late ThemeMode mode;

  static Future<void> init() async {
    final mode = await _readSp();
    ThemeModePersistance.mode = mode;
    _applySystemUI(mode);
  }

  static Future<void> update(ThemeMode mode) async {
    ThemeModePersistance.mode = mode;
    await _writeSp(mode);
    _applySystemUI(mode);
  }

  static Future<ThemeMode> _readSp() async {
    final sp = await SharedPreferences.getInstance();
    final modeInt = sp.getInt("gyThemeMode");
    if (modeInt == null) {
      // 默认跟随系统
      _writeSp(ThemeMode.system);
    }
    return switch (modeInt) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      3 => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }

  static Future<void> _writeSp(ThemeMode mode) async {
    final modeInt = switch (mode) {
      ThemeMode.light => 1,
      ThemeMode.dark => 2,
      ThemeMode.system => 3,
    };
    final sp = await SharedPreferences.getInstance();
    await sp.setInt("gyThemeMode", modeInt);
  }

  /// 应用主题配置时，修改系统UI
  static Future<void> _applySystemUI(ThemeMode mode) async {
    // 状态栏与导航栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (mode == ThemeMode.light) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
    }
  }
}
