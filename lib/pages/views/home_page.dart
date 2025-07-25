import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {
  var height, width;

  // Animation controllers and animations
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize background animation
    _backgroundController = AnimationController(
      duration: Duration(seconds: 5), // Durasi keseluruhan animasi background
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Start the animation and repeat it
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  // Function untuk logout
  void _logout() {
    Navigator.of(context).pop(); // Tutup drawer dulu
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin logout?',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Color(0xFF6B7280))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDC2626),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
                  height: 200,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 10,
                    right: 10,
                    bottom: 20,
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
                        child: Container(
                          padding: EdgeInsets.all(0.1),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
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

                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Smart Doku',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
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
                        // Home Menu
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF4F46E5).withValues(alpha: 0.1),
                                Color(0xFF7C3AED).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFF4F46E5).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4F46E5),
                                    Color(0xFF7C3AED),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
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

                        SizedBox(height: 10),

                        // Logout Menu
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFDC2626).withValues(alpha: 0.1),
                                Color(0xFFEA580C).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color(0xFFDC2626).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFDC2626),
                                    Color(0xFFEA580C),
                                  ],
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
                                fontSize: 16,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            onTap: _logout,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
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
                      if (!snapshot.hasData)
                        return SizedBox(); // Bisa ganti jadi loading kecil
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
      body: SingleChildScrollView(
        child: AnimatedBuilder(
          animation: _backgroundAnimation,
          builder: (context, child) {
            return Container(
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
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => LoginPage(),
                                    //   ),
                                    // );
                                  },
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
                        Padding(
                          padding: EdgeInsets.only(
                            top: 35,
                            left: 15,
                            right: 15,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Dashboard",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(255, 255, 255, 0.7),
                          Color.fromRGBO(248, 250, 252, 0.4),
                          Color.fromRGBO(241, 245, 249, 0.4),
                          Color.fromRGBO(255, 255, 255, 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 100,
                          spreadRadius: -5,
                          offset: Offset(0, -10),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 15,
                          spreadRadius: -8,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    width: width,
                    padding: EdgeInsets.only(bottom: height * 0.1),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // Tambahin interaksi lu di sini nantinya
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
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
                                  color: Colors.white.withValues(alpha: 0.8),
                                  blurRadius: 4,
                                  offset: Offset(0, -5),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.1,
                                mainAxisSpacing: 25,
                              ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            // Data untuk setiap box
                            List<Map<String, dynamic>> boxData = [
                              {
                                'icon': LineIcons.envelopeOpen,
                                'title': 'Surat Masuk',
                                'colors': [
                                  Color(0xFF4F46E5),
                                  Color(0xFF7C3AED),
                                ],
                              },
                              {
                                'icon': FontAwesomeIcons.envelopeCircleCheck,
                                'title': 'Surat Keluar',
                                'colors': [
                                  Color(0xFF059669),
                                  Color(0xFF0D9488),
                                ],
                              },
                              {
                                'icon': Icons.assignment_turned_in_rounded,
                                'title': 'Surat Disposisi',
                                'colors': [
                                  Color(0xFFDC2626),
                                  Color(0xFFEA580C),
                                ],
                              },
                              {
                                'icon': Icons.upload,
                                'title': 'Upload File',
                                'colors': [
                                  Color(0xFF7C2D12),
                                  Color(0xFF9A3412),
                                ],
                              },
                            ];

                            return InkWell(
                              onTap: () {
                                // Tambahin navigation ke halaman masing-masing
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Color.fromRGBO(248, 250, 252, 0.8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: -2,
                                      offset: Offset(-2, -6),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.8,
                                      ),
                                      blurRadius: 12,
                                      spreadRadius: -3,
                                      offset: Offset(3, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: boxData[index]['colors'],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
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
                                        color: Color(0xFF374151),
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
