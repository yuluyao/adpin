import 'package:gy/ui/adb_info.dart';
import 'package:gy/ui/devices.dart';
import 'package:flutter/material.dart';
import 'package:gy/ui/install.dart';
import 'package:gy/ui/top_activity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: const Column(
          children: [
            AdbInfo(),
            SizedBox(height: 16),
            DeviceList(),
            SizedBox(height: 16),
            Install(),
            SizedBox(height: 16),
            TopActivityInfo(),
          ],
        ),
      ),
    );
  }
}
