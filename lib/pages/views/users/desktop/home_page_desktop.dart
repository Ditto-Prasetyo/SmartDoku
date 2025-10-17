import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smart_doku/services/surat.dart';
import 'dart:ui';
import 'package:smart_doku/utils/function.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with TickerProviderStateMixin {
  var height, width;

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // Selected sidebar item
  int _selectedIndex = 0;

  // Sample data for dashboard
  List<Map<String, dynamic>> _statsData = [];
  SuratMasuk _suratMasukService = SuratMasuk();
  SuratKeluar _suratKeluarService = SuratKeluar();

  int? totalSuratMasuk;
  int? totalSuratKeluar;

  Future<void> _loadAllData() async {
    final suratMasuk = await _suratMasukService.listSurat();
    final SuratKeluar = await _suratKeluarService.listSurat();
    
    setState(() {
      totalSuratMasuk = suratMasuk.length;
      totalSuratKeluar = SuratKeluar.length;

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
        }
      ];
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

  void _navigateToPage(BuildContext context, Map<String, dynamic> item, int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushNamedAndRemoveUntil(
      context, 
      item['route'], 
      (route) => false, 
    );
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
                  Navigator.pushNamed(context, '/user/desktop/surat_permohonan_page_desktop');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/user/desktop/surat_keluar_page_desktop');
                  break;
                default:
                  Navigator.pushNamed(context, '/admin/desktop/home_page_admin_desktop');
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
                  border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
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

  Widget _buildRecentActivity(Animation<double> _cardAnimation) {
    final recentActivities = [
      {
        'title': 'Surat permohonan dari PT. ABC',
        'time': '2 jam lalu',
        'type': 'masuk',
      },
      {
        'title': 'Disposisi surat ke bagian HRD',
        'time': '4 jam lalu',
        'type': 'disposisi',
      },
      {
        'title': 'Surat keluar ke vendor',
        'time': '6 jam lalu',
        'type': 'keluar',
      },
      {'title': 'User baru mendaftar', 'time': '1 hari lalu', 'type': 'user'},
      {
        'title': 'Backup data berhasil',
        'time': '2 hari lalu',
        'type': 'system',
      },
    ];

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
              Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: recentActivities.length,
                  itemBuilder: (context, index) {
                    final activity = recentActivities[index];
                    IconData icon;
                    Color color;

                    switch (activity['type']) {
                      case 'masuk':
                        icon = LineIcons.envelopeOpen;
                        color = Color(0xFF4F46E5);
                        break;
                      case 'keluar':
                        icon = FontAwesomeIcons.envelopeCircleCheck;
                        color = Color(0xFF059669);
                        break;
                      case 'disposisi':
                        icon = Icons.assignment_turned_in_rounded;
                        color = Color(0xFFDC2626);
                        break;
                      case 'user':
                        icon = Icons.person_add_rounded;
                        color = Color(0xFF7C2D12);
                        break;
                      default:
                        icon = Icons.info_outline_rounded;
                        color = Color(0xFF6B7280);
                    }

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
                        border: Border.all(color: Colors.grey[200]!, width: 1),
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
                            child: Icon(icon, color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity['title']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  activity['time']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
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
                                  'Dashboard User',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Selamat datang kembali, User!',
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
