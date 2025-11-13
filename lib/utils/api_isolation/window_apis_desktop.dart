import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

Future<void> initWindowSizing() async {
  // Aman: dipanggil cuma di desktop native
  final isDesktop = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
       defaultTargetPlatform == TargetPlatform.linux  ||
       defaultTargetPlatform == TargetPlatform.macOS  ||
       defaultTargetPlatform == TargetPlatform.fuchsia);

  if (!isDesktop) return;

  setWindowTitle('SmartDoku');

  final info = await getWindowInfo();
  final size = info.frame.size;

  final w = (size.width == 0 ? 1280.0 : size.width);
  final h = (size.height == 0 ? 800.0  : size.height);

  setWindowMinSize(Size(w * 0.3125, h * 0.8333));
  setWindowMaxSize(Size(w * 2.0,     h * 1.5));
}
