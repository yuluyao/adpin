import 'dart:io';

import 'package:gy/theme/theme_data.dart';
import 'package:gy/theme/theme_persistance.dart';
import 'package:gy/theme/theme_store.dart';
import 'package:gy/ui/home.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置窗口大小
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setMinWindowSize(const Size(540, 960));
    await DesktopWindow.setMaxWindowSize(const Size(1080, 1920));
    await DesktopWindow.setWindowSize(const Size(540, 960));
  }

  await ThemeModePersistance.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(gyThemeModeProvider);

    return MaterialApp(
      title: 'adb helper',
      theme: buildThemeData(lightColorScheme()),
      darkTheme: buildThemeData(darkColorScheme()),
      themeMode: mode,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
