import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/services/surat.dart';
import 'package:smart_doku/services/user.dart';
import 'dart:ui';
import 'dart:io';
import 'package:smart_doku/utils/handlers/dialog.dart';
import 'package:smart_doku/utils/handlers/function.dart';
import 'package:smart_doku/utils/handlers/dateparser.dart';
import 'package:smart_doku/utils/helper/map.dart';
import 'package:smart_doku/utils/search/SuratKeluarFunction.dart';
import 'package:smart_doku/utils/widget/widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OutgoingLetterPageAdminDesktop extends StatefulWidget {
  const OutgoingLetterPageAdminDesktop({Key? key}) : super(key: key);

  @override
  State<OutgoingLetterPageAdminDesktop> createState() =>
      _OutgoingLetterPageAdminDesktopState();
}

class _OutgoingLetterPageAdminDesktopState
    extends State<OutgoingLetterPageAdminDesktop>
    with TickerProviderStateMixin {
  var height, width;
  bool isLoading = true;
  bool isSearchExpanded = false;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  FocusNode _searchFocusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

  SuratKeluar _suratService = SuratKeluar();
  UserService _userService = UserService();
  List<SuratKeluarModel?> _listSurat = [];
  List<SuratKeluarModel?> _filteredList = [];
  List<SuratKeluarModel?> get _visibleList =>
      _searchController.text.trim().isEmpty ? _listSurat : _filteredList;

  // Selected sidebar item
  int _selectedIndex = 2;

  final List<Map<String, dynamic>> _sidebarItems = [
    {
      'icon': Icons.dashboard_rounded,
      'title': 'Dashboard',
      'route': '/admin/desktop/home_page_admin_desktop',
    },
    {
      'icon': LineIcons.envelopeOpen,
      'title': 'Surat Masuk',
      'route': '/admin/desktop/surat_permohonan_page_admin_desktop',
    },
    {
      'icon': FontAwesomeIcons.envelopeCircleCheck,
      'title': 'Surat Keluar',
      'route': '/admin/desktop/surat_keluar_page_admin_desktop',
    },
    {
      'icon': Icons.assignment_turned_in_rounded,
      'title': 'Disposisi',
      'route': '/admin/desktop/surat_disposisi_page_admin_desktop',
    },
    {
      'icon': Icons.people_outline_rounded,
      'title': 'Manajemen Pengguna',
      'route': '/admin/desktop/manajemen_pengguna_page',
    },
    {
      'icon': Icons.settings_outlined,
      'title': 'Pengaturan',
      'route': '/admin/desktop/setting_page',
    },
    {
      'icon': Icons.people_alt_rounded,
      'title': 'Profile Anda',
      'route': '/admin/desktop/profile_admin_page',
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

  Future<void> actionSetState(int nomorUrut) async {
  try {
    // 1. Hapus dulu di backend
    await _suratService.deleteSurat(nomorUrut);

    // 2. Reload data dari server
    await _loadAllData(); // ini sudah punya setState sendiri

    // optional: kalau mau ada debug
    print('[DEBUG] Surat keluar dengan nomorUrut $nomorUrut berhasil dihapus dan data di-reload');
  } catch (e) {
    print('[ERROR] Gagal menghapus surat: $e');
    if (!mounted) return;
    // di sini lo bisa show dialog / snackbar error juga
  }
}


  Future<void> _loadAllData() async {
    print("[DEBUG] -> [INFO] : Loading all data surat masuk ...");
    try {
      final disposisi = await _userService.getDisposisi();
      final mappedDisposisi = workFields.entries
          .firstWhere(
            (e) => e.value == disposisi,
            orElse: () => const MapEntry('Tidak Diketahui', 'Unknown'),
          )
          .key;
      final isSU = await _userService.getSuperAdminStatus();
      print("[DEBUG] -> [STATE] :: SU Status : $isSU");
      final data = disposisi != null
          ? await _suratService.getFilteredListSurat(mappedDisposisi, isSU)
          : await _suratService.listSurat();
      if (!mounted) return;
      setState(() {
        _listSurat = data;
        _filteredList = List.from(data);
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

  String limitFileNameWords(String fileName, int maxWords) {
    final parts = fileName.split('.');
    final ext = parts.length > 1 ? parts.last : '';
    final name = parts.first.replaceAll("_", " ").replaceAll("-", " ");

    final words = name.split(" ");
    final limited = (words.length <= maxWords)
        ? name
        : words.sublist(0, maxWords).join(" ") + "...";

    return ext.isEmpty ? limited : "$limited.$ext";
  }

  void refreshState() async {
    await _loadAllData();
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
    _filteredList = _listSurat;

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

    _searchAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
    _searchController.addListener(_performSearch);

    _backgroundController.repeat(reverse: true);
    _cardController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _searchAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final q = _searchController.text;
    final result = SuratKeluarSearch.filterAndSort(_listSurat, q);
    setState(() {
      _filteredList = result;
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearchExpanded = !isSearchExpanded;

      if (isSearchExpanded) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
        _searchController.clear();
        _filteredList = List.from(_listSurat);
      }
    });
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
          // Header
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
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset(
                          'images/logoApps.png',
                          color: Colors.white,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
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
                        'Admin Panel',
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

          // Credit Section
          Padding(
            padding: EdgeInsets.only(top: 40, bottom: 10),
            child: Text(
              'Created by PKL UIN Malang @ 2025',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableDataLetters(Animation<double> _cardAnimation) {
    final isSearching = _searchController.text.trim().isNotEmpty;
    final count = isSearching ? _filteredList.length : _listSurat.length;
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
                  buildSectionTitleDisposisiDesktop('Data Surat '),
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
                              colors: [
                                Color(0xFF10B981).withValues(alpha: 0.3),
                                Color(0xFF059669).withValues(alpha: 0.2),
                              ],
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
                                '${_listSurat.length} data',
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
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF10B981).withValues(alpha: 0.3),
                                Color(0xFF059669).withValues(alpha: 0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  tambahSuratKeluarDesktop(
                                    context,
                                    _listSurat,
                                    (newSurat) {},
                                    refreshState,
                                  );
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 24,
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
                                          flex: flexSuratKeluar[0],
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
                                          flex: flexSuratKeluar[1],
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
                                          flex: flexSuratKeluar[2],
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
                                          flex: flexSuratKeluar[3],
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
                                          flex: flexSuratKeluar[4],
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
                                        Expanded(
                                          flex: flexSuratKeluar[5],
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
                                          flex: flexSuratKeluar[6],
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
                                          flex: flexSuratKeluar[7],
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
                                          flex: flexSuratKeluar[8],
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
                                          flex: flexSuratKeluar[9],
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
                                          flex: flexSuratKeluar[10],
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
                                          flex: flexSuratKeluar[11],
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
                                          flex: flexSuratKeluar[12],
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
                                          flex: flexSuratKeluar[13],
                                          child: Text(
                                            'Dokumen \nDikirim',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: flexSuratKeluar[14],
                                          child: Text(
                                            'Dokumen \nFinal',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: flexSuratKeluar[15],
                                          child: Text(
                                            'Tanda \nTerima',
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
                                          flex: flexSuratKeluar[16],
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
                                        children: isLoading
                                            ? [
                                                // if it still loaing
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 40,
                                                  ),
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            Colors.greenAccent,
                                                      ),
                                                ),
                                              ]
                                            : _visibleList.isEmpty
                                            ? [
                                                // if empty
                                                Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
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
                                            : List.generate(_visibleList.length, (
                                                index,
                                              ) {
                                                final surat =
                                                    _visibleList[index];
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
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
                                                      // Handle row tap
                                                      print(
                                                        'Row tapped: ${surat?.kode}',
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
                                                          // No
                                                          SizedBox(
                                                            width: 40,
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical: 2,
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
                                                          SizedBox(width: 30),
                                                          Expanded(
                                                            flex: 30,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  surat?.kode ??
                                                                      '',
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
                                                              ],
                                                            ),
                                                          ),

                                                          // Klasifikasi
                                                          Expanded(
                                                            flex: 40,
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
                                                                    color: Colors
                                                                        .white,
                                                                    size: 12,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    surat?.klasifikasi ??
                                                                        '',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white
                                                                          .withValues(
                                                                            alpha:
                                                                                0.8,
                                                                          ),
                                                                      fontSize:
                                                                          12,
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
                                                            flex: 53,
                                                            child: Text(
                                                              surat?.no_register ??
                                                                  '',
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
                                                          // tujuan surat
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 52,
                                                            child: Text(
                                                              surat?.tujuan_surat ==
                                                                      null
                                                                  ? 'Tidak Ada'
                                                                  : surat!
                                                                        .tujuan_surat!,
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
                                                          // perihal
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 40,
                                                            child: Text(
                                                              surat?.perihal ??
                                                                  '',
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
                                                                      .clip,
                                                            ),
                                                          ),
                                                          // tanggal surat
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 53,
                                                            child: Text(
                                                              surat?.tanggal_surat ==
                                                                      null
                                                                  ? '-'
                                                                  : parseDateFormat(
                                                                      surat!
                                                                          .tanggal_surat,
                                                                    ),
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
                                                          // klasifikasi dan arsip
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 50,
                                                            child: Text(
                                                              surat?.akses_arsip ??
                                                                  '',
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
                                                              surat?.pengolah ??
                                                                  '',
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
                                                          // pembuat
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 31,
                                                            child: Text(
                                                              surat?.pembuat ??
                                                                  '',
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
                                                          // catatan
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 40,
                                                            child: Text(
                                                              surat?.catatan ==
                                                                      null
                                                                  ? "-"
                                                                  : surat!
                                                                        .catatan!,
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
                                                          // link surat
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 38,
                                                            child: Text(
                                                              surat?.link_surat ==
                                                                      null
                                                                  ? "-"
                                                                  : surat!
                                                                        .link_surat!,
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
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          // koreksi 1
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 28,
                                                            child: Text(
                                                              surat?.koreksi_1 ==
                                                                      null
                                                                  ? "-"
                                                                  : surat!
                                                                        .koreksi_1!,
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
                                                          // koreksi 2
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 20,
                                                            child: Text(
                                                              surat?.koreksi_2 ==
                                                                      null
                                                                  ? "-"
                                                                  : surat!
                                                                        .koreksi_2!,
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
                                                          SizedBox(width: 5),
                                                          Expanded(
                                                            flex: 34,
                                                            child: Text(
                                                              surat?.dok_dikirim ==
                                                                      null
                                                                  ? "-"
                                                                  : parseDateFormat(
                                                                      surat!
                                                                          .dok_dikirim!,
                                                                    ),
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
                                                          Expanded(
                                                            flex: 28,
                                                            child: Text(
                                                              surat?.dok_final ==
                                                                      null
                                                                  ? "-"
                                                                  : limitFileNameWords(
                                                                      surat!
                                                                          .dok_final!,
                                                                      1,
                                                                    ),
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
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 28,
                                                            child: Text(
                                                              surat?.tanda_terima ==
                                                                      null
                                                                  ? "-"
                                                                  : parseDateFormat(
                                                                      surat!
                                                                          .tanda_terima!,
                                                                    ),
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          // Status
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            flex: 14,
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
                                                                        12,
                                                                      ),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color:
                                                                          getStatusColor(
                                                                            surat.status!,
                                                                          ).withValues(
                                                                            alpha:
                                                                                0.3,
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
                                                                  surat.status!,
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

                                                          // Actions
                                                          SizedBox(width: 20),
                                                          SizedBox(
                                                            width: 120,
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
                                                                      // Handle view action
                                                                      viewDetailKeluar(
                                                                        context,
                                                                        index,
                                                                        _filteredList,
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .visibility_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // download file button
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
                                                                          0xFF4CAF50,
                                                                        ).withValues(
                                                                          alpha:
                                                                              0.3,
                                                                        ),
                                                                        Color(
                                                                          0xFF43A047,
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
                                                                    onTap: () async {
                                                                      // Validasi cepat sebelum haptic
                                                                      if (surat ==
                                                                              null ||
                                                                          surat.dok_final ==
                                                                              null ||
                                                                          surat
                                                                              .dok_final!
                                                                              .isEmpty) {
                                                                        // Show warning
                                                                        ScaffoldMessenger.of(
                                                                          context,
                                                                        ).showSnackBar(
                                                                          SnackBar(
                                                                            content: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.warning_amber_rounded,
                                                                                  color: Colors.white,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(
                                                                                  'File tidak tersedia untuk diunduh',
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            backgroundColor:
                                                                                Colors.orange.shade700,
                                                                            behavior:
                                                                                SnackBarBehavior.floating,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                            ),
                                                                            duration: Duration(
                                                                              seconds: 2,
                                                                            ),
                                                                          ),
                                                                        );
                                                                        return;
                                                                      }

                                                                      // Call download function
                                                                      await DownloadDokumenAdminKeluar(
                                                                        context,
                                                                        index,
                                                                        surat!,
                                                                        refreshState,
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .download,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // Edit button
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
                                                                          0xFFF59E0B,
                                                                        ).withValues(
                                                                          alpha:
                                                                              0.3,
                                                                        ),
                                                                        Color(
                                                                          0xFFD97706,
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
                                                                      // Handle edit action
                                                                      editDokumenAdminKeluar(
                                                                        context,
                                                                        index,
                                                                        _listSurat,
                                                                        refreshState,
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .edit_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // Delete button
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        6,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                      colors: [
                                                                        Color(
                                                                          0xFFEF4444,
                                                                        ).withValues(
                                                                          alpha:
                                                                              0.3,
                                                                        ),
                                                                        Color(
                                                                          0xFFDC2626,
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
                                                                      // Handle delete action
                                                                      hapusDokumenKeluarDesktop(
                                                                        context,
                                                                        index,
                                                                        _listSurat,
                                                                        actionSetState,
                                                                        refreshState,
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .delete_outline,
                                                                      color: Colors
                                                                          .white,
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
              ),
            ],
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
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Surat Keluar',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Anda Dapat Mengatur Surat Keluar di Sini!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    if (_searchController.text.isNotEmpty) ...[
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(
                                                0xFF4F46E5,
                                              ).withValues(alpha: 0.3),
                                              const Color(
                                                0xFF7C3AED,
                                              ).withValues(alpha: 0.2),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          '${_filteredList.length} hasil',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOutCubic,
                                  width: isSearchExpanded ? 450 : 0,
                                  height: 48,
                                  child: isSearchExpanded
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                            right: 16,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white.withValues(
                                                  alpha: 0.25,
                                                ),
                                                Colors.white.withValues(
                                                  alpha: 0.15,
                                                ),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.35,
                                              ),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF4F46E5,
                                                ).withValues(alpha: 0.2),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.search,
                                                color: Colors.white.withValues(
                                                  alpha: 0.6,
                                                ),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: TextField(
                                                  controller: _searchController,
                                                  focusNode: _searchFocusNode,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Cari kode, klasifikasi, no register...',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                      fontSize: 14,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                  ),
                                                  onChanged: (value) =>
                                                      setState(() {}),
                                                ),
                                              ),
                                              if (_searchController
                                                  .text
                                                  .isNotEmpty)
                                                InkWell(
                                                  onTap: () {
                                                    _searchController.clear();
                                                    _searchFocusNode
                                                        .requestFocus();
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                InkWell(
                                  onTap: _toggleSearch,
                                  borderRadius: BorderRadius.circular(15),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isSearchExpanded
                                            ? [
                                                const Color(0xFFEF4444),
                                                const Color(0xFFDC2626),
                                              ]
                                            : [
                                                const Color(0xFF4F46E5),
                                                const Color(0xFF7C3AED),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              (isSearchExpanded
                                                      ? const Color(0xFFEF4444)
                                                      : const Color(0xFF4F46E5))
                                                  .withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isSearchExpanded
                                          ? Icons.close
                                          : LineIcons.search,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

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
