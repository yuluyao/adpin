import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gy/data/entity.dart';
import 'package:gy/data/my_store.dart';
import 'package:gy/theme/color_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// adb连接的设备列表
/// 单选，默认选中第1个
class DeviceList extends HookConsumerWidget {
  const DeviceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = useColorScheme();
    final devicesAsync = ref.watch(devicesProvider);
    final devices = switch (devicesAsync) {
      AsyncData(:final value) => value,
      _ => <Device>[],
    };
    final selectedIndex = ref.watch(selectedDeviceIndexProvider);

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
          // header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '设备列表',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => ref.invalidate(devicesProvider),
                child: const Text('刷新'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // devices
          ...devices.mapIndexed((index, e) {
            final isSelected = index == selectedIndex;
            final itemTextColor = switch (e.state) {
              DeviceState.device => scheme.secondary,
              DeviceState.offline => scheme.error,
              DeviceState.unauthorized => scheme.error,
              DeviceState.bootloader => scheme.error,
              DeviceState.recovery => scheme.error,
            };
            return GestureDetector(
              onTap: () {
                ref.read(selectedDeviceIndexProvider.notifier).refreshIndex(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: isSelected ? scheme.primary : scheme.outline),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(e.id, style: TextStyle(color: itemTextColor))),
                    Text(
                      switch (e.state) {
                        DeviceState.device => '已连接',
                        DeviceState.offline => '离线',
                        DeviceState.unauthorized => '未授权',
                        DeviceState.bootloader => 'bootloader',
                        DeviceState.recovery => 'recovery',
                      },
                      style: TextStyle(color: itemTextColor),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
