import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/services/surat.dart';
import 'package:smart_doku/services/user.dart';
import 'dart:ui';
import 'dart:io';
import 'package:smart_doku/utils/dialog.dart';
import 'package:smart_doku/utils/function.dart';
import 'package:smart_doku/utils/handlers/dateparser.dart';
import 'package:smart_doku/utils/map.dart';

class OutgoingLetterPage extends StatefulWidget {
  const OutgoingLetterPage({super.key});

  @override
  State<OutgoingLetterPage> createState() => _OutgoingLetterPage();
}

class _OutgoingLetterPage extends State<OutgoingLetterPage>
    with TickerProviderStateMixin {
  var height, width;

  bool isRefreshing = false;

  // Animation controllers and animations
  late AnimationController _backgroundController;

  late Animation<double> _backgroundAnimation;

  SuratKeluar _suratService = SuratKeluar();
  UserService _userService = UserService();
  List<SuratKeluarModel?>? _listSurat = [];

  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      // Cek koneksi internet dengan ping google
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ✅ Ada internet → load data dari API
        await _loadAllData();
      }
    } on SocketException catch (_) {
      // ❌ Tidak ada internet
      showModernErrorDialog(
        context,
        "Koneksi Terputus",
        "Mohon maaf, data tidak bisa diperbarui karena ketiadaan internet pada device anda saat ini!",
        Colors.redAccent,
      );
    } finally {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  Future<void> _loadAllData() async {
    print('[DEBUG] -> [INFO] : Loading all data "surat masuk" ...');
    try {
      final disposisi = await _userService.getDisposisi();
      final mappedDisposisi = workFields.entries.firstWhere(
        (e) => e.value == disposisi,
        orElse: () => const MapEntry('Tidak Diketahui', 'Unknown')
      ).key;
      final isSU = await _userService.getSuperAdminStatus();
      print("[DEBUG] -> [STATE] :: SU Status : $isSU");
      final data = disposisi != null ? await _suratService.getFilteredListSurat(mappedDisposisi, isSU) : await _suratService.listSurat();

      setState(() {
        print('[DEBUG] -> [STATE] : Surat Masuk Setted from API!');
        _listSurat = data;
        // print(_listSurat.map((e) => e?.toJson()).toList());
      });
    } catch (e) {
      print("[ERROR] -> Gagal load data: $e");

      // Kalau API error (bukan karena internet), tampilkan juga
      showModernErrorDialog(
        context,
        "Gagal Memuat Data",
        "Terjadi kesalahan saat mengambil data dari server. \nSilahkan tanyakan masalah ini kepada admin!",
        Colors.orangeAccent,
      );
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'proses':
        return Color(0xFFF59E0B);
      case 'selesai':
        return Color(0xFF10B981);
      default:
        return Color(0xFF6366F1);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAllData();

    // Initialize background animation
    _backgroundController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _backgroundController.repeat(reverse: true);
  }


  void actionSetState(int index) {
    setState(() {
      // _listSurat.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dokumen berhasil dihapus'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void refreshEditState() {
    setState(() {
      // Refresh ListView setelah edit data
      // Data suratData udah diupdate di modal
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
            child: Column(
              children: [
                // Header Drawer
                Container(
                  height: 275,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 10,
                    right: 10,
                    bottom: 15,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4F46E5).withValues(alpha: 0.6),
                        Color(0xFF7C3AED).withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: EdgeInsets.all(0.1),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.25),
                                    Colors.white.withValues(alpha: 0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      // App Icon and Title with Glassmorphism
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 50),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 15,
                                  sigmaY: 15,
                                ),
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'images/Icon_App.png',
                                      width: 180,
                                      height: 180,
                                      color: Colors.white,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [Colors.white, Colors.grey.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu Items
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF4F46E5).withValues(alpha: 0.2),
                                      Color(0xFF7C3AED).withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Color(
                                      0xFF4F46E5,
                                    ).withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(
                                        0xFF4F46E5,
                                      ).withValues(alpha: 0.2),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 5,
                                      offset: Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF4F46E5),
                                          Color(0xFF7C3AED),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFF4F46E5,
                                          ).withValues(alpha: 0.5),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.home_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    'Home',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 5,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    home(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFDC2626).withValues(alpha: 0.2),
                                      Color(0xFFEA580C).withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Color(
                                      0xFFDC2626,
                                    ).withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(
                                        0xFFDC2626,
                                      ).withValues(alpha: 0.2),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 5,
                                      offset: Offset(0, -1),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFDC2626),
                                          Color(0xFFEA580C),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFFDC2626,
                                          ).withValues(alpha: 0.5),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.logout_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 5,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () => logout(context),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: EdgeInsets.all(20),
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox();
                      final version = snapshot.data!.version;
                      final buildNumber = snapshot.data!.buildNumber;
                      return Column(
                        children: [
                          Divider(
                            color: Colors.white.withValues(alpha: 0.2),
                            thickness: 1,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Version $version+$buildNumber',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    Color(0xFF1A1A2E),
                    Color(0xFF16213E),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    Color(0xFF0F3460),
                    Color(0xFF533483),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    Color(0xFF16213E),
                    Color(0xFF0F0F0F),
                    _backgroundAnimation.value,
                  )!,
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(),
                  height: height * 0.25,
                  width: width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                          left: 15,
                          right: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Menu Button
                            Builder(
                              builder: (context) => InkWell(
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: EdgeInsets.all(4.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.menu_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),

                            // Search Button (Trigger dialog)
                            InkWell(
                              onTap: () => showFeatureNotAvailableDialog(context),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.all(4.5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Title
                      Padding(
                        padding: EdgeInsets.only(
                          top: 35,
                          left: 15,
                          right: 15,
                        ),
                        child: Center(
                          child: Text(
                            "Surat Keluar",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Container
                Expanded(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(255, 255, 255, 0.3),
                          Color.fromRGBO(248, 250, 252, 0.1),
                          Color.fromRGBO(241, 245, 249, 0.1),
                          Color.fromRGBO(255, 255, 255, 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            height: height * 0.75,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: isRefreshing
                                                ? [
                                                    Colors.white.withValues(
                                                      alpha: 0.2,
                                                    ),
                                                    Colors.white.withValues(
                                                      alpha: 0.05,
                                                    ),
                                                  ]
                                                : [
                                                    Color(
                                                      0xFF10B981,
                                                    ).withValues(alpha: 0.3),
                                                    Color(
                                                      0xFF059669,
                                                    ).withValues(alpha: 0.2),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          border: Border.all(
                                            color: isRefreshing
                                                ? Colors.white.withValues(
                                                    alpha: 0.3,
                                                  )
                                                : Color(
                                                    0xFF10B981,
                                                  ).withValues(alpha: 0.3),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 15,
                                              offset: Offset(0, 5),
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 3,
                                              offset: Offset(0, -1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Info text
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Data Surat Keluar',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    isRefreshing
                                                        ? 'Sedang memperbarui data...'
                                                        : 'Tarik ke bawah untuk refresh',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      fontSize: 12,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Sync button
                                            InkWell(
                                              onTap: isRefreshing
                                                  ? null
                                                  : _refreshData,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: isRefreshing
                                                        ? [
                                                            Color(
                                                              0xFF6B7280,
                                                            ).withValues(
                                                              alpha: 0.3,
                                                            ),
                                                            Color(
                                                              0xFF4B5563,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            ),
                                                          ]
                                                        : [
                                                            Color(
                                                              0xFF10B981,
                                                            ).withValues(
                                                              alpha: 0.3,
                                                            ),
                                                            Color(
                                                              0xFF059669,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            ),
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: isRefreshing
                                                        ? Color(
                                                            0xFF6B7280,
                                                          ).withValues(
                                                            alpha: 0.4,
                                                          )
                                                        : Color(
                                                            0xFF10B981,
                                                          ).withValues(
                                                            alpha: 0.4,
                                                          ),
                                                    width: 1.5,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: isRefreshing
                                                          ? Color(
                                                              0xFF6B7280,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            )
                                                          : Color(
                                                              0xFF10B981,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            ),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: isRefreshing
                                                    ? SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(
                                                                Colors.white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                              ),
                                                        ),
                                                      )
                                                    : Icon(
                                                        Icons.sync_rounded,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // ListView dengan RefreshIndicator
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: _refreshData,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    color: Color(0xFF10B981),
                                    strokeWidth: 3,
                                    child: ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(
                                        parent: BouncingScrollPhysics(),
                                      ), // Enable pull to refresh even when list is short
                                      itemCount: _listSurat?.length ?? 0,
                                      padding: EdgeInsets.only(bottom: 20),
                                      itemBuilder: (context, index) {
                                        final surat = _listSurat?[index] ?? null;

                                        return Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 15,
                                                sigmaY: 15,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Colors.white.withValues(
                                                        alpha: 0.25,
                                                      ),
                                                      Colors.white.withValues(
                                                        alpha: 0.1,
                                                      ),
                                                      Colors.white.withValues(
                                                        alpha: 0.05,
                                                      ),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.3),
                                                    width: 1.5,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      blurRadius: 20,
                                                      offset: Offset(0, 10),
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      blurRadius: 5,
                                                      offset: Offset(0, -2),
                                                    ),
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    actionUserKeluar(
                                                      index,
                                                      context,
                                                      _listSurat!,
                                                      
                                                      (i) => viewDetailKeluar(
                                                        context,
                                                        index,
                                                        _listSurat!,
                                                      ),
                                                    );
                                                    print(
                                                      'Surat dipilih: ${surat?.perihal}',
                                                    );
                                                  },
                                                  onLongPress: () {
                                                    actionUserKeluar(
                                                      index,
                                                      context,
                                                      _listSurat!,
                                                      (i) => viewDetailKeluar(
                                                        context,
                                                        index,
                                                        _listSurat!,
                                                      ),
                                                    );
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 6,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    getStatusColor(
                                                                      surat!
                                                                          .status!,
                                                                    ),
                                                                    getStatusColor(
                                                                      surat
                                                                          .status!,
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      20,
                                                                    ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color:
                                                                        getStatusColor(
                                                                          surat
                                                                              .status!,
                                                                        ).withValues(
                                                                          alpha:
                                                                              0.3,
                                                                        ),
                                                                    blurRadius:
                                                                        8,
                                                                    offset:
                                                                        Offset(
                                                                          0,
                                                                          2,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Text(
                                                                surat.status!,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),
                                                            // Tanggal
                                                            Text(
                                                              parseDateFormat(surat.tanggal_surat),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.7,
                                                                    ),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Roboto',
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        SizedBox(height: 15),

                                                        // Judul Surat
                                                        Text(
                                                          surat.perihal,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Roboto',
                                                            height: 1.3,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),

                                                        SizedBox(height: 8),

                                                        // Klasifikasi
                                                        Text(
                                                          surat.klasifikasi,
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Roboto',
                                                            height: 1.4,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),

                                                        SizedBox(height: 15),

                                                        // Footer dengan pengirim dan icon
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            // Pengirim
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          6,
                                                                        ),
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                        colors: [
                                                                          Color(
                                                                            0xFF4F46E5,
                                                                          ).withValues(
                                                                            alpha:
                                                                                0.3,
                                                                          ),
                                                                          Color(
                                                                            0xFF7C3AED,
                                                                          ).withValues(
                                                                            alpha:
                                                                                0.2,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .person_outline_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      surat
                                                                          .pengolah,
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white
                                                                            .withValues(
                                                                              alpha: 0.7,
                                                                            ),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Roboto',
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            // Arrow icon
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    6,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    Colors.white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.2,
                                                                        ),
                                                                    Colors.white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.1,
                                                                        ),
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .more_vert_rounded,
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                                size: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
