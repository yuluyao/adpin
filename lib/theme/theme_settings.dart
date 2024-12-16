import 'package:gy/theme/color_hooks.dart';
import 'package:gy/theme/theme_store.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 主题设置页
class ThemeSettingsPage extends HookConsumerWidget {
  const ThemeSettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    buildTile(String title, ThemeMode value) {
      final selectedMode = ref.watch(gyThemeModeProvider);
      final checked = selectedMode == value;
      return ListTile(
        onTap: () => ref.read(gyThemeModeProvider.notifier).applyMode(value),
        selected: checked,
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: checked ? const Icon(Icons.check) : null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('主题'),
      ),
      body: Column(
        children: [
          const Divider(height: 8, color: Colors.transparent),
          buildTile('浅色', ThemeMode.light),
          const Divider(thickness: 0.5, height: 0.5),
          buildTile('深色', ThemeMode.dark),
          const Divider(thickness: 0.5, height: 0.5),
          buildTile('跟随系统', ThemeMode.system),
        ],
      ),
    );
  }
}

class ThemeSettingsTile extends HookConsumerWidget {
  const ThemeSettingsTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = useColorScheme();
    final options = [
      {
        'title': '浅色',
        'value': ThemeMode.light,
      },
      {
        'title': '深色',
        'value': ThemeMode.dark,
      },
      {
        'title': '跟随系统',
        'value': ThemeMode.system,
      },
    ];
    return ListTile(
      title: Text('主题'),
      trailing: DropdownButton(
        items: options
            .map((e) => DropdownMenuItem(
                value: e['value'] as ThemeMode,
                child: Text(
                  e['title'] as String,
                  style: TextStyle(fontSize: 13, color: scheme.onSurface),
                )))
            .toList(),
        selectedItemBuilder: (context) {
          return options
              .map((e) => Container(
                    alignment: Alignment.center,
                    child: Text(
                      e['title'] as String,
                      style: TextStyle(fontSize: 13, color: scheme.onSurface),
                    ),
                  ))
              .toList();
        },
        value: ref.watch(gyThemeModeProvider),
        onChanged: (ThemeMode? mode) => ref.read(gyThemeModeProvider.notifier).applyMode(mode),
      ),
    );
  }
}
