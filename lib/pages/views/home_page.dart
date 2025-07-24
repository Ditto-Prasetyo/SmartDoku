import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

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
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOutCubic,
    ));

    // Start the animation and repeat it
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                          padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.sort,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  size: 30,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 255, 255, 0.3),
                                  border: Border.all(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
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
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 35, left: 15, right: 15),
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
                        SizedBox(
                          height: 25,
                        ),
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                'colors': [Color(0xFF4F46E5), Color(0xFF7C3AED)]
                              },
                              {
                                'icon': FontAwesomeIcons.envelopeCircleCheck,
                                'title': 'Surat Keluar',
                                'colors': [Color(0xFF059669), Color(0xFF0D9488)]
                              },
                              {
                                'icon': Icons.assignment_turned_in_rounded,
                                'title': 'Surat Disposisi',
                                'colors': [Color(0xFFDC2626), Color(0xFFEA580C)]
                              },
                              {
                                'icon': Icons.help_center_rounded,
                                'title': 'Support',
                                'colors': [Color(0xFF7C2D12), Color(0xFF9A3412)]
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
                                  horizontal: 20
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
                                      color: Colors.white.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: -2,
                                      offset: Offset(-2, -6),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.8),
                                      blurRadius: 12,
                                      spreadRadius: -3,
                                      offset: Offset(3, 5),
                                    ),
                                  ]
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
                                            color: boxData[index]['colors'][0].withValues(alpha: 0.8),
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
                          }
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