import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _textFadeController;
  late AnimationController _backgroundDissolveController;
  late AnimationController _loadingController;
  late AnimationController
  _marbleController; // New controller for marble animation

  late Animation<double> _textFadeAnimation;
  late Animation<double> _backgroundDissolveAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _marbleAnimation; // New animation for marble effect

  bool showText = false;
  bool showLoading = false;
  bool showButton = false;
  double _arrowTop = 0;
  double _arrowLeft = 0;

  @override
  void initState() {
    super.initState();

    // Setup animation controllers
    _textFadeController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _backgroundDissolveController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    _loadingController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _marbleController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );

    // Setup animations
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeInOut),
    );
    _backgroundDissolveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundDissolveController,
        curve: Curves.easeInOut,
      ),
    );
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );
    _marbleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _marbleController, curve: Curves.linear));

    // Start animation sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Detik ke-2: Munculin text PENSUDIS
    await Future.delayed(Duration(milliseconds: 1300));
    setState(() {
      showText = true;
    });
    _textFadeController.forward();

    // Detik ke-3: Background dissolve + loading muncul + marble animation starts
    await Future.delayed(Duration(milliseconds: 1800));
    _backgroundDissolveController.forward();
    _marbleController.repeat();

    await Future.delayed(Duration(milliseconds: 2500));
    setState(() {
      showLoading = true;
    }); // Start marble animation and repeat
    _loadingController.forward();

    // Detik ke-4: Loading berubah jadi tombol
    await Future.delayed(Duration(milliseconds: 5000));
    setState(() {
      showButton = true;
    });
  }

  @override
  void dispose() {
    _textFadeController.dispose();
    _backgroundDissolveController.dispose();
    _loadingController.dispose();
    _marbleController.dispose();
    super.dispose();
  }

  void _goToLoginPage() async {
    // Step 1: Arrow pop ke atas
    setState(() {
      _arrowTop = -8; // naik 8 pixel
    });
    await Future.delayed(Duration(milliseconds: 150));

    // Step 2: Balik ke tengah
    setState(() {
      _arrowTop = 0;
    });

    // Step 3: Tunggu 1 detik, baru geser ke kanan
    await Future.delayed(Duration(milliseconds: 100));

    setState(() {
      _arrowLeft = 24; // geser ke kanan 24px
    });

    // Optional: delay sebelum pindah halaman
    await Future.delayed(Duration(milliseconds: 300));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background layer
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                // Original background image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/background_images.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Marble background overlay (dissolve effect)
                AnimatedBuilder(
                  animation: _backgroundDissolveAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _backgroundDissolveAnimation.value,
                      child: AnimatedBuilder(
                        animation: _marbleAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: MarbleFluidPainter(_marbleAnimation.value),
                            size: Size.infinite,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // PENSUDIS text
                if (showText)
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Text(
                      'PENSUDIS',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Bottom section (Loading/Button)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _loadingAnimation,
                builder: (context, child) {
                  if (!showLoading) return SizedBox.shrink();
                  return Opacity(
                    opacity: _loadingAnimation.value,
                    child: showButton
                        ? ElevatedButton(
                            onPressed: _goToLoginPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                horizontal: 45,
                                vertical: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Agar row nggak melebar lebih dari yang diperlukan
                              children: [
                                Container(padding: EdgeInsets.only(left: 0.0)),
                                Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold, color: Colors.white
                                  ),
                                ),
                                Padding(padding: EdgeInsetsGeometry.only(right: 5.0)),
                                SizedBox(
                                  width: 55,
                                  height: 40,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedPositioned(
                                        duration: Duration(milliseconds: 150),
                                        top: _arrowTop,
                                        left: _arrowLeft,
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk marble fluid effect
class MarbleFluidPainter extends CustomPainter {
  final double animationValue;

  MarbleFluidPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create multiple fluid layers with different gradients
    _drawFluidLayer(canvas, size, paint, 0.0, 0.4);
    _drawFluidLayer(canvas, size, paint, 0.3, 0.3);
    _drawFluidLayer(canvas, size, paint, 0.6, 0.2);
  }

  void _drawFluidLayer(
    Canvas canvas,
    Size size,
    Paint paint,
    double offset,
    double opacity,
  ) {
    final path = Path();

    // Create gradient shader
    paint.shader = LinearGradient(
      colors: [
        Color(0xFF8e1d33),
        Color(0xFF7b3257),
        Color(0xFF623f65),
        Color(0xFF382372),
        Color(0xFF2c446b),
        Color(0xFF476486),
        Color(0xFF1d627e),
        Color(0xFF0c575d),
      ],
      stops: [0.0, 0.1, 0.3, 0.4, 0.5, 0.6, 0.8, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Animated offset for flowing effect
    final animatedOffset = (animationValue + offset) * 2 * math.pi;

    // Create flowing background
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Add flowing organic shapes
    for (int i = 0; i < 5; i++) {
      double x =
          size.width * (0.1 + i * 0.2) + math.cos(animatedOffset + i) * 50;
      double y =
          size.height * (0.2 + i * 0.15) +
          math.sin(animatedOffset + i * 0.7) * 30;

      _addFlowingBlob(path, x, y, animatedOffset + i);
    }

    // Add wave-like patterns
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.3);

    for (double x = 0; x <= size.width; x += 5) {
      double y =
          size.height * 0.4 +
          math.sin((x / 60) + animatedOffset) * 40 +
          math.cos((x / 100) + animatedOffset * 0.7) * 25;
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    path.addPath(wavePath, Offset.zero);

    // Apply opacity for layering effect
    paint.color = Colors.white.withOpacity(opacity);
    canvas.drawPath(path, paint);
  }

  void _addFlowingBlob(
    Path path,
    double centerX,
    double centerY,
    double animatedOffset,
  ) {
    final blobPath = Path();
    final points = <Offset>[];

    // Create organic blob shape
    for (int i = 0; i < 8; i++) {
      double angle = (i / 8) * 2 * math.pi;
      double radius = 30 + math.sin(animatedOffset + i) * 15;
      double x = centerX + math.cos(angle) * radius;
      double y = centerY + math.sin(angle) * radius;
      points.add(Offset(x, y));
    }

    // Create smooth curves between points
    if (points.isNotEmpty) {
      blobPath.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        final current = points[i];
        final next = points[(i + 1) % points.length];
        final controlX = (current.dx + next.dx) / 2;
        final controlY = (current.dy + next.dy) / 2;
        blobPath.quadraticBezierTo(current.dx, current.dy, controlX, controlY);
      }
      blobPath.close();
    }

    path.addPath(blobPath, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
