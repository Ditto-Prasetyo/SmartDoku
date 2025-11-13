import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_doku/pages/forms/admins/desktop/tables_page_admin.dart';
import 'package:smart_doku/pages/forms/users/detail_masuk_page.dart';
import 'package:smart_doku/pages/splashs/splashscreen_before_page.dart';
import 'package:smart_doku/pages/views/admins/desktop/home_page_admin_desktop.dart';
import 'package:smart_doku/pages/views/admins/desktop/manajemen_pengguna_page.dart';
import 'package:smart_doku/pages/views/admins/desktop/profile_admin_page.dart';
import 'package:smart_doku/pages/views/admins/desktop/setting_page.dart';
import 'package:smart_doku/pages/views/admins/desktop/surat_disposisi_page_admin_desktop.dart';
import 'package:smart_doku/pages/views/admins/desktop/surat_keluar_page_admin_desktop.dart';
import 'package:smart_doku/pages/views/admins/desktop/surat_permohonan_page_admin_desktop.dart';
import 'package:smart_doku/pages/views/admins/phones/home_page_admin_phones.dart';
import 'package:smart_doku/pages/views/admins/phones/management_user_phones.dart';
import 'package:smart_doku/pages/views/admins/phones/surat_disposisi_page_admin.dart';
import 'package:smart_doku/pages/views/admins/phones/surat_keluar_page_admin.dart';
import 'package:smart_doku/pages/views/admins/phones/surat_permohonan_page_admin.dart';
import 'package:smart_doku/pages/views/users/desktop/home_page_desktop.dart';
import 'package:smart_doku/pages/views/users/desktop/profile_user_page.dart';
import 'package:smart_doku/pages/views/users/desktop/surat_disposisi_page_desktop.dart';
import 'package:smart_doku/pages/views/users/desktop/surat_keluar_page_desktop.dart';
import 'package:smart_doku/pages/views/users/desktop/surat_permohonan_page_desktop.dart';
import 'package:smart_doku/pages/views/users/phones/surat_disposisi_page.dart';
import 'package:smart_doku/pages/views/users/phones/surat_keluar_page.dart';
import 'package:smart_doku/pages/views/users/phones/surat_permohonan_page.dart';
import 'package:smart_doku/services/bookmarks.dart';
import 'package:smart_doku/services/settings.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;  
import 'package:window_size/window_size.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool isDesktop = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
       defaultTargetPlatform == TargetPlatform.linux  ||
       defaultTargetPlatform == TargetPlatform.macOS  ||
       defaultTargetPlatform == TargetPlatform.fuchsia);

  if (kIsWeb) {
    // Web: jangan jalankan window_size
    // print("Aplikasi dijalankan di Web."); // optional
  } else if (isDesktop) {
    setWindowTitle('SmartDoku');
    final info = await getWindowInfo();
    final size = info.frame.size;
    setWindowMinSize(Size(size.width * 0.3125, size.height * 0.8333));
    setWindowMaxSize(Size(size.width * 2.0, size.height * 1.5));
  }

  try {
    await dotenv.load(fileName: ".config/.env");
  } catch (e) {
    print('[DOTENV] ${e.toString()}'); // optional
  }

  await AppSettings().init(); // init prefs global
  final bookmarks = await Bookmarks.getBookmarks();

  // For Debug
  final suf1 = AppSettings().part1;
  final suf2 = AppSettings().part3;
  print('[DEBUG] :: [STATE] : Suffix code = $suf1/$suf2');
  print('[DEBUG] :: [STATE] : Bookmarks Data');
  print(bookmarks);

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
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.6)),
          trackColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.1)), 
          trackBorderColor: WidgetStateProperty.all(Colors.transparent),
          thickness: WidgetStateProperty.all(8  ), 
          radius: Radius.circular(8),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'), // Indonesia
        Locale('en', 'US'), // English
      ],
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        // users phone
        '/users/phone/surat_permohonan': (context) => PermohonanLetterPage(),
        '/users/phone/surat_keluar': (context) => OutgoingLetterPage(),
        '/users/phone/surat_disposisi': (context) => DispositionLetterPage(),
        '/forms/phone/users/detail_page': (context) => DetailPage(),

        // users desktop
        '/user/desktop/home_page_desktop': (context) => UserDashboard(),
        '/user/desktop/surat_permohonan_page_desktop': (context) => PermohonanLettersPageDesktop(),
        '/user/desktop/surat_keluar_page_desktop': (context) => OutgoingLetterPageDesktop(),
        '/user/desktop/surat_disposisi_page_desktop': (context) =>
            DispositionLetterUserDesktop(),
            '/user/desktop/profile_user_page' : (context) => UserProfile(),

        // admins and superadmins phone
        '/admin/phones/home_page_admin_phones': (context) =>
            HomePageAdminPhones(),
        '/admin/phones/surat_permohonan_page_admin': (context) =>
            PermohonanLetterPageAdmin(),
        '/admin/phones/surat_keluar_page_admin': (context) =>
            OutgoingLetterPageAdmin(),
        '/admin/phones/surat_disposisi_page_admin': (context) =>
            DispositionLetterPageAdmin(),
        '/admin/phones/management_user_phones': (context) =>
            ManagementUserPhones(),

        // admins and superadmins desktop
        '/admin/desktop/home_page_admin_desktop': (context) => AdminDashboard(),
        '/admin/desktop/surat_permohonan_page_admin_desktop': (context) =>
            PermohonanLettersPageAdminDesktop(),
        '/admin/desktop/surat_keluar_page_admin_desktop': (context) =>
            OutgoingLetterPageAdminDesktop(),
        '/admin/desktop/surat_disposisi_page_admin_desktop': (context) =>
            DispositionLetterAdminDesktop(),
        '/admin/desktop/manajemen_pengguna_page': (context) =>
            UsersManagementPage(),
        '/admin/desktop/setting_page': (context) => SettingPage(),
        '/admin/desktop/profile_admin_page' : (context) => AdminProfile(),

        // testing
        '/forms/admins/desktop/tables_page_admin' : (context) => TablesPageAdmin()
      },
    );
  }
}