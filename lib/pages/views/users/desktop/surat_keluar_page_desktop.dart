import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/services/surat.dart';
import 'dart:ui';
import 'package:smart_doku/utils/function.dart';
import 'package:smart_doku/utils/widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OutgoingLetterPageDesktop extends StatefulWidget {
  const OutgoingLetterPageDesktop({super.key});

  @override
  State<OutgoingLetterPageDesktop> createState() =>
      _OutgoingLetterPageDesktopState();
}

class _OutgoingLetterPageDesktopState extends State<OutgoingLetterPageDesktop>
    with TickerProviderStateMixin {
  var height, width;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  SuratKeluar _suratService = SuratKeluar();
  List<SuratKeluarModel?> _listSurat = [];

  // Selected sidebar item
  int _selectedIndex = 2;

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

  List<Map<String, dynamic>> listPengolah = [
    {'id': 'p1', 'nama_pengolah': 'PRPB'},
    {'id': 'p2', 'nama_pengolah': 'Perumahan'},
    {'id': 'p3', 'nama_pengolah': 'Permukiman'},
    {'id': 'p4', 'nama_pengolah': 'Sekretariat'},
    {'id': 'p5', 'nama_pengolah': 'UPT Taman'},
    {'id': 'p6', 'nama_pengolah': 'UPT PALD'},
    {'id': 'p7', 'nama_pengolah': 'Renvapor'},
    {'id': 'p8', 'nama_pengolah': 'UKP'},
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

  String? getNamaPengolah(
    List<String> ids,
    List<Map<String, dynamic>> listPengolah,
  ) {
    if (ids.isEmpty) return null;

    final idPertama = ids.first;
    final match = listPengolah.firstWhere(
      (e) => e['id'] == idPertama,
      orElse: () => {},
    );

    return match['nama_pengolah'];
  }

  void _loadAllData() async {
    final data = await _suratService.listSurat();

    setState(() {
      _listSurat = data;
    });
  }

  void refreshEditState() {
    _loadAllData();

    setState(() {
      // Refresh ListView setelah edit data
      // Data suratData udah diupdate di modal
    });
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
                  buildSectionTitleDisposisiDesktop('Data Surat Keluar'),
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
                                  // Table Header
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
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
                                        // No
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                            'NO',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // Kode
                                        SizedBox(width: 20),
                                        Expanded(
                                          flex: 30,
                                          child: Text(
                                            'KODE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // Klasifikasi
                                        SizedBox(width: 25),
                                        Expanded(
                                          flex: 60,
                                          child: Text(
                                            'KLASIFIKASI',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // No Register
                                        Expanded(
                                          flex: 45,
                                          child: Text(
                                            'NO REGISTER',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // Tujuan Surat
                                        Expanded(
                                          flex: 55,
                                          child: Text(
                                            'TUJUAN SURAT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // Perihal
                                        Expanded(
                                          flex: 45,
                                          child: Text(
                                            'PERIHAL',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        // Tanggal Surat
                                        SizedBox(width: 20),
                                        Expanded(
                                          flex: 30,
                                          child: Text(
                                            'TGL\nSURAT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        // Klasifikasi
                                        Expanded(
                                          flex: 90,
                                          child: Text(
                                            'KET.KLASIFIKASI \nKEAMANAN & AKSES ARSIP',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        // Pengolah
                                        Expanded(
                                          flex: 40,
                                          child: Text(
                                            'PENGOLAH',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // PEMBUAT
                                        Expanded(
                                          flex: 38,
                                          child: Text(
                                            'PEMBUAT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // Catatan
                                        Expanded(
                                          flex: 22,
                                          child: Text(
                                            'CATATAN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // link surat
                                        Expanded(
                                          flex: 70,
                                          child: Text(
                                            'link SURAT \nMASUK (JIKA ADA)',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        // Koreksi 1
                                        Expanded(
                                          flex: 30,
                                          child: Text(
                                            'KOREKSI 1',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // Koreksi 2
                                        Expanded(
                                          flex: 35,
                                          child: Text(
                                            'KOREKSI 2',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 35,
                                          child: Text(
                                            'Dokumen Dikirim',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 35,
                                          child: Text(
                                            'Dokumen Final',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 35,
                                          child: Text(
                                            'Tanda Terima',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        // Status
                                        Expanded(
                                          flex: 20,
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
                                        // Actions
                                        SizedBox(
                                          width: 80,
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: List.generate(_listSurat.length, (
                                        index,
                                      ) {
                                        final surat = _listSurat[index];

                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              // Handle row tap
                                              print(
                                                'Row tapped: ${surat?.kode}',
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4,
                                              ),
                                              child: Row(
                                                children: [
                                                  // No
                                                  SizedBox(
                                                    width: 40,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFF4F46E5,
                                                                ).withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                                Color(
                                                                  0xFF7C3AED,
                                                                ).withValues(
                                                                  alpha: 0.2,
                                                                ),
                                                              ],
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 0.2,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            '${index + 1}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Roboto',
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                  // kode
                                                  SizedBox(width: 20),
                                                  Expanded(
                                                    flex: 25,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          surat?.kode == null ? 'Data Kode Kosong' : surat!.kode,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Roboto',
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                      // Klasifikasi
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 60,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    4,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                      0xFF10B981,
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.3,
                                                                    ),
                                                                    Color(
                                                                      0xFF059669,
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
                                                          child: Icon(
                                                            Icons.label,
                                                            color: Colors.white,
                                                            size: 12,
                                                          ),
                                                        ),
                                                        SizedBox(width: 6),
                                                        Expanded(
                                                          child: Text(
                                                            surat?.klasifikasi == null ? 'Data Klasifikasi Kosong' : surat!.klasifikasi,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.8,
                                                                  ),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Roboto',
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Nomor Register
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 36,
                                                    child: Text(
                                                      surat?.no_register == null ? 'Data No Register Kosong' : surat!.no_register,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // tujuan surat
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 40,
                                                    child: Text(
                                                      surat!.tujuan_surat!,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // perihal
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 59,
                                                    child: Text(
                                                      surat?.perihal == null ? 'Data Perihal Kosong' : surat.perihal,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.clip,
                                                          textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  // tanggal surat
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 53,
                                                    child: Text(
                                                      surat?.tanggal_surat == null ? 'Data Tanggal Surat Kosong' : surat.tanggal_surat.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // klasifikasi dan arsip
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 47,
                                                    child: Text(
                                                      surat?.akses_arsip == null ? 'Data Klasifikasi Arsip Kosong' :
                                                          surat.akses_arsip,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // pengolah
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 35,
                                                    child: Text(
                                                      // getNamaPengolah(
                                                      //       (surat['pengolah']
                                                      //                   as List?)
                                                      //               ?.cast<
                                                      //                 String
                                                      //               >() ??
                                                      //           [],
                                                      //       listPengolah,
                                                      //     ) ??
                                                      //     '',
                                                      "Contoh",
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // pembuat
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 30,
                                                    child: Text(
                                                      surat.pengolah,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // catatan
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 45,
                                                    child: Text(
                                                      surat.catatan!,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // link surat
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 37,
                                                    child: Text(
                                                      surat.link_surat!,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // koreksi 1
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 27,
                                                    child: Text(
                                                      surat.koreksi_1!,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  // koreksi 2
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 27,
                                                    child: Text(
                                                      surat.dok_dikirim.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 27,
                                                    child: Text(
                                                      surat.dok_final!,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 27,
                                                    child: Text(
                                                      surat.tanda_terima.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),Expanded(
                                                    flex: 27,
                                                    child: Text(
                                                      surat.koreksi_2!,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                    ),
                                                  // Status
                                                  Expanded(
                                                    flex: 18,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      widthFactor: 1,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              getStatusColor(
                                                                surat.status!,
                                                              ),
                                                              getStatusColor(
                                                                surat.status!,
                                                              ).withValues(
                                                                alpha: 0.8,
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
                                                                    surat.status!,
                                                                  ).withValues(
                                                                    alpha: 0.3,
                                                                  ),
                                                              blurRadius: 4,
                                                              offset: Offset(
                                                                0,
                                                                1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          surat.status!,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                      // Actions
                                                      SizedBox(
                                                        width: 80,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // View button
                                                            Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                    right: 4,
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
                                                              // Handle view action
                                                              viewDetailKeluar(
                                                                context,
                                                                index,
                                                                _listSurat,
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .visibility_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 14,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          )],
          ),
        ),
      ),
    );
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
                                  'Surat Keluar',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Anda Dapat Mengatur Surat Keluar di Sini!',
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
