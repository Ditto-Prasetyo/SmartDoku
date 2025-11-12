import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_doku/models/user.dart';
import 'package:smart_doku/services/surat.dart';
import 'package:smart_doku/services/user.dart';
import 'package:smart_doku/services/logs.dart'; // TAMBAH INI
import 'dart:ui';
import 'package:smart_doku/utils/handlers/function.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart'; // TAMBAH INI untuk format waktu

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  var height, width;

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // Selected sidebar item
  int _selectedIndex = 0;

  List<Map<String, dynamic>> _statsData = [];
  StatService _statService = StatService();
  
  // TAMBAH INI
  LogService _logService = LogService();
  List<dynamic> _recentLogs = [];
  bool _isLoadingLogs = true;

  UserService _userService = UserService();
  UserModel? _user;

  int? totalUsers;
  int? totalSuratMasuk;
  int? totalSuratKeluar;
  int? totalDisposisi;

  Future<void> _loadAllData() async {
    final users = await _statService.getUsers();
    final suratMasuk = await _statService.getSuratMasuk();
    final SuratKeluar = await _statService.getSuratKeluar();
    final disposisi = await _statService.getDisposisi();

    setState(() {
      totalUsers = users['totalUsers'];
      totalSuratMasuk = suratMasuk['total'];
      totalSuratKeluar = SuratKeluar['total'];
      totalDisposisi = disposisi['total'];

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
        {
          'title': 'Total Pengguna',
          'value': totalUsers ?? 0,
          'icon': Icons.people_outline_rounded,
          'color': Color(0xFF7C2D12),
          'isPositive': true,
        },
        {
          'title': 'Total Bidang',
          'value': totalDisposisi ?? 0,
          'icon': Icons.work_rounded,
          'color': Colors.lightBlue,
          'isPositive': true,
        },
      ];
    });
  }

  // TAMBAH FUNGSI INI
  Future<void> _loadLogs() async {
    try {
      setState(() {
        _isLoadingLogs = true;
      });
      
      final logs = await _logService.getLogs(limit: 5);
      
      setState(() {
        _recentLogs = logs;
        _isLoadingLogs = false;
      });
    } catch (e) {
      print('Error loading logs: $e');
      setState(() {
        _isLoadingLogs = false;
      });
    }
  }

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

  void _loadUser() async {
    final user = await _userService.getCurrentUser();
    setState(() {
      _user = user;
      print(_user?.name);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _loadUser();
    _loadLogs(); // TAMBAH INI

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
                      '/admin/desktop/surat_permohonan_page_admin_desktop',
                    );
                    break;
                  case 1:
                    Navigator.pushNamed(
                      context,
                      '/admin/desktop/surat_keluar_page_admin_desktop',
                    );
                    break;
                  case 2:
                    Navigator.pushNamed(
                      context,
                      '/admin/desktop/manajemen_pengguna_page',
                    );
                    break;
                  case 3:
                    Navigator.pushNamed(
                      context,
                      '/admin/desktop/manajemen_pengguna_page',
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

  // FUNGSI INI DIGANTI SEPENUHNYA
  Widget _buildRecentActivity(Animation<double> _cardAnimation) {
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
            boxShadow: [
              BoxShadow(
                color: Colors.white.withAlpha(25),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aktivitas Terbaru',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  if (_isLoadingLogs)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: _isLoadingLogs
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : _recentLogs.isEmpty
                        ? Center(
                            child: Text(
                              'Belum ada aktivitas',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontFamily: 'Roboto',
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _recentLogs.length,
                            itemBuilder: (context, index) {
                              final log = _recentLogs[index];
                              
                              // Parse data dari API
                              final action = log['action'] ?? 'unknown';
                              final rawDescription = log['description'] ?? '';
                              final username = log['username'] ?? 'Unknown';
                              final timestamp = log['timestamp'] ?? '';
                              
                              // Generate description dan icon/color yang lebih spesifik
                              final activityData = _parseLogActivity(action, rawDescription, username);
                              
                              final description = activityData['description'];
                              final icon = activityData['icon'];
                              final color = activityData['color'];
                              
                              // Format waktu dengan lebih user-friendly
                              String formattedTime = _formatTimestamp(timestamp);

                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withAlpha(64),
                                      Colors.white.withAlpha(25),
                                      Colors.white.withAlpha(12),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: color.withAlpha(200),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: color.withAlpha(150),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        icon,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                size: 12,
                                                color: Colors.white.withValues(alpha: 0.7),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                username,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white.withValues(alpha: 0.7),
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(
                                                Icons.access_time,
                                                size: 12,
                                                color: Colors.white.withValues(alpha: 0.7),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                formattedTime,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white.withValues(alpha: 0.7),
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAMBAH HELPER FUNCTION INI
  Map<String, dynamic> _parseLogActivity(String action, String rawDescription, String username) {
    String description = rawDescription;
    IconData icon = Icons.info_outline_rounded;
    Color color = Color(0xFF6B7280);
    
    final actionLower = action.toLowerCase();
    
    // === SURAT MASUK ===
    if (actionLower.contains('surat_masuk') || actionLower.contains('suratmasuk')) {
      if (actionLower.contains('create') || actionLower.contains('tambah')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menambahkan surat masuk baru';
        icon = LineIcons.envelopeOpen;
        color = Color(0xFF4F46E5);
      } else if (actionLower.contains('update') || actionLower.contains('edit')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Mengupdate data surat masuk';
        icon = LineIcons.edit;
        color = Color(0xFF4F46E5);
      } else if (actionLower.contains('delete') || actionLower.contains('hapus')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menghapus surat masuk';
        icon = Icons.delete_outline;
        color = Color(0xFFDC2626);
      } else if (actionLower.contains('view') || actionLower.contains('read')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Membaca detail surat masuk';
        icon = Icons.visibility_outlined;
        color = Color(0xFF4F46E5);
      }
    }
    
    // === SURAT KELUAR ===
    else if (actionLower.contains('surat_keluar') || actionLower.contains('suratkeluar')) {
      if (actionLower.contains('create') || actionLower.contains('tambah')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Membuat surat keluar baru';
        icon = FontAwesomeIcons.envelopeCircleCheck;
        color = Color(0xFF059669);
      } else if (actionLower.contains('update') || actionLower.contains('edit')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Mengupdate data surat keluar';
        icon = Icons.edit_outlined;
        color = Color(0xFF059669);
      } else if (actionLower.contains('delete') || actionLower.contains('hapus')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menghapus surat keluar';
        icon = Icons.delete_outline;
        color = Color(0xFFDC2626);
      } else if (actionLower.contains('send') || actionLower.contains('kirim')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Mengirim surat keluar';
        icon = Icons.send_rounded;
        color = Color(0xFF059669);
      }
    }
    
    // === DISPOSISI ===
    else if (actionLower.contains('disposisi')) {
      if (actionLower.contains('create') || actionLower.contains('tambah')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Membuat disposisi surat';
        icon = Icons.assignment_turned_in_rounded;
        color = Colors.lightBlue;
      } else if (actionLower.contains('update') || actionLower.contains('edit')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Mengupdate disposisi';
        icon = Icons.edit_note_rounded;
        color = Colors.lightBlue;
      } else if (actionLower.contains('forward') || actionLower.contains('teruskan')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Meneruskan disposisi ke bidang';
        icon = Icons.forward_rounded;
        color = Colors.lightBlue;
      } else if (actionLower.contains('approve') || actionLower.contains('setuju')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menyetujui disposisi';
        icon = Icons.check_circle_outline;
        color = Color(0xFF059669);
      } else if (actionLower.contains('reject') || actionLower.contains('tolak')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menolak disposisi';
        icon = Icons.cancel_outlined;
        color = Color(0xFFDC2626);
      }
    }
    
    // === USER MANAGEMENT ===
    else if (actionLower.contains('user') || actionLower.contains('pengguna')) {
      if (actionLower.contains('create') || actionLower.contains('tambah') || actionLower.contains('register')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menambahkan pengguna baru';
        icon = Icons.person_add_rounded;
        color = Color(0xFF7C2D12);
      } else if (actionLower.contains('update') || actionLower.contains('edit')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Mengupdate data pengguna';
        icon = Icons.edit_outlined;
        color = Color(0xFF7C2D12);
      } else if (actionLower.contains('delete') || actionLower.contains('hapus')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menghapus pengguna';
        icon = Icons.person_remove_rounded;
        color = Color(0xFFDC2626);
      } else if (actionLower.contains('activate') || actionLower.contains('aktifkan')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Mengaktifkan akun pengguna';
        icon = Icons.check_circle_outline;
        color = Color(0xFF059669);
      } else if (actionLower.contains('deactivate') || actionLower.contains('nonaktifkan')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menonaktifkan akun pengguna';
        icon = Icons.block_rounded;
        color = Color(0xFFDC2626);
      }
    }
    
    // === AUTHENTICATION ===
    else if (actionLower.contains('login') || actionLower.contains('masuk')) {
      description = rawDescription.isNotEmpty 
          ? rawDescription 
          : '$username berhasil login';
      icon = Icons.login_rounded;
      color = Color(0xFF059669);
    }
    else if (actionLower.contains('logout') || actionLower.contains('keluar')) {
      description = rawDescription.isNotEmpty 
          ? rawDescription 
          : '$username telah logout';
      icon = Icons.logout_rounded;
      color = Color(0xFF6B7280);
    }
    
    // === BIDANG / DEPARTEMEN ===
    else if (actionLower.contains('bidang') || actionLower.contains('departemen') || actionLower.contains('department')) {
      if (actionLower.contains('create') || actionLower.contains('tambah')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menambahkan bidang baru';
        icon = Icons.work_outline_rounded;
        color = Colors.lightBlue;
      } else if (actionLower.contains('update') || actionLower.contains('edit')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Mengupdate data bidang';
        icon = Icons.edit_outlined;
        color = Colors.lightBlue;
      } else if (actionLower.contains('delete') || actionLower.contains('hapus')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Menghapus bidang';
        icon = Icons.delete_outline;
        color = Color(0xFFDC2626);
      }
    }
    
    // === SETTINGS / SYSTEM ===
    else if (actionLower.contains('setting') || actionLower.contains('pengaturan') || actionLower.contains('config')) {
      description = rawDescription.isNotEmpty 
          ? rawDescription 
          : 'Mengubah pengaturan sistem';
      icon = Icons.settings_outlined;
      color = Color(0xFF6B7280);
    }
    else if (actionLower.contains('backup')) {
      description = rawDescription.isNotEmpty 
          ? rawDescription 
          : 'Melakukan backup data';
      icon = Icons.backup_rounded;
      color = Color(0xFF059669);
    }
    else if (actionLower.contains('restore')) {
      description = rawDescription.isNotEmpty 
          ? rawDescription 
          : 'Melakukan restore data';
      icon = Icons.restore_rounded;
      color = Color(0xFF4F46E5);
    }
    
    // === FILE / DOCUMENT ===
    else if (actionLower.contains('upload') || actionLower.contains('unggah')) {
      description = rawDescription.isNotEmpty 
          ? rawDescription 
          : 'Mengunggah file dokumen';
      icon = Icons.upload_file_rounded;
      color = Color(0xFF4F46E5);
    }
    else if (actionLower.contains('download') || actionLower.contains('unduh')) {
      description = rawDescription.isNotEmpty 
          ? rawDescription 
          : 'Mengunduh file dokumen';
      icon = Icons.download_rounded;
      color = Color(0xFF059669);
    }
    
    // === LAPORAN ===
    else if (actionLower.contains('laporan') || actionLower.contains('report')) {
      if (actionLower.contains('generate') || actionLower.contains('buat')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Generate laporan';
        icon = Icons.assessment_rounded;
        color = Color(0xFF7C2D12);
      } else if (actionLower.contains('export')) {
        description = rawDescription.isNotEmpty 
            ? rawDescription 
            : 'Export laporan';
        icon = Icons.file_download_outlined;
        color = Color(0xFF059669);
      }
    }
    
    // === DEFAULT / UNKNOWN ===
    else {
      description = rawDescription.isNotEmpty 
          ? rawDescription 
          : 'Melakukan aktivitas';
      icon = Icons.info_outline_rounded;
      color = Color(0xFF6B7280);
    }
    
    return {
      'description': description,
      'icon': icon,
      'color': color,
    };
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Baru saja';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} menit lalu';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} jam lalu';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} hari lalu';
      } else {
        return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
      }
    } catch (e) {
      return timestamp;
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
                                  'Dashboard Admin',
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

                        // Recent activity
                        Expanded(child: _buildRecentActivity(_cardAnimation)),
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