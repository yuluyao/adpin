// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedDeviceHash() => r'ed9bfc447570618ed02b919bb5a44fa47d62ab97';

/// See also [selectedDevice].
@ProviderFor(selectedDevice)
final selectedDeviceProvider = FutureProvider<Device?>.internal(
  selectedDevice,
  name: r'selectedDeviceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDeviceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedDeviceRef = FutureProviderRef<Device?>;
String _$adbPathHash() => r'519a673646f2116813968cbf2033a62187a0496a';

/// See also [AdbPath].
@ProviderFor(AdbPath)
final adbPathProvider = AsyncNotifierProvider<AdbPath, String>.internal(
  AdbPath.new,
  name: r'adbPathProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adbPathHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdbPath = AsyncNotifier<String>;
String _$selectedDeviceIndexHash() =>
    r'733102776c50efb74811380605a32683cd626d71';

/// See also [SelectedDeviceIndex].
@ProviderFor(SelectedDeviceIndex)
final selectedDeviceIndexProvider =
    NotifierProvider<SelectedDeviceIndex, int>.internal(
  SelectedDeviceIndex.new,
  name: r'selectedDeviceIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDeviceIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDeviceIndex = Notifier<int>;
String _$devicesHash() => r'd02f96e4349c131e0fad9098d9bb81f5bd4bf119';

/// See also [Devices].
@ProviderFor(Devices)
final devicesProvider = AsyncNotifierProvider<Devices, List<Device>>.internal(
  Devices.new,
  name: r'devicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$devicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Devices = AsyncNotifier<List<Device>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
