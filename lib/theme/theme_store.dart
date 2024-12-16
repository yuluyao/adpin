import 'package:gy/theme/theme_persistance.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_store.g.dart';

/// 主题状态
@Riverpod(keepAlive: true)
class GyThemeMode extends _$GyThemeMode {
  @override
  ThemeMode build() {
    return ThemeModePersistance.mode;
  }

  applyMode(ThemeMode? mode) async {
    if (mode == null) return;
    ThemeModePersistance.update(mode);
    ref.invalidateSelf(); // 刷新，重新读取
  }
}
