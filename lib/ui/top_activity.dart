import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gy/data/my_store.dart';
import 'package:gy/theme/color_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TopActivityInfo extends HookConsumerWidget {
  const TopActivityInfo({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = useColorScheme();

    final adbPathAsync = ref.watch(adbPathProvider);
    final adbPath = switch (adbPathAsync) {
      AsyncData(:final value) => value,
      _ => '',
    };
    final selectedDeviceAsync = ref.watch(selectedDeviceProvider);
    final selectedDevice = switch (selectedDeviceAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };

    final info = useState('');

    refreshTopActivity() {
      if (adbPath.isEmpty || selectedDevice == null) {
        return;
      }
      final result = Process.runSync(adbPath, ['-s', selectedDevice.id, 'shell', 'dumpsys', 'window', '|', 'grep', 'mFocused']);
      if (result.exitCode == 0) {
        info.value = result.stdout.toString().split('\n').first;
      } else {
        info.value = '获取栈顶 Activity 失败';
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('栈顶 Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                onPressed: refreshTopActivity,
                child: const Text('刷新'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              // border: Border.all(color: scheme.outline),
              // borderRadius: BorderRadius.circular(4),
            ),
            child: Text(info.value),
          ),
        ],
      ),
    );
  }
}
