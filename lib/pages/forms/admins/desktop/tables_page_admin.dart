import 'package:flutter/material.dart';
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
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  bool isLoading = false;

  // User Services
  UserService _userService = UserService();
  List<UserModel> _userData = [];

  Future<void> _loadData() async {
    print("[DEBUG] -> [INFO] : Loading all data user ...");
    try {
      final data = await _userService.listUsers();
      print(data);
      setState(() {
        // _userData = data;
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

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

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

  List<Map<String, dynamic>> suratData = [
    {
      'id': '1',
      'name': 'Muhammad Annas Bintar Putra',
      'username': 'BintarKun123',
      'email': '220605110105@student.uin-malang.ac.id',
      'role': 'user',
    },
    {
      'id': '2',
      'name': 'Moch. Minanur Rahman',
      'username': 'Nanimz123',
      'email': '220605110112@student.uin-malang.ac.id',
      'role': 'user',
    },
    {
      'id': '3',
      'name': 'Muhamad Radiyudin',
      'username': 'RadiKun123',
      'email': '220605110120@student.uin-malang.ac.id',
      'role': 'user',
    },
    {
      'id': '4',
      'name': 'Anonim',
      'username': 'Anonim123',
      'email': 'anonim123@gmail.com',
      'role': 'user',
    },
  ];

  void actionSetState(int index) {
    setState(() {
      // suratData.removeAt(index);
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

    _loadData();

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
                                  MediaQuery.of(context).size.width / 2, // 240 = padding * 10
                              maxWidth:
                                  MediaQuery.of(context).size.width / 1.2,
                            ),
                            child: IntrinsicWidth(
                              child: Column(
                                children: [
                                  // Header Row
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
                                        // 1. No - flex: 1
                                        SizedBox(width: 10),
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
                        
                                        // 2. Name - flex: 200
                                        SizedBox(width: 10),
                                        Expanded(
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
                        
                                        // 3. Username - flex: 100
                                        
                                        Expanded(
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
                        
                                        // 4. Email - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
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
                        
                                        // 5. Role - flex: 100
                                        SizedBox(width: 5),
                                        Expanded(
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
                        
                                        // Actions - width: 100 (fixed)
                                        SizedBox(width: 8),
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
                                          children: List.generate(_userData.length, (
                                            index,
                                          ) {
                                            final surat = suratData[index];
                                                              
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.white.withValues(
                                                      alpha: 1,
                                                    ),
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  print(
                                                    'Row tapped: ${surat['name']}',
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
                                                      // 1. No - width: 40 (sama kayak header)
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
                                                                      alpha: 0.5,
                                                                    ),
                                                                    Color(
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
                                                                  color: Colors.white,
                                                                  width: 0.2
                                                                )
                                                          ),
                                                          child: Text(
                                                            '${index + 1}',
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontFamily: 'Roboto',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                              
                                                      // 2. name - flex: 200
                                                      SizedBox(width: 20),
                                                      Expanded(
                                                        flex: 130,
                                                        child: Text(
                                                          surat['name'] == null ? 'Nama Tidak Ditemukan' : surat['name'],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                              textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                              
                                                      // 3. username - flex: 100
                                                      SizedBox(width: 0),
                                                      Expanded(
                                                        flex: 90,
                                                        child: Text(
                                                          surat['username'] == null ?
                                                              'Username Tidak Ditemukan' : surat['username'],
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.7,
                                                                ),
                                                            fontSize: 11,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                              
                                                      // 4. email - flex: 100
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 120,
                                                        child: Text(
                                                          surat['email'] == null ? 'Email Tidak Ditemukan' : surat['email'],
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.7,
                                                                ),
                                                            fontSize: 11,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                          textAlign: TextAlign.center,
                                                          softWrap: true,
                                                          overflow: TextOverflow.clip,
                                                        ),
                                                      ),
                                                              
                                                      // 5. role - flex: 100
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 60,
                                                        child: Text(
                                                          surat['role'] == null ? 'Role Tidak Ditemukan' : surat['role'],
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.7,
                                                                ),
                                                            fontSize: 11,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      // Actions - width: 100 (sama kayak header)
                                                      SizedBox(width: 8),
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
                                                                    right: 4,
                                                                  ),
                                                              padding:
                                                                  EdgeInsets.all(6),
                                                              decoration: BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
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
                                                                  // viewDetail(
                                                                  //   context,
                                                                  //   index,
                                                                  //   suratData,
                                                                  // );
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
                                                            // Edit button
                                                            Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                    right: 4,
                                                                  ),
                                                              padding:
                                                                  EdgeInsets.all(6),
                                                              decoration: BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
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
                                                                  // editDokumen(
                                                                  //   context,
                                                                  //   index,
                                                                  //   suratData,
                                                                  //   refreshEditState,
                                                                  // );
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .edit_outlined,
                                                                  color:
                                                                      Colors.white,
                                                                  size: 14,
                                                                ),
                                                              ),
                                                            ),
                                                            // Delete button
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(6),
                                                              decoration: BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
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
                                                                  // hapusDokumen(
                                                                  //   context,
                                                                  //   index,
                                                                  //   suratData,
                                                                  //   actionSetState,
                                                                  // );
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_outline,
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
                                  'Anda Dapat Mengatur Surat Masuk di Sini!',
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
                                LineIcons.envelopeOpen,
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
