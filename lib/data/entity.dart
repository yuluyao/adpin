enum DeviceState {
  device('device'),
  offline('offline'),
  unauthorized('unauthorized'),
  bootloader('bootloader'),
  recovery('recovery');

  final String value;
  const DeviceState(this.value);

  static DeviceState fromString(String value) {
    return DeviceState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DeviceState.offline,
    );
  }
}

class Device {
  final String id;
  final DeviceState state;
  const Device(this.id, this.state);
}
