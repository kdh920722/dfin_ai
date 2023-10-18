import 'package:flutter/material.dart';

class KeyboardObserver extends WidgetsBindingObserver {
  late VoidCallback onKeyboardHeightChanged;

  void addListener(VoidCallback callback) {
    onKeyboardHeightChanged = callback;
    WidgetsBinding.instance.addObserver(this);
  }

  void removeListener() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    onKeyboardHeightChanged.call();
  }
}
