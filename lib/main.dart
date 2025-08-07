import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_doku/pages/forms/users/detail_page.dart';
import 'package:smart_doku/pages/views/admins/desktop/home_page_admin_desktop.dart';
import 'package:smart_doku/pages/views/admins/desktop/manajemen_pengguna_page.dart';
import 'package:smart_doku/pages/views/admins/desktop/setting_page.dart';
import 'package:smart_doku/pages/views/admins/desktop/surat_disposisi_page_admin_desktop.dart';
import 'package:smart_doku/pages/views/admins/desktop/surat_keluar_page_admin_desktop.dart';
import 'package:smart_doku/pages/views/admins/desktop/surat_permohonan_page_admin_desktop.dart';
import 'package:smart_doku/pages/views/admins/phones/home_page_admin_phones.dart';
import 'package:smart_doku/pages/views/admins/phones/surat_disposisi_page_admin.dart';
import 'package:smart_doku/pages/views/admins/phones/surat_keluar_page_admin.dart';
import 'package:smart_doku/pages/views/admins/phones/surat_permohonan_page_admin.dart';
import 'package:smart_doku/pages/views/users/phones/surat_disposisi_page.dart';
import 'package:smart_doku/pages/views/users/phones/surat_keluar_page.dart';
import 'package:smart_doku/pages/views/users/phones/surat_permohonan_page.dart';
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

  await dotenv.load(fileName: ".config/.env");

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
      home: HomePageAdminPhones(),
      debugShowCheckedModeBanner: false,
      routes: {
        // users phone
        '/users/phone/surat_permohonan': (context) => PermohonanLetterPage(),
        '/users/phone/surat_keluar': (context) => OutgoingLetterPage(),
        '/users/phone/surat_disposisi': (context) => DispositionLetterPage(),
        '/forms/phone/users/detail_page': (context) => DetailPage(),

        // users desktop
        // '/users/desktop/surat_permohonan': (context) => PermohonanLetterPageDesktop(),
        // '/users/desktop/surat_keluar': (context) => OutgoingLetterPageDesktop(),
        // '/users/desktop/surat_disposisi': (context) => DispositionLetterPageDesktop(),
        // '/users/desktop/home_page': (context) => HomePageDesktop(),

        // admins and superadmins phone
        '/admin/phones/home_page_admin_phones' : (context) => HomePageAdminPhones(),
        '/admin/phones/surat_permohonan_page_admin' : (context) => PermohonanLetterPageAdmin(),
        '/admin/phones/surat_keluar_page_admin' : (context) => OutgoingLetterPageAdmin(),
        '/admin/phones/surat_disposisi_page_admin' : (context) => DispositionLetterPageAdmin(),

        // admins and superadmins desktop
        '/admin/desktop/home_page_admin_desktop': (context) =>
            AdminDashboard(),
        '/admin/desktop/surat_permohonan_page_admin_desktop': (context) =>
            PermohonanLettersPageAdminDesktop(),
        '/admin/desktop/surat_keluar_page_admin_desktop': (context) =>
            OutgoingLetterPageAdminDesktop(),
        '/admin/desktop/surat_disposisi_page_admin_desktop': (context) =>
            DispositionLetterAdminDesktop(),
        '/admin/desktop/manajemen_pengguna_page': (context) =>
            UsersManagementPage(),
        '/admin/desktop/setting_page': (context) =>
            SettingPage(),
      },
    );
  }
}
