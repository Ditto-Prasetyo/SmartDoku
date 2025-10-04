import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/services/surat.dart';
import 'dart:ui';
import 'dart:io';
import 'package:smart_doku/utils/dialog.dart';
import 'package:smart_doku/utils/function.dart';
import 'package:smart_doku/utils/widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_doku/utils/map.dart';

class PermohonanLettersPageDesktop extends StatefulWidget {
  const PermohonanLettersPageDesktop({Key? key}) : super(key: key);

  @override
  State<PermohonanLettersPageDesktop> createState() =>
      _PermohonanLettersPageDesktopState();
}

class _PermohonanLettersPageDesktopState
    extends State<PermohonanLettersPageDesktop>
    with TickerProviderStateMixin {
  var height, width;
  bool isLoading = true;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  SuratMasuk _suratService = SuratMasuk();
  List<SuratMasukModel?> _listSurat = [];

  Future<void> _loadAllData() async {
    print("[DEBUG] -> [INFO] : Loading all data surat masuk ...");
    try {
      final data = await _suratService.listSurat();
      setState(() {
        _listSurat = data;
        isLoading = false;
      });
      print("[DEBUG] -> [STATE] : Set Surat Masuk data to listSurat!");
    } catch (e) {
      setState(() => isLoading = false);
      print("[ERROR] -> gagal load data: $e");
      // tampilkan error dialog modern
      showModernErrorDialog(
        context,
        "Gagal Memuat Data",
        "Terjadi kesalahan saat mengambil data dari server. \nSilahkan tanyakan masalah ini kepada admin!",
        Colors.redAccent,
      );
    }
  }

  // Selected sidebar item
  int _selectedIndex = 1;

  final List<Map<String, dynamic>> _sidebarItems = [
    {
      'icon': Icons.dashboard_rounded,
      'title': 'Dashboard',
      'route': '/user/desktop/home_page_desktop',
    },
    {
      'icon': LineIcons.envelopeOpen,
      'title': 'Surat Masuk',
      'route': '/user/desktop/surat_permohonan_page_desktop',
    },
    {
      'icon': FontAwesomeIcons.envelopeCircleCheck,
      'title': 'Surat Keluar',
      'route': '/user/desktop/surat_keluar_page_desktop',
    },
    {
      'icon': Icons.assignment_turned_in_rounded,
      'title': 'Disposisi',
      'route': '/user/desktop/surat_disposisi_page_desktop',
    },
    {
      'icon': Icons.people_alt_rounded,
      'title': 'Profile Anda',
      'route': '/user/desktop/profile_user_page',
    },
  ];

  void actionSetState(int index) {
    setState(() {
      _listSurat.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dokumen berhasil dihapus'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void refreshEditState() {
    _loadAllData();
    setState(() {});
  }

  void _navigateToPage(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  ) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushNamedAndRemoveUntil(context, item['route'], (route) => false);
  }

  @override
  void initState() {
    super.initState();
    _loadAllData();

    // Initialize animations
    _backgroundController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutSine,
      ),
    );

    _cardController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );

    _backgroundController.repeat(reverse: true);
    _cardController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(5, 0),
          ),
        ],
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
      ),
      child: Column(
        children: [
          // Header with logo
          Container(
            height: 120,
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4F46E5).withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  child: Image.asset(
                    'images/Icon_App.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Smart Doku',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        'User Panel',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: Colors.white.withValues(alpha: 0.2),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),

          // Menu items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: _sidebarItems.length,
              itemBuilder: (context, index) {
                final item = _sidebarItems[index];
                final isSelected = _selectedIndex == index;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isSelected
                                ? [
                                    Color(0xFF4F46E5).withValues(alpha: 0.3),
                                    Color(0xFF7C3AED).withValues(alpha: 0.2),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.05),
                                    Colors.white.withValues(alpha: 0.02),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xFF4F46E5).withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.1),
                            width: 1.5,
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        Color(0xFF4F46E5),
                                        Color(0xFF7C3AED),
                                      ],
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              item['icon'],
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          onTap: () => _navigateToPage(context, item, index),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Logout button
          Container(
            padding: EdgeInsets.all(20),
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
                      color: Color(0xFFDC2626).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFDC2626), Color(0xFFEA580C)],
                        ),
                        borderRadius: BorderRadius.circular(10),
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
                        fontSize: 15,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    onTap: () => logoutDesktop(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Build Number items
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
    );
  }

  Widget _buildTableDataLetters(Animation<double> _cardAnimation) {
    return Transform.translate(
      offset: Offset(0, 50 * (1 - _cardAnimation.value)),
      child: Opacity(
        opacity: _cardAnimation.value.clamp(0.0, 1.0),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 255, 255, 0.2),
                Color.fromRGBO(248, 250, 252, 0.05),
                Color.fromRGBO(241, 245, 249, 0.05),
                Color.fromRGBO(255, 255, 255, 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(150)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSectionTitleDisposisiDesktop('Data Surat Masuk'),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.table_chart_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '${_listSurat.length} Data',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Table Container
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.white.withValues(alpha: 0.05),
                            Colors.white.withValues(alpha: 0.05),
                            Colors.white.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Scrollbar(
                        controller: _horizontalScrollController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        thickness: 8,
                        radius: Radius.circular(4),
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width -
                                  48, // 48 = padding * 2
                              maxWidth:
                                  MediaQuery.of(context).size.width +
                                  (MediaQuery.of(context).size.width - 48),
                            ),
                            child: IntrinsicWidth(
                              child: Column(
                                children: [
                                  // Header Row
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0.20),
                                          Colors.white.withValues(alpha: 0.10),
                                        ],
                                      ),
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // 1. No - flex: 1
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 2. Surat dari - flex: 200
                                        SizedBox(width: 20),
                                        Expanded(
                                          flex: 170,
                                          child: Text(
                                            'Surat Dari',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // 3. Diterima TGL - flex: 100
                                        SizedBox(width: 8),
                                        Expanded(
                                          flex: 140,
                                          child: Text(
                                            'Diterima \nTGL',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // 4. Tanggal Surat - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 120,
                                          child: Text(
                                            'TGL Surat',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 5. Kode - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 80,
                                          child: Text(
                                            'Kode',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 6. No Urut - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 110,
                                          child: Text(
                                            'No Urut',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 7. No Agenda - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 120,
                                          child: Text(
                                            'No Agenda',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 8. No Surat - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 60,
                                          child: Text(
                                            'No \nSurat',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 9. Perihal - flex: 200
                                        Expanded(
                                          flex: 220,
                                          child: Text(
                                            'Perihal',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // 10. Hari/Tanggal - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 150,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Hari/Tanggal\n/Waktu',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),

                                        // 12. Tempat - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 80,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Tempat',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),

                                        // 13. Disposisi - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 110,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Disposisi',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),

                                        // 14. Index - flex: 100
                                        Expanded(
                                          flex: 100,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Index',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),

                                        // 15. Pengolah - flex: 100
                                        Expanded(
                                          flex: 100,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Pengolah',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),

                                        // 16. Sifat - flex: 100
                                        Expanded(
                                          flex: 120,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Sifat',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),

                                        // 17. Link Scan - flex: 200
                                        Expanded(
                                          flex: 200,
                                          child: Text(
                                            'Link Scan',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // 18. Disposisi Kadin - flex: 100
                                        Expanded(
                                          flex: 115,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8),
                                            child: Text(
                                              'Disposisi \nKadin',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),

                                        // 19. Disposisi Sekdin - flex: 100
                                        Expanded(
                                          flex: 75,
                                          child: Text(
                                            'Disposisi \nSekdin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // 20. Disposisi Kabid - flex: 100
                                        Expanded(
                                          flex: 130,
                                          child: Text(
                                            'Disposisi\nKabid/ \nKaUPT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // 21. Disposisi Kasubag - flex: 100
                                        Expanded(
                                          flex: 80,
                                          child: Text(
                                            'Disposisi \nKasubag/ \nKasi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        Expanded(
                                          flex: 140,
                                          child: Text(
                                            'Catatan Disposisi \nKadin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        Expanded(
                                          flex: 100,
                                          child: Text(
                                            'Catatan Disposisi \nSekdin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        Expanded(
                                          flex: 120,
                                          child: Text(
                                            'Catatan Disposisi\nKabid/ \nKaUPT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        Expanded(
                                          flex: 140,
                                          child: Text(
                                            'Catatan Disposisi \nKasubag/ \nKasi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // 22. Disposisi Lanjutan - flex: 200
                                        Expanded(
                                          flex: 120,
                                          child: Text(
                                            'Disposisi \nLanjutan',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 23. Tindak Lanjut 1 - flex: 100
                                        Expanded(
                                          flex: 100,
                                          child: Text(
                                            'Tindak \nLanjut 1',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 24. Tindak Lanjut 2 - flex: 100
                                        Expanded(
                                          flex: 110,
                                          child: Text(
                                            'Tindak \nLanjut 2',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // 25. Status - flex: 100
                                        Expanded(
                                          flex: 60,
                                          child: Text(
                                            'Status',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),

                                        // Actions - width: 100 (fixed)
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'Aksi',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Table Body
                                  Expanded(
                                    child: Scrollbar(
                                      controller: _verticalScrollController,
                                      thumbVisibility: true,
                                      trackVisibility: true,
                                      thickness: 8,
                                      radius: Radius.circular(4),
                                      child: SingleChildScrollView(
                                        controller: _verticalScrollController,
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: isLoading
                                              ? [
                                                  // 👇 Kalau lagi loading
                                                  Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 40,
                                                        ),
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors
                                                              .greenAccent,
                                                        ),
                                                  ),
                                                ]
                                              : _listSurat.isEmpty
                                              ? [
                                                  // 👇 Kalau kosong
                                                  Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 40,
                                                        ),
                                                    child: Text(
                                                      "Belum ada data surat masuk",
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.8,
                                                            ),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              : List.generate(_listSurat.length, (
                                                  index,
                                                ) {
                                                  final surat =
                                                      _listSurat[index];
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        print(
                                                          'Row tapped: ${surat?.nama_surat}',
                                                        );
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              vertical: 4,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            // 1. No - width: 40 (sama kayak header)
                                                            SizedBox(
                                                              width: 40,
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          2,
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
                                                                        6,
                                                                      ),
                                                                  border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 0.2,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  '${index + 1}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            // 2. Surat dari - flex: 200
                                                            SizedBox(width: 20),
                                                            Expanded(
                                                              flex: 200,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    surat?.nama_surat ==
                                                                            null
                                                                        ? 'Data Judul \nSurat Kosong'
                                                                        : surat!
                                                                              .nama_surat,
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  Text(
                                                                    surat?.hal ==
                                                                            null
                                                                        ? 'Data Perihal Kosong'
                                                                        : surat!
                                                                              .hal,
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white
                                                                          .withValues(
                                                                            alpha:
                                                                                0.7,
                                                                          ),
                                                                      fontSize:
                                                                          11,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            // 3. Diterima tgl - flex: 100
                                                            SizedBox(width: 8),
                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat?.tanggal_diterima ==
                                                                        null
                                                                    ? 'Data Tanggal \nDiterima Kosong'
                                                                    : surat!
                                                                          .tanggal_diterima
                                                                          .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),

                                                            // 4. Tanggal - flex: 100
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat?.tanggal_surat ==
                                                                        null
                                                                    ? 'Data Tanggal \nSurat Kosong'
                                                                    : surat!
                                                                          .tanggal_surat
                                                                          .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),

                                                            // 5. Kode - flex: 100
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat?.kode ==
                                                                        null
                                                                    ? 'Data Kode \nSurat Kosong'
                                                                    : surat!
                                                                          .kode,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),

                                                            // 6. No_urut - flex: 100
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 80,
                                                              child: Text(
                                                                surat?.nomor_urut ==
                                                                        null
                                                                    ? 'Data Nomor Urut \nSurat Kosong'
                                                                    : surat!
                                                                          .nomor_urut
                                                                          .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),

                                                            // 7. No_agenda - flex: 100
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 130,
                                                              child: Text(
                                                                surat?.kode ==
                                                                        null
                                                                    ? ''
                                                                    : surat!.kode +
                                                                          "/" +
                                                                          surat
                                                                              .nomor_urut
                                                                              .toString() +
                                                                          "/" +
                                                                          '35.07.303/2025',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),

                                                            // 8. No surat - flex: 100
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 60,
                                                              child: Text(
                                                                surat?.no_surat ==
                                                                        null
                                                                    ? 'Data No Surat Kosong'
                                                                    : surat!
                                                                          .no_surat,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),

                                                            // 9. Perihal - flex: 200
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 230,
                                                              child: Text(
                                                                surat?.hal ==
                                                                        null
                                                                    ? 'Data Perihal Kosong'
                                                                    : surat!
                                                                          .hal,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                softWrap: true,
                                                              ),
                                                            ),

                                                            // 10. Hari/tanggal - flex: 100
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 100,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left: 8.0,
                                                                    ),
                                                                child: Text(
                                                                  surat?.tanggal_waktu ==
                                                                          null
                                                                      ? 'Data Hari Tanggal Waktu Kosong'
                                                                      : surat!
                                                                            .tanggal_waktu
                                                                            .toString(),
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.7,
                                                                        ),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                              ),
                                                            ),

                                                            // 12. Tempat - flex: 100
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 100,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left: 8,
                                                                    ),
                                                                child: Text(
                                                                  surat?.tempat ==
                                                                          null
                                                                      ? 'Data Tempat Kosong'
                                                                      : surat!
                                                                            .tempat,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.7,
                                                                        ),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            // 13. Disposisi - flex: 100
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 100,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left: 8,
                                                                    ),
                                                                child: Text(
                                                                  surat?.disposisi == null
                                                                      ? '-'
                                                                      : (surat!.disposisi as List).join(", "),
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.7,
                                                                        ),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            // 14. Index - flex: 100
                                                            Expanded(
                                                              flex: 100,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left: 8,
                                                                    ),
                                                                child: Text(
                                                                  surat!.index!,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.7,
                                                                        ),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            // 15. Pengolah - flex: 100
                                                            Expanded(
                                                              flex: 100,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left: 8,
                                                                    ),
                                                                child: Text(
                                                                  surat?.pengolah ==
                                                                          null
                                                                      ? 'Data Tempat Kosong'
                                                                      : surat
                                                                            .pengolah,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.7,
                                                                        ),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                  softWrap:
                                                                      true,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                ),
                                                              ),
                                                            ),

                                                            // 16. Sifat - flex: 100
                                                            Expanded(
                                                              flex: 100,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left: 8,
                                                                    ),
                                                                child: Text(
                                                                  surat.sifat!,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.7,
                                                                        ),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            // 17. Link scan - flex: 200
                                                            Expanded(
                                                              flex: 200,
                                                              child: Text(
                                                                surat
                                                                    .link_scan!,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),

                                                            // 18. Disposisi kadin - flex: 100
                                                            Expanded(
                                                              flex: 100,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                      left: 8,
                                                                    ),
                                                                child: Text(
                                                                  surat.disp_1 == null
                                                                      ? 'Data Disposisi Kadin Kosong'
                                                                      : surat.disp_1.toString(),
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.7,
                                                                        ),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                  ),
                                                                  softWrap:
                                                                      true,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                ),
                                                              ),
                                                            ),

                                                            // 19. Disposisi Sekdin - flex: 100
                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat.disp_2 ==
                                                                        null
                                                                    ? 'Data Disposisi Sekdin Kosong'
                                                                    : surat
                                                                          .disp_2
                                                                          .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            // 20. Disposisi Kabid - flex: 100
                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat.disp_3
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            // 21. Disposisi Kasubag - flex: 100
                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat.disp_4
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat.disp_1_notes ??
                                                                    "-",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat.disp_2_notes ??
                                                                    "-",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat
                                                                    .disp_3_notes!,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat.disp_4_notes ??
                                                                    "-",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            // 22. Disposisi Lanjutan - flex: 200
                                                            Expanded(
                                                              flex: 130,
                                                              child: Text(
                                                                surat.disp_lanjut ??
                                                                    "-",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            // 23. Tindak lanjut 1 - flex: 100
                                                            Expanded(
                                                              flex: 100,
                                                              child: Text(
                                                                surat
                                                                    .tindak_lanjut_1
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            // 24. Tindak lanjut 2 - flex: 100
                                                            Expanded(
                                                              flex: 110,
                                                              child: Text(
                                                                surat
                                                                    .tindak_lanjut_2
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.7,
                                                                      ),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                              ),
                                                            ),

                                                            // 25. Status - flex: 100
                                                            Expanded(
                                                              flex: 60,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                widthFactor: 1,
                                                                child: Container(
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            8,
                                                                        vertical:
                                                                            4,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                      colors: [
                                                                        getStatusColor(
                                                                          surat
                                                                              .status,
                                                                        ),
                                                                        getStatusColor(
                                                                          surat
                                                                              .status,
                                                                        ).withValues(
                                                                          alpha:
                                                                              0.8,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color:
                                                                            getStatusColor(
                                                                              surat.status,
                                                                            ).withValues(
                                                                              alpha: 0.3,
                                                                            ),
                                                                        blurRadius:
                                                                            4,
                                                                        offset:
                                                                            Offset(
                                                                              0,
                                                                              1,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Text(
                                                                    surat
                                                                        .status,
                                                                    softWrap:
                                                                        true,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          'Roboto',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            // Actions - width: 100 (sama kayak header)
                                                            SizedBox(
                                                              width: 100,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // View button
                                                                  Container(
                                                                    margin:
                                                                        EdgeInsets.only(
                                                                          right:
                                                                              4,
                                                                        ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          6,
                                                                        ),
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                        colors: [
                                                                          Color(
                                                                            0xFF3B82F6,
                                                                          ).withValues(
                                                                            alpha:
                                                                                0.3,
                                                                          ),
                                                                          Color(
                                                                            0xFF1D4ED8,
                                                                          ).withValues(
                                                                            alpha:
                                                                                0.2,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            6,
                                                                          ),
                                                                    ),
                                                                    child: InkWell(
                                                                      onTap: () {
                                                                        viewDetail(
                                                                          context,
                                                                          index,
                                                                          _listSurat,
                                                                        );
                                                                      },
                                                                      child: Icon(
                                                                        Icons
                                                                            .visibility_outlined,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
    );
  }

  // Helper function untuk warna status (pastikan ini ada di class lu)
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Color(0xFF10B981); // Green
      case 'proses':
        return Color(0xFFF59E0B); // Orange
      case 'ditolak':
        return Color(0xFFEF4444); // Red
      default:
        return Color(0xFF6B7280); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
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
            child: Row(
              children: [
                // Sidebar
                _buildSidebar(),

                // Main content
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Surat Masuk',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Anda Dapat Melihat isi dalam Surat Masuk di Sini!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4F46E5),
                                    Color(0xFF7C3AED),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      0xFF4F46E5,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        // Recent activity
                        Expanded(child: _buildTableDataLetters(_cardAnimation)),
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
