import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_doku/pages/forms/users/detail_page.dart';
import 'package:smart_doku/pages/views/users/home_page.dart';
import 'package:smart_doku/pages/views/users/surat_disposisi_page.dart';
import 'package:smart_doku/pages/views/users/surat_keluar_page.dart';
import 'package:smart_doku/pages/views/users/surat_permohonan_page.dart';
import 'dart:io' show Platform;
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Jika di Web, jangan jalankan kode desktop seperti window_size
    print("Aplikasi dijalankan di Web.");
  } else if (Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isFuchsia) {
    // Hanya di platform desktop yang mendukung window_size
    setWindowTitle('SmartDoku');
    var windowInfo = await getWindowInfo();
    var size = windowInfo.frame.size;
    setWindowMinSize(
      Size(size.width * 0.3125, size.height * 0.8333),
    ); // Minimum window size
    setWindowMaxSize(
      Size(size.width * 2.0, size.height * 1.5),
    ); // Maximum window size
  }

  runApp(const SmartDoku());
}

class SmartDoku extends StatelessWidget {
  const SmartDoku({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartDoku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/users/surat_permohonan': (context) => PermohonanLetterPage(),
        '/users/surat_keluar': (context) => OutgoingLetterPage(),
        '/users/surat_disposisi': (context) => DispositionLetterPage(),
        '/forms/users/detail_page': (context) => DetailPage(),
      },
    );
  }
}
