import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class PlatformInfo {
  static String get os => 'web';
  static bool get isWindows => false;
  static bool get isLinux   => false;
  static bool get isMacOS   => false;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS     => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isFuchsia => false;
  static bool get isWeb     => kIsWeb;

  static bool get isDesktop => false;
  static bool get isMobile  => isAndroid || isIOS;
}
