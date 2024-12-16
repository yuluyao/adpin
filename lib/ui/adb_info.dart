import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gy/data/my_store.dart';
import 'package:gy/theme/color_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 分多种情况
///   1. 环境变量中有adb
///   2. adb路径空
///   3. adb路径有效
///   4. adb路径无效
class AdbInfo extends HookConsumerWidget {
  const AdbInfo({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = useColorScheme();

    // 指定adb路径
    final adbPathAsync = ref.watch(adbPathProvider);
    final adbPath = switch (adbPathAsync) {
      AsyncData(:final value) => value,
      _ => '',
    };
    final adbValid = useState(false);

    testCustomPath(String p) {
      if (!p.endsWith('adb')) {
        adbValid.value = false;
        return;
      }
      // print('p: $p');
      final result = Process.runSync(p, ['devices']);
      // print('exitCode: ${result.exitCode}');
      // print('stdout: ${result.stdout}');
      // print('stderr: ${result.stderr}');
      if (result.exitCode == 0) {
        adbValid.value = true;
        return;
      }
      adbValid.value = false;
    }

    useEffect(() {
      testCustomPath(adbPath);
      return null;
    }, [adbPath]);

    buildCondition0() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('adb可用', style: TextStyle(color: scheme.secondary, fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                onPressed: () => ref.invalidate(adbPathProvider),
                child: const Text('刷新'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('路径: $adbPath'),
        ],
      );
    }

    buildCondition1() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('adb不可用', style: TextStyle(color: scheme.error, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('路径：$adbPath'),
        ],
      );
    }

    buildInfo() {
      if (adbValid.value) {
        return buildCondition0();
      } else {
        return buildCondition1();
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: buildInfo(),
    );
  }
}
