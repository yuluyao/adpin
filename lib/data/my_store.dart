import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gy/data/entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_store.g.dart';

@Riverpod(keepAlive: true)
class AdbPath extends _$AdbPath {
  @override
  Future<String> build() async {
    // 优先使用系统 ADB
    final systemAdb = await _findSystemAdb();
    if (systemAdb != null) {
      return systemAdb;
    }

    // 找不到系统 ADB 时才使用内置的
    return _getBuiltinAdb();
  }

  Future<String?> _findSystemAdb() async {
    try {
      final result = Platform.isWindows ? await Process.run('where', ['adb']) : await Process.run('which', ['adb']);

      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (e) {
      // 忽略错误
    }
    return null;
  }

  Future<String> _getBuiltinAdb() async {
    final tempDir = await getTemporaryDirectory();
    final adbDir = Directory('${tempDir.path}/adb');
    if (!adbDir.existsSync()) {
      adbDir.createSync();
    }

    String platform = '';
    if (Platform.isWindows) {
      platform = 'windows/adb.exe';
    } else if (Platform.isMacOS) {
      platform = 'macos/adb';
    } else if (Platform.isLinux) {
      platform = 'linux/adb';
    }

    final adbPath = '${adbDir.path}/adb${Platform.isWindows ? '.exe' : ''}';
    final adbFile = File(adbPath);

    if (!adbFile.existsSync()) {
      final data = await rootBundle.load('assets/bin/$platform');
      await adbFile.writeAsBytes(data.buffer.asUint8List());
      // 设置执行权限
      if (!Platform.isWindows) {
        await Process.run('chmod', ['+x', adbPath]);
      }
    }

    return adbPath;
  }
}

@Riverpod(keepAlive: true)
class SelectedDeviceIndex extends _$SelectedDeviceIndex {
  @override
  int build() {
    return -1;
  }

  refreshIndex(int index) {
    state = index;
  }
}

@Riverpod(keepAlive: true)
Future<Device?> selectedDevice(Ref ref) async {
  final devices = await ref.watch(devicesProvider.future);
  final index = ref.watch(selectedDeviceIndexProvider);
  if (index == -1 || index >= devices.length) {
    return null;
  }
  return devices[index];
}

@Riverpod(keepAlive: true)
class Devices extends _$Devices {
  @override
  FutureOr<List<Device>> build() async {
    var devices = <Device>[];
    final adbPath = await ref.watch(adbPathProvider.future);
    if (adbPath.isEmpty) {
      devices = <Device>[];
      ref.read(selectedDeviceIndexProvider.notifier).refreshIndex(-1);
      return devices;
    }
    final result = Process.runSync(adbPath, ['devices']);
    if (result.exitCode == 0) {
      final content = result.stdout.toString().trim().split('\n');
      content.removeAt(0);
      devices = content.map((e) {
        final parts = e.split('\t');
        final id = parts[0];
        final state = DeviceState.fromString(parts[1]);
        return Device(id, state);
      }).toList();
      ref.read(selectedDeviceIndexProvider.notifier).refreshIndex(
            devices.indexOf(devices.firstWhere((e) => e.state == DeviceState.device)),
          );
    } else {
      ref.read(selectedDeviceIndexProvider.notifier).refreshIndex(-1);
    }
    return devices;
  }
}
