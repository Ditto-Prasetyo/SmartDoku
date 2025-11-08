import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_doku/models/user.dart';
import 'package:smart_doku/services/user.dart';
import 'package:smart_doku/utils/dialog.dart';
import 'dart:ui';
import 'package:smart_doku/utils/function.dart';
import 'package:smart_doku/utils/widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TablesPageAdmin extends StatefulWidget {
  const TablesPageAdmin({super.key});

  @override
  State<TablesPageAdmin> createState() => _TablesPageAdminState();
}

class _TablesPageAdminState extends State<TablesPageAdmin>
    with TickerProviderStateMixin {
  var height, width;
  bool isLoading = false;
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

  String? title;

  // User Services
  UserService _userService = UserService();
  List<UserModel> _userData = [];
  List<UserModel> _filteredList = [];
  List<UserModel> get _visibleList =>
      _searchController.text.trim().isEmpty ? _userData : _filteredList;

  Future<void> _loadData() async {
    print("[DEBUG] -> [INFO] : Loading all data user ...");
    try {
      print("[DEBUG] -> [STATE] : title = $title");
      final data = await (title != null
          ? _userService.getFilteredUsers(title!)
          : _userService.listUsers());
      print(data.map((e) => e.toJson()).toList());
      setState(() {
        _userData = data;
        _filteredList = List.from(data);
        isLoading = false;
      });
      print("[DEBUG] -> [STATE] : Set data to userData!");
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
  int _selectedIndex = 4;

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

  void actionSetState(String index) async {
    setState(() {
      _userService.deleteUser(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User berhasil dihapus'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void refreshState() async {
    await _loadData();
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
    _filteredList = _userData;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      setState(() {
        title = args?['title'] ?? 'Default Title';
      });

      print('[DEBUG] -> [STATE -> INIT] : title = $title');

      _loadData();
    });

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

  void _toggleSearch() {
    setState(() {
      isSearchExpanded = !isSearchExpanded;

      if (isSearchExpanded) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
        _searchController.clear();
        _filteredList = List.from(_userData);
      }
    });
  }

  int _scoreField(String? field, String q) {
    if (field == null || q.isEmpty) return 0;
    final f = field.toLowerCase();
    if (f == q) return 1000; // exact
    if (f.startsWith(q)) return 600; // prefix
    if (f.contains(q)) {
      final hits = RegExp(RegExp.escape(q)).allMatches(f).length;
      return 100 + hits * 30; // substring + bonus kemunculan
    }
    return 0;
  }

  int _scoreUser(UserModel u, String q) {
    final ql = q.toLowerCase().trim();
    int s = 0;
    // Bobot kolom: nama/email > username > role
    s += 9 * _scoreField(u.name, ql);
    s += 9 * _scoreField(u.email, ql);
    s += 7 * _scoreField(u.username, ql);
    s += 5 * _scoreField(u.role, ql);
    return s;
  }

  void _sortUsers(String q) {
    _filteredList.sort((a, b) {
      final sa = _scoreUser(a, q);
      final sb = _scoreUser(b, q);
      if (sb != sa) return sb.compareTo(sa); // skor tertinggi dulu

      // tie-breaker jika skor sama: alfabetis nama → email
      final byName = (a.name ?? '').toLowerCase().compareTo(
        (b.name ?? '').toLowerCase(),
      );
      if (byName != 0) return byName;
      return (a.email ?? '').toLowerCase().compareTo(
        (b.email ?? '').toLowerCase(),
      );
    });
  }

  void _performSearch() {
    final q = _searchController.text.toLowerCase().trim();

    setState(() {
      if (q.isEmpty) {
        _filteredList = List.from(_userData);
      } else {
        _filteredList = _userData.where((u) {
          final name = (u.name ?? '').toLowerCase();
          final email = (u.email ?? '').toLowerCase();
          final username = (u.username ?? '').toLowerCase();
          final role = (u.role ?? '').toLowerCase();
          return name.contains(q) ||
              email.contains(q) ||
              username.contains(q) ||
              role.contains(q);
        }).toList();
      }
      _sortUsers(q);
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
                  child: Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 28,
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
                  buildSectionTitleDisposisiDesktop(
                    'Data Akun Bidang ${title}',
                  ),
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
                                '${_userData.length} Data',
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
                                  tambahUser(
                                    context,
                                    title!,
                                    (newUser) {},
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
                      clipBehavior: Clip.hardEdge,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double viewport = constraints.maxWidth;
                          final double maxContentWidth = viewport * 1;
                          return Scrollbar(
                            controller: _horizontalScrollController,
                            thumbVisibility: true,
                            trackVisibility: true,
                            thickness: 8,
                            radius: const Radius.circular(4),
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: viewport),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: maxContentWidth,
                                    ),
                                    child: Column(
                                      children: [
                                        // ================== Header Row ==================
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withValues(
                                                  alpha: 0.20,
                                                ),
                                                Colors.white.withValues(
                                                  alpha: 0.10,
                                                ),
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
                                              const SizedBox(width: 50),

                                              // 1) No (fixed 40)
                                              const SizedBox(
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

                                              const SizedBox(width: 10),

                                              // 2) Name
                                              const Expanded(
                                                flex: 130,
                                                child: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              // 3) Username
                                              const Expanded(
                                                flex: 90,
                                                child: Text(
                                                  'Username',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              const SizedBox(width: 5),

                                              // 4) Email
                                              const Expanded(
                                                flex: 120,
                                                child: Text(
                                                  'Email',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              const SizedBox(width: 5),

                                              // 5) Role
                                              const Expanded(
                                                flex: 60,
                                                child: Text(
                                                  'Role',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              // 6) Aksi (fixed 100)
                                              const SizedBox(
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

                                        // ================== Body (scroll vertikal) ==================
                                        SizedBox(
                                          height: 340,
                                          child: Scrollbar(
                                            controller:
                                                _verticalScrollController,
                                            thumbVisibility: true,
                                            trackVisibility: true,
                                            thickness: 8,
                                            radius: const Radius.circular(4),
                                            child: SingleChildScrollView(
                                              controller:
                                                  _verticalScrollController,
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: _visibleList.isEmpty
                                                    ? [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 24,
                                                              ),
                                                          child: Center(
                                                            child: Text(
                                                              _searchController
                                                                      .text
                                                                      .trim()
                                                                      .isEmpty
                                                                  ? 'Belum ada data user.'
                                                                  : 'Tidak ada hasil untuk "${_searchController.text.trim()}"',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
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
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 20,
                                                                vertical: 10,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              bottom: BorderSide(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha: 1,
                                                                    ),
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              print(
                                                                'Row tapped: ${surat.name}',
                                                              );
                                                            },
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical: 4,
                                                                  ),
                                                              child: Row(
                                                                children: [
                                                                  // 1) No - fixed 40
                                                                  const SizedBox(
                                                                    width: 40,
                                                                    child: DecoratedBox(
                                                                      decoration:
                                                                          BoxDecoration(),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 40,
                                                                    child: Container(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            6,
                                                                        vertical:
                                                                            2,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                          colors: [
                                                                            const Color(
                                                                              0xFF4F46E5,
                                                                            ).withValues(
                                                                              alpha: 0.5,
                                                                            ),
                                                                            const Color(
                                                                              0xFF7C3AED,
                                                                            ).withValues(
                                                                              alpha: 0.3,
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
                                                                          width:
                                                                              0.2,
                                                                        ),
                                                                      ),
                                                                      child: Text(
                                                                        '${index + 1}',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: const TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontFamily:
                                                                              'Roboto',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),

                                                                  // 2) Name
                                                                  Expanded(
                                                                    flex: 130,
                                                                    child: Text(
                                                                      surat.name ==
                                                                              null
                                                                          ? 'Nama Tidak Ditemukan'
                                                                          : surat.name,
                                                                      style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            'Roboto',
                                                                      ),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),

                                                                  // 3) Username
                                                                  const SizedBox(
                                                                    width: 0,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 90,
                                                                    child: Text(
                                                                      surat.username ==
                                                                              null
                                                                          ? 'Username Tidak Ditemukan'
                                                                          : surat.username,
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white
                                                                            .withValues(
                                                                              alpha: 0.7,
                                                                            ),
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'Roboto',
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),

                                                                  // 4) Email
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 120,
                                                                    child: Text(
                                                                      surat.email ==
                                                                              null
                                                                          ? 'Email Tidak Ditemukan'
                                                                          : surat.email,
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white
                                                                            .withValues(
                                                                              alpha: 0.7,
                                                                            ),
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'Roboto',
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      softWrap:
                                                                          true,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  ),

                                                                  // 5) Role
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 60,
                                                                    child: Text(
                                                                      surat.role ==
                                                                              null
                                                                          ? 'Role Tidak Ditemukan'
                                                                          : surat.role,
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white
                                                                            .withValues(
                                                                              alpha: 0.7,
                                                                            ),
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'Roboto',
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),

                                                                  // Actions - fixed 100
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        // View
                                                                        Container(
                                                                          margin: const EdgeInsets.only(
                                                                            right:
                                                                                4,
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(
                                                                                6,
                                                                              ),
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              colors: [
                                                                                const Color(
                                                                                  0xFF3B82F6,
                                                                                ).withValues(
                                                                                  alpha: 0.3,
                                                                                ),
                                                                                const Color(
                                                                                  0xFF1D4ED8,
                                                                                ).withValues(
                                                                                  alpha: 0.2,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              6,
                                                                            ),
                                                                          ),
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              viewDetailUserManagement(
                                                                                context,
                                                                                index,
                                                                                _userData,
                                                                              );
                                                                            },
                                                                            child: const Icon(
                                                                              Icons.visibility_outlined,
                                                                              color: Colors.white,
                                                                              size: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        // Edit
                                                                        Container(
                                                                          margin: const EdgeInsets.only(
                                                                            right:
                                                                                4,
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(
                                                                                6,
                                                                              ),
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              colors: [
                                                                                const Color(
                                                                                  0xFFF59E0B,
                                                                                ).withValues(
                                                                                  alpha: 0.3,
                                                                                ),
                                                                                const Color(
                                                                                  0xFFD97706,
                                                                                ).withValues(
                                                                                  alpha: 0.2,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              6,
                                                                            ),
                                                                          ),
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              editUserManagement(
                                                                                context,
                                                                                index,
                                                                                _userData,
                                                                                refreshState,
                                                                              );
                                                                            },
                                                                            child: const Icon(
                                                                              Icons.edit_outlined,
                                                                              color: Colors.white,
                                                                              size: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        // Delete
                                                                        Container(
                                                                          padding:
                                                                              const EdgeInsets.all(
                                                                                6,
                                                                              ),
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              colors: [
                                                                                const Color(
                                                                                  0xFFEF4444,
                                                                                ).withValues(
                                                                                  alpha: 0.3,
                                                                                ),
                                                                                const Color(
                                                                                  0xFFDC2626,
                                                                                ).withValues(
                                                                                  alpha: 0.2,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              6,
                                                                            ),
                                                                          ),
                                                                          child: InkWell(
                                                                            onTap: () {
                                                                              hapusUserDesktop(
                                                                                context,
                                                                                index,
                                                                                _userData,
                                                                                actionSetState,
                                                                                refreshState,
                                                                              );
                                                                            },
                                                                            child: const Icon(
                                                                              Icons.delete_outline,
                                                                              color: Colors.white,
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
                                        ),
                                      ],
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
                                  'Manajemen Pengguna',
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
                                      'Anda Dapat Mengatur Data Pengguna di Sini!',
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
                                                        'Cari nama, email, username...',
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
