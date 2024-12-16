import 'package:gy/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ColorScheme useColorScheme() {
  final context = useContext();
  final scheme = Theme.of(context).colorScheme;
  return scheme;
}

ColorScheme useLightColorScheme() {
  return useMemoized(() => lightColorScheme());
}

ColorScheme useDarkColorScheme() {
  return useMemoized(() => darkColorScheme());
}
