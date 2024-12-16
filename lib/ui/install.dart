import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gy/data/my_store.dart';
import 'package:gy/theme/color_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class Install extends HookConsumerWidget {
  const Install({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = useColorScheme();
    final dragging = useState(false);

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

    final controller = useTextEditingController();
    final downloading = useState(false);
    final downloadProgress = useState(0);
    final installing = useState(false);

    installByPath(String path) async {
      if (path.isEmpty) {
        return;
      }
      if (adbPath.isEmpty || selectedDevice == null) {
        return;
      }
      installing.value = true;
      await Process.run(adbPath, ['-s', selectedDevice.id, 'install', '-r', path]);
      // print(result.stdout);
      // print(result.stderr);
      installing.value = false;
    }

    installByUrl(String url) async {
      if (url.isEmpty || adbPath.isEmpty) return;

      downloading.value = true;
      try {
        // 获取临时目录
        final tempDir = await getTemporaryDirectory();
        final fileName = url.split('/').last;
        final savePath = '${tempDir.path}/$fileName';

        // 下载文件
        final dio = Dio();
        await dio.download(url, savePath, onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = (received / total * 100).toInt();
          }
        });

        // 安装APK
        downloading.value = false;
        installing.value = true;
        await installByPath(savePath);

        // 删除临时文件
        final file = File(savePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('安装失败: $e');
      } finally {
        downloading.value = false;
        installing.value = false;
        downloadProgress.value = 0;
      }
    }

    return DropTarget(
      onDragEntered: (details) => dragging.value = true,
      onDragExited: (details) => dragging.value = false,
      onDragDone: (details) {
        final file = details.files.first;
        if (file.path.toLowerCase().endsWith('.apk')) {
          print('收到 APK 文件路径: ${file.path}');
          installByPath(file.path);
        }
      },
      child: Container(
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          border: Border.all(
            color: dragging.value ? scheme.primary : scheme.outline,
            width: dragging.value ? 2 : 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                '将 APK 文件拖放到这里',
                style: TextStyle(
                  fontSize: 16,
                  color: scheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '安装APK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: '输入 APK 下载链接',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => controller.clear(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => installByUrl(controller.text),
                        child: const Text('安装'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (downloading.value)
              Container(
                color: scheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      value: downloadProgress.value / 100,
                    ),
                    const SizedBox(height: 8),
                    Text('下载中 ${downloadProgress.value}%'),
                  ],
                ),
              )
            else if (installing.value)
              Container(
                color: scheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('安装中...'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
