import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/user.dart';
import 'package:smart_doku/services/surat.dart';
import 'package:smart_doku/services/user.dart';
import 'dart:ui';
import 'package:smart_doku/utils/handlers/function.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_doku/services/bookmarks.dart' as bk;

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with TickerProviderStateMixin {
  var height, width;
  bool _expandedMasuk = false;
  bool _expandedKeluar = false;
  bool _loadingBookmarks = true;

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // Selected sidebar item
  int _selectedIndex = 0;
  static const int _defaultLimit = 5;

  // Sample data for dashboard
  List<Map<String, dynamic>> _statsData = [];
  List<bk.BookmarkItem> _bookmarks = [];
  List<bk.BookmarkItem> _bmMasuk = [];
  List<bk.BookmarkItem> _bmKeluar = [];
  List<bk.BookmarkItem> _bmLainnya = [];
  UserService _userService = UserService();
  UserModel? _user;

  StatService _statService = StatService();

  int? totalSuratMasuk;
  int? totalSuratKeluar;

  Future<void> _loadAllData() async {
    final suratMasuk = await _statService.getSuratMasuk();
    final SuratKeluar = await _statService.getSuratKeluar();

    if (!mounted) return;

    setState(() {
      totalSuratMasuk = suratMasuk['total'];
      totalSuratKeluar = SuratKeluar['total'];

      // Sample data for dashboard
      _statsData = [
        {
          'title': 'Total Surat Masuk',
          'value': totalSuratMasuk,
          'icon': LineIcons.envelopeOpen,
          'color': Color(0xFF4F46E5),
          'isPositive': true,
        },
        {
          'title': 'Surat Keluar',
          'value': totalSuratKeluar,
          'icon': FontAwesomeIcons.envelopeCircleCheck,
          'color': Color(0xFF059669),
          'isPositive': true,
        },
      ];
    });
  }

  void _loadUser() async {
    final user = await _userService.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      print(_user?.name);
    });
  }

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

  Future<void> _loadBookmarkUiPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _expandedMasuk = prefs.getBool('bm_masuk_expanded') ?? false;
      _expandedKeluar = prefs.getBool('bm_keluar_expanded') ?? false;
    });
  }

  Future<void> _saveBookmarkUiPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bm_masuk_expanded', _expandedMasuk);
    await prefs.setBool('bm_keluar_expanded', _expandedKeluar);
  }

  Future<void> _loadBookmarks() async {
    if (!mounted) return;
    setState(() => _loadingBookmarks = true);
    try {
      await bk.Bookmarks.normalize(); // beresin format lama + dedup
      final items = await bk.Bookmarks.list(); // udah typed & bersih

      final masuk = <bk.BookmarkItem>[];
      final keluar = <bk.BookmarkItem>[];
      final lainnya = <bk.BookmarkItem>[];

      for (final b in items) {
        switch ((b.type ?? '').toLowerCase()) {
          case 'surat_masuk':
            masuk.add(b);
            break;
          case 'surat_keluar':
            keluar.add(b);
            break;
          default:
            lainnya.add(b);
        }
      }
      if (!mounted) return;

      setState(() {
        _bookmarks = items;
        _bmMasuk = masuk;
        _bmKeluar = keluar;
        _bmLainnya = lainnya;
      });
    } finally {
      if (mounted) setState(() => _loadingBookmarks = false);
    }
  }

  Future<void> _removeBookmark(String id) async {
    await bk.Bookmarks.normalize();
    await bk.Bookmarks.removeById(id);

    if (!mounted) return;
    await _loadBookmarks(); // refresh section Masuk/Keluar

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Dihapus dari Favorit')));
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadAllData();
    _loadBookmarks();

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
                    onTap: () => logout(context),
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

  Widget _buildStatsCard(Map<String, dynamic> data, int index) {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _cardAnimation.value)),
          child: Opacity(
            opacity: _cardAnimation.value.clamp(0.0, 1.0),
            child: InkWell(
              onTap: () {
                switch (index) {
                  case 0:
                    Navigator.pushNamed(
                      context,
                      '/user/desktop/surat_permohonan_page_desktop',
                    );
                    break;
                  case 1:
                    Navigator.pushNamed(
                      context,
                      '/user/desktop/surat_keluar_page_desktop',
                    );
                    break;
                  default:
                    Navigator.pushNamed(
                      context,
                      '/admin/desktop/home_page_admin_desktop',
                    );
                }
              },
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    data['color'],
                                    data['color'].withValues(alpha: 0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: data['color'].withValues(alpha: 0.7),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                data['icon'],
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            data['value'].toString(),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            data['title'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
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
        );
      },
    );
  }

  Widget _buildBookmarksPanel(Animation<double> anim) {
    return Transform.translate(
      offset: Offset(0, 50 * (1 - anim.value)),
      child: Opacity(
        opacity: anim.value.clamp(0.0, 1.0),
        child: _glassCard(
          title: 'Favorit Saya',
          child: _loadingBookmarks
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Surat Masuk
                    _sectionList(
                      title: 'Surat Masuk',
                      items: _bmMasuk,
                      expanded: _expandedMasuk,
                      onToggle: () {
                        setState(() => _expandedMasuk = !_expandedMasuk);
                        _saveBookmarkUiPrefs();
                      },
                    ),

                    // Surat Keluar
                    _sectionList(
                      title: 'Surat Keluar',
                      items: _bmKeluar,
                      expanded: _expandedKeluar,
                      onToggle: () {
                        setState(() => _expandedKeluar = !_expandedKeluar);
                        _saveBookmarkUiPrefs();
                      },
                    ),

                    // (opsional) Lainnya
                    if (_bmLainnya.isNotEmpty)
                      _sectionList(
                        title: 'Lainnya',
                        items: _bmLainnya,
                        expanded: true, // biasanya biarin selalu kebuka
                        onToggle: () {},
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _glassCard({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.20),
            Colors.white.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Text(
              '$count',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionList({
    required String title,
    required List<bk.BookmarkItem> items,
    required bool expanded,
    required VoidCallback onToggle,
  }) {
    final limit = expanded ? items.length : _defaultLimit;
    final shown = items.take(limit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header kecil + badge jumlah
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Text(
                  '${items.length}',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              const Spacer(),
              if (items.length > _defaultLimit)
                TextButton.icon(
                  onPressed: onToggle,
                  icon: Icon(
                    expanded ? Icons.unfold_less : Icons.unfold_more,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    expanded ? 'Tutup' : 'Lihat semua (${items.length})',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),

        // isi
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Belum ada $title yang di-pin',
              style: TextStyle(color: Colors.white70),
            ),
          )
        else
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Column(children: shown.map(_bookmarkTile).toList()),
          ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _bookmarkTile(bk.BookmarkItem b) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(
            b.type == 'surat_keluar'
                ? FontAwesomeIcons.envelopeCircleCheck
                : LineIcons.envelopeOpen,
            size: 18,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (b.savedAt != null || b.type != null)
                  Text(
                    [
                      if (b.type != null)
                        (b.type == 'surat_keluar'
                            ? 'Surat Keluar'
                            : 'Surat Masuk'),
                      if (b.savedAt != null) _fmt(b.savedAt!),
                    ].join(' • '),
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
          if (b.route != null)
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, b.route!),
              icon: Icon(Icons.open_in_new, size: 16, color: Colors.white),
              label: Text('Buka', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
            ),
          IconButton(
            tooltip: 'Hapus Pin',
            onPressed: () => _removeBookmark(b.id),
            icon: Icon(Icons.close_rounded, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
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
                                  'Dashboard User',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Selamat datang kembali, ',
                                      ),
                                      TextSpan(
                                        text: '${_user?.username ?? '-'}!',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        // Stats cards
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1.2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                              ),
                          itemCount: _statsData.length,
                          itemBuilder: (context, index) {
                            return _buildStatsCard(_statsData[index], index);
                          },
                        ),

                        SizedBox(height: 40),

                        // Bookmark
                        _buildBookmarksPanel(_cardAnimation),
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
