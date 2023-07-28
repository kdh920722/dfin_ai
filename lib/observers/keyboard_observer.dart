import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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
    final keyboardHeight = ui.window.viewInsets.bottom;
    onKeyboardHeightChanged.call();
  }
}
