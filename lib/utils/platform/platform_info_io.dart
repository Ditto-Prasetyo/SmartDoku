import 'dart:io' as io;

class PlatformInfo {
  static String get os => io.Platform.operatingSystem;
  static bool get isWindows => io.Platform.isWindows;
  static bool get isLinux   => io.Platform.isLinux;
  static bool get isMacOS   => io.Platform.isMacOS;
  static bool get isAndroid => io.Platform.isAndroid;
  static bool get isIOS     => io.Platform.isIOS;
  static bool get isFuchsia => io.Platform.isFuchsia;
  static bool get isWeb     => false;

  static bool get isDesktop => isWindows || isLinux || isMacOS || isFuchsia;
  static bool get isMobile  => isAndroid || isIOS;
}
