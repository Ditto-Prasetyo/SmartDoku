class PlatformInfo {
  static String get os => 'unknown';
  static bool get isWindows => false;
  static bool get isLinux   => false;
  static bool get isMacOS   => false;
  static bool get isAndroid => false;
  static bool get isIOS     => false;
  static bool get isFuchsia => false;
  static bool get isWeb     => false;

  static bool get isDesktop => false;
  static bool get isMobile  => false;
}
