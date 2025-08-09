import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_doku/services/user.dart';
import 'package:smart_doku/models/user.dart';
import 'dart:ui';
import 'dart:math';
import 'package:smart_doku/utils/dialog.dart';
import 'package:smart_doku/utils/widget.dart';
import 'package:smart_doku/utils/function.dart';

class HomePageAdminPhones extends StatefulWidget {
  const HomePageAdminPhones({super.key});

  @override
  State<HomePageAdminPhones> createState() => _HomePageAdminPhones();
}

class _HomePageAdminPhones extends State<HomePageAdminPhones>
    with TickerProviderStateMixin {
  var height, width;

  // Animation controllers and animations
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  // Profile expansion animation
  late AnimationController _profileController;
  late Animation<double> _profileAnimation;
  late Animation<double> _profileOpacityAnimation;
  late Animation<double> _arrowRotationAnimation;
  late Animation<double> _dashboardOpacityAnimation;

  bool _showProfileContent = false;
  bool _isProfileExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadUser();

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

    // Initialize profile expansion animation
    _profileController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _profileAnimation = Tween<double>(begin: 0.25, end: 0.80).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.easeInOutCubic),
    );

    _profileOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _profileController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _arrowRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.easeInOutCubic),
    );

    _dashboardOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _profileController,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _profileController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          _showProfileContent = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _showProfileContent = false;
        });
      }
    });

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  void _toggleProfile() {
    setState(() {
      _isProfileExpanded = !_isProfileExpanded;
    });

    if (_isProfileExpanded) {
      _profileController.forward();
    } else {
      _profileController.reverse();
    }
  }

  UserService _userService = UserService();
  UserModel? _user;

  void _loadUser() async {
    final user = await _userService.getCurrentUser();

    setState(() {
      _user = user;
    });
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
                    bottom: 10,
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
                                      fit: BoxFit.cover,
                                      color: Colors.white,
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
                                    Navigator.of(context).pop();
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
                AnimatedBuilder(
                  animation: _profileAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(),
                      height: height * _profileAnimation.value,
                      width: width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Top Navigation Bar
                          Padding(
                            padding: EdgeInsets.only(
                              top: 30,
                              left: 15,
                              right: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(4.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.people_outline_rounded,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Dashboard Title
                          Padding(
                            padding: EdgeInsets.only(
                              top: 35,
                              left: 15,
                              right: 15,
                            ),
                            child: Column(
                              children: [
                                AnimatedBuilder(
                                  animation: _dashboardOpacityAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _dashboardOpacityAnimation.value,
                                      child: Text(
                                        "Dashboard Admin",
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          if (_showProfileContent)
                            Flexible(
                              child: buildProfileSection(
                                _profileOpacityAnimation,
                                _user?.name,
                                _user?.role
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),

                // Main Content Container
                Expanded(
                  child: Container(
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border: Border.all(color: Colors.white.withAlpha(150)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                    width: width,
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _toggleProfile,
                          onPanUpdate: (details) {
                            if (details.delta.dy > 2) {
                              if (!_isProfileExpanded) {
                                _toggleProfile();
                              }
                            } else if (details.delta.dy < -2) {
                              if (_isProfileExpanded) {
                                _toggleProfile();
                              }
                            }
                          },
                          child: AnimatedBuilder(
                            animation: _arrowRotationAnimation,
                            builder: (context, child) {
                              return Container(
                                margin: EdgeInsets.only(top: 12, bottom: 16),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[700]!,
                                      Colors.grey[500]!,
                                      Colors.grey[700]!,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 4,
                                      offset: Offset(0, -5),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Transform.rotate(
                                  angle: _arrowRotationAnimation.value * 2 * pi,
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 25),

                        Flexible(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.1,
                                  mainAxisSpacing: 25,
                                  crossAxisSpacing: 0,
                                ),
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              List<Map<String, dynamic>> boxData = [
                                {
                                  'icon': LineIcons.envelopeOpen,
                                  'title': 'Surat Masuk',
                                  'colors': [
                                    Color(0xFF4F46E5),
                                    Color(0xFF7C3AED),
                                  ],
                                  'route':
                                      'surat_permohonan_page_admin_phones.dart',
                                },
                                {
                                  'icon': FontAwesomeIcons.envelopeCircleCheck,
                                  'title': 'Surat Keluar',
                                  'colors': [
                                    Color(0xFF059669),
                                    Color(0xFF0D9488),
                                  ],
                                  'route':
                                      'surat_keluar_page_admin_phones.dart',
                                },
                                {
                                  'icon': Icons.assignment_turned_in_rounded,
                                  'title': 'Surat Disposisi',
                                  'colors': [
                                    Color(0xFFDC2626),
                                    Color(0xFFEA580C),
                                  ],
                                  'route':
                                      'surat_disposisi_page_admin_phones.dart',
                                },
                                {
                                  'icon': Icons.support_agent,
                                  'title': 'Support',
                                  'colors': [
                                    Color(0xFF7C2D12),
                                    Color(0xFF9A3412),
                                  ],
                                  'route': 'support',
                                },
                              ];

                              return InkWell(
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      Navigator.pushNamed(
                                        context,
                                        '/admin/phones/surat_permohonan_page_admin',
                                      );
                                      break;
                                    case 1:
                                      Navigator.pushNamed(
                                        context,
                                        '/admin/phones/surat_keluar_page_admin',
                                      );
                                      break;
                                    case 2:
                                      Navigator.pushNamed(
                                        context,
                                        '/admin/phones/surat_disposisi_page_admin',
                                      );
                                      break;
                                    case 3:
                                      showSupportDialog(context);
                                      break;
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20,
                                  ),
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
                                    border: Border.all(
                                      color: Colors.white.withAlpha(150),
                                    ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: boxData[index]['colors'],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: boxData[index]['colors'][0]
                                                  .withValues(alpha: 0.8),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          boxData[index]['icon'],
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        boxData[index]['title'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
