import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadPathService {
  // optional: singleton biar gampang dipake di mana-mana
  DownloadPathService._internal();
  static final DownloadPathService _instance = DownloadPathService._internal();
  factory DownloadPathService() => _instance;

  Future<String> getDefaultDownloadPath() async {
    // ANDROID
    if (Platform.isAndroid) {
      // 1. Minta izin storage
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Izin penyimpanan ditolak. Aktifkan izin Storage dulu.');
      }

      // 2. Pakai folder Download publik
      final downloadDir = Directory('/storage/emulated/0/Download');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      return downloadDir.path;
    }

    // WINDOWS / LINUX / MACOS
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final dir = await getDownloadsDirectory();
      if (dir == null) {
        throw Exception('Gagal mendapatkan direktori Download.');
      }
      return dir.path;
    }

    // fallback platform lain (iOS, web, dsb) → pakai documents dir
    final docs = await getApplicationDocumentsDirectory();
    return docs.path;
  }
}
