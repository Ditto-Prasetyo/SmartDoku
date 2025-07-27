import 'package:flutter/material.dart';
import 'package:smart_doku/pages/views/home_page.dart';
import 'dart:math';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeOutController;
  late AnimationController _helloFadeController;
  late AnimationController _welcomeFadeController;
  late AnimationController _backgroundController;
  late AnimationController _loadingSpinController;
  late AnimationController _particleController;

  // Animations
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _helloFadeAnimation;
  late Animation<double> _welcomeFadeAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _loadingSpinAnimation;
  late Animation<double> _particleAnimation;

  // State variables
  bool _showInitialElements = true;
  bool _showHelloText = false;
  bool _showWelcomeText = false;
  bool _showLoadingDots = false;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeOutController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _helloFadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _welcomeFadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: Duration(seconds: 5), // Durasi keseluruhan animasi background
      vsync: this,
    );

    _loadingSpinController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: Duration(seconds: 6), // Animasi partikel selama 6 detik
      vsync: this,
    );

    // Initialize animations
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeInOut),
    );

    _helloFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _helloFadeController, curve: Curves.easeIn),
    );

    _welcomeFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _welcomeFadeController, curve: Curves.easeIn),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _loadingSpinAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(_loadingSpinController);

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );

    // Mulai loading spinner dan particle animation dari awal
    _loadingSpinController.repeat();
    _particleController.forward();

    _startAnimation();
  }

  void _startAnimation() async {
    // Detik ke-1: Fade out semua elemen + mulai animasi background
    await Future.delayed(Duration(milliseconds: 1500));
    _fadeOutController.forward();
    _backgroundController.forward(); // Mulai animasi background bersamaan

    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _showInitialElements = false;
      _showHelloText = true;
    });

    // Detik ke-2: Fade in "Hello"
    _helloFadeController.forward();

    // Detik ke-4: Fade out "Hello" dan fade in "Welcome"
    await Future.delayed(Duration(milliseconds: 2000));

    // Fade out Hello
    _helloFadeController.reverse();

    await Future.delayed(Duration(milliseconds: 600));

    setState(() {
      _showHelloText = false;
      _showWelcomeText = true;
    });

    // Fade in Welcome
    _welcomeFadeController.forward();

    // Detik ke-5: Mulai loading dots
    await Future.delayed(Duration(milliseconds: 2500));

    setState(() {
      _showLoadingDots = true;
    });

    _startLoadingAnimation();

    // Detik ke-6: Navigate ke HomePage
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void _startLoadingAnimation() async {
    // Loop animasi loading dots
    for (int i = 0; i < 6; i++) {
      for (int j = 1; j <= 5; j++) {
        await Future.delayed(Duration(milliseconds: 150));
        if (mounted && _showLoadingDots) {
          setState(() {
            _dotCount = j;
          });
        }
      }
      if (mounted && _showLoadingDots) {
        setState(() {
          _dotCount = 0;
        });
      }
      await Future.delayed(Duration(milliseconds: 150));
    }
  }

  String get _loadingDots {
    return '.' * _dotCount;
  }

  @override
  void dispose() {
    _fadeOutController.dispose();
    _helloFadeController.dispose();
    _welcomeFadeController.dispose();
    _backgroundController.dispose();
    _loadingSpinController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            // Modern Animated Background
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.5 + (_backgroundAnimation.value * 2),
                      colors: [
                        // Warna tengah yang berubah seiring waktu
                        Color.lerp(
                          Color(0xFF1A1A2E), // Dark blue
                          Color(0xFF16213E), // Deeper blue
                          _backgroundAnimation.value,
                        )!,
                        Color.lerp(
                          Color(0xFF0F3460), // Medium blue
                          Color(0xFF533483), // Purple
                          _backgroundAnimation.value,
                        )!,
                        Color.lerp(
                          Color(0xFF16213E), // Dark blue
                          Color(0xFF0F0F0F), // Almost black
                          _backgroundAnimation.value,
                        )!,
                      ],
                      stops: [0.0, 0.6, 1.0],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Animated geometric shapes
                      ...List.generate(12, (index) {
                        double delay = index * 0.15;
                        double animValue = (_backgroundAnimation.value - delay)
                            .clamp(0.0, 1.0);

                        return AnimatedBuilder(
                          animation: _particleAnimation,
                          builder: (context, child) {
                            return Positioned(
                              left:
                                  (size.width * 0.1) +
                                  (index * size.width * 0.08) +
                                  (animValue * size.width * 0.3) *
                                      (index.isEven ? 1 : -1),
                              top:
                                  (size.height * 0.1) +
                                  (index * size.height * 0.07) +
                                  (animValue * size.height * 0.4) *
                                      (index % 3 == 0 ? 1 : -1),
                              child: Transform.rotate(
                                angle:
                                    _particleAnimation.value * 6.28 +
                                    (index * 0.5),
                                child: Transform.scale(
                                  scale: 0.5 + (animValue * 1.5),
                                  child: Container(
                                    width: 15 + (index * 3),
                                    height: 15 + (index * 3),
                                    decoration: BoxDecoration(
                                      shape: index % 3 == 0
                                          ? BoxShape.circle
                                          : BoxShape.rectangle,
                                      borderRadius: index % 3 != 0
                                          ? BorderRadius.circular(8)
                                          : null,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF00D2FF).withValues(
                                            alpha: 0.3 + (animValue * 0.4),
                                          ),
                                          Color(0xFF3A7BD5).withValues(
                                            alpha: 0.2 + (animValue * 0.3),
                                          ),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFF00D2FF,
                                          ).withValues(alpha: 0.2),
                                          blurRadius: 10 + (animValue * 15),
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),

                      // Floating orbs with glow effect
                      ...List.generate(8, (index) {
                        double delay = index * 0.2;
                        double animValue = (_backgroundAnimation.value - delay)
                            .clamp(0.0, 1.0);

                        return AnimatedBuilder(
                          animation: _particleAnimation,
                          builder: (context, child) {
                            return Positioned(
                              left:
                                  size.width * 0.15 +
                                  (index * size.width * 0.12) +
                                  (sin(
                                        _particleAnimation.value * 3.14 + index,
                                      ) *
                                      50),
                              top:
                                  size.height * 0.2 +
                                  (index * size.height * 0.1) +
                                  (cos(
                                        _particleAnimation.value * 3.14 + index,
                                      ) *
                                      30),
                              child: Transform.scale(
                                scale: 0.3 + (animValue * 0.9),
                                child: Container(
                                  width: 20 + (index * 5),
                                  height: 20 + (index * 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Color(
                                          0xFFFF6B6B,
                                        ).withValues(alpha: 0.6 * animValue),
                                        Color(
                                          0xFF4ECDC4,
                                        ).withValues(alpha: 0.3 * animValue),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFFFF6B6B,
                                        ).withValues(alpha: 0.3 * animValue),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),

                      // Central energy pulse
                      if (_backgroundAnimation.value > 0.3)
                        Center(
                          child: AnimatedBuilder(
                            animation: _particleAnimation,
                            builder: (context, child) {
                              return Container(
                                width:
                                    100 +
                                    (sin(_particleAnimation.value * 6.28) * 30),
                                height:
                                    100 +
                                    (sin(_particleAnimation.value * 6.28) * 30),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Color(0xFF00F5FF).withValues(alpha: 0.1),
                                      Color(0xFF00D4FF).withValues(alpha: 0.05),
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(
                                        0xFF00F5FF,
                                      ).withValues(alpha: 0.2),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            // Overlay gradient depth
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),

            Container(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_showInitialElements)
                    FadeTransition(
                      opacity: _fadeOutAnimation,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              border: Border.all(
                                color: Color(0xFF764ba2).withValues(alpha: 0.4),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    0xFF667eea,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 20.0,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 15.0,
                                  offset: Offset(3, 6),
                                ),
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: Offset(-5, -3),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'images/Icon_App.png',
                              width: 125.0,
                              height: 125.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            child: Text(
                              "SmartDoku",
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black54,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 40),

                          Container(
                            width: 280,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _loadingSpinAnimation,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle:
                                          _loadingSpinAnimation.value *
                                          2 *
                                          3.14159,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: SweepGradient(
                                            colors: [
                                              Color(0xFF00D4FF),
                                              Color(0xFF667eea),
                                              Color(0xFF00D4FF),
                                            ],
                                            stops: [0.0, 0.5, 1.0],
                                          ),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: 18),
                                // Loading text
                                Text(
                                  "Loading...",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_showHelloText)
                    FadeTransition(
                      opacity: _helloFadeAnimation,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Hello",
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 20.0,
                                color: Color(0xFF00D4FF).withValues(alpha: 0.5),
                                offset: Offset(0, 0),
                              ),
                              Shadow(
                                blurRadius: 40.0,
                                color: Color(0xFF667eea).withValues(alpha: 0.3),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  if (_showWelcomeText)
                    FadeTransition(
                      opacity: _welcomeFadeAnimation,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              child: Text(
                                "Welcome$_loadingDots",
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 20.0,
                                      color: Color(
                                        0xFFFF6B6B,
                                      ).withValues(alpha: 0.6),
                                      offset: Offset(0, 0),
                                    ),
                                    Shadow(
                                      blurRadius: 40.0,
                                      color: Color(
                                        0xFF4ECDC4,
                                      ).withValues(alpha: 0.4),
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }
}
