import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:smart_doku/utils/dialog.dart';
import 'package:smart_doku/utils/function.dart';
import 'dart:ui';
import 'dart:math';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isSignInHovered = false;
  bool _hasShownUsernameSpaceDialog = false;
  bool _isButtonHovered = false;
  Offset _buttonCursorPosition = Offset.zero;

  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  final int _maxLengthPassword = 16;
  final int _maxLengthUsername = 30;
  final int _maxLengthEmail = 191;

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _emailFocus = FocusNode();

  final List<String> allowedDomains = [
    '@gmail.com',
    '@yahoo.co.id',
    '@outlook.com',
    '@student.uin-malang.ac.id',
  ];

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _formController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _backgroundAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _backgroundController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _formController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Initialize animations
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutBack),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _backgroundController.forward();
    _formController.forward();
    _particleController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _emailFocus.dispose();
    _backgroundController.dispose();
    _formController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.5 + (_backgroundAnimation.value * 1.5),
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
                      stops: [0.0, 0.6, 1.0],
                    ),
                  ),
                );
              },
            ),

            // Floating particles
            ...List.generate(15, (index) {
              return AnimatedBuilder(
                animation: _particleAnimation,
                builder: (context, child) {
                  return Positioned(
                    left:
                        (size.width * 0.1) +
                        (index * size.width * 0.06) +
                        (sin(_particleAnimation.value * 2 * pi + index) * 30),
                    top:
                        (size.height * 0.1) +
                        (index * size.height * 0.06) +
                        (cos(_particleAnimation.value * 2 * pi + index) * 40),
                    child: Transform.rotate(
                      angle: _particleAnimation.value * 2 * pi + (index * 0.3),
                      child: Container(
                        width: 8 + (index * 2),
                        height: 8 + (index * 2),
                        decoration: BoxDecoration(
                          shape: index % 2 == 0
                              ? BoxShape.circle
                              : BoxShape.rectangle,
                          borderRadius: index % 2 != 0
                              ? BorderRadius.circular(4)
                              : null,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF00D2FF).withValues(alpha: 0.4),
                              Color(0xFF3A7BD5).withValues(alpha: 0.2),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF00D2FF).withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Main content
            Container(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Modern title with glow effect
                  AnimatedBuilder(
                    animation: _formAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - _formAnimation.value)),
                        child: Opacity(
                          opacity: _formAnimation.value,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 50),
                            child: Text(
                              "Create an SmartDoku Account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Color(
                                      0xFF00D4FF,
                                    ).withValues(alpha: 0.6),
                                    offset: Offset(0, 0),
                                  ),
                                  Shadow(
                                    blurRadius: 40.0,
                                    color: Color(
                                      0xFF667eea,
                                    ).withValues(alpha: 0.4),
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Modern glassmorphism form
                  AnimatedBuilder(
                    animation: _formAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * _formAnimation.value),
                        child: Opacity(
                          opacity: _formAnimation.value,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.15),
                                  Colors.white.withValues(alpha: 0.08),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  offset: Offset(0, 15),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Column(
                                  children: [
                                    // Username field
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.1),
                                            Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _usernameController,
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          checkLengthUsername(
                                            context,
                                            value,
                                            _usernameController,
                                          );

                                          int spaceCount = RegExp(
                                            r' ',
                                          ).allMatches(value).length;
                                          if (spaceCount > 3) {
                                            showErrorDialogUsernameSpaceChecker(
                                              context,
                                              '⛔ Error ',
                                              "Username Tidak Boleh Lebih Dari Tiga Spasi!",
                                              Colors.deepOrange,
                                              _usernameController,
                                            );
                                          }

                                          if (spaceCount <= 3) {
                                            _hasShownUsernameSpaceDialog =
                                                false;
                                          }
                                        },
                                        focusNode: _usernameFocus,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_passwordFocus);
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 20,
                                          ),
                                          prefixIcon: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Icon(
                                              Icons.person_outline_rounded,
                                              color: Color(0xFF00D4FF),
                                              size: 24,
                                            ),
                                          ),
                                          hintText: "Username Baru",
                                          hintStyle: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                            fontSize: 16,
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),

                                    // Password field
                                    Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.1),
                                            Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          checkLengthPassword(
                                            context,
                                            value,
                                            _passwordController,
                                          );
                                        },
                                        focusNode: _passwordFocus,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_emailFocus);
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 20,
                                          ),
                                          prefixIcon: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Icon(
                                              Icons.lock_outline_rounded,
                                              color: Color(0xFF00D4FF),
                                              size: 24,
                                            ),
                                          ),
                                          hintText: "Password Baru",
                                          hintStyle: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                            fontSize: 16,
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),

                                    // Email field
                                    Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.1),
                                            Colors.white.withValues(
                                              alpha: 0.05,
                                            ),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _emailController,
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          checkLengthEmail(
                                            context,
                                            value,
                                            _emailController,
                                          );
                                        },
                                        focusNode: _emailFocus,
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (value) {
                                          handleSession(
                                            context,
                                            _usernameController,
                                            _passwordController,
                                            _emailController,
                                            allowedDomains,
                                          );
                                        },
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 20,
                                          ),
                                          prefixIcon: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Icon(
                                              Icons.email_outlined,
                                              color: Color(0xFF00D4FF),
                                              size: 24,
                                            ),
                                          ),
                                          hintText: "Email Anda",
                                          hintStyle: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                            fontSize: 16,
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),

                                    // Modern login button dengan pulse effect
                                    AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _pulseAnimation.value,
                                          child: Container(
                                            width: double.infinity,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Color(0xFF667eea),
                                                  Color(0xFF764ba2),
                                                ],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(
                                                    0xFF667eea,
                                                  ).withValues(alpha: 0.4),
                                                  blurRadius: 20,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 8),
                                                ),
                                                // Enhanced cursor light effect untuk button
                                                if (_isButtonHovered)
                                                  BoxShadow(
                                                    color: Color(
                                                      0xFF00D4FF,
                                                    ).withValues(alpha: 0.6),
                                                    blurRadius: 40,
                                                    spreadRadius: 8,
                                                    offset: Offset(
                                                      (_buttonCursorPosition
                                                                  .dx -
                                                              200) *
                                                          0.2,
                                                      (_buttonCursorPosition
                                                                  .dy -
                                                              400) *
                                                          0.2,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                handleSession(
                                                  context,
                                                  _usernameController,
                                                  _passwordController,
                                                  _emailController,
                                                  allowedDomains,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                foregroundColor: Colors.white,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_upward_outlined,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Next',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 1,
                                                      decoration:
                                                          TextDecoration.none,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
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

                  // Register link
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          // Bagian teks non-interaktif
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) =>
                                  setState(() => _isSignInHovered = true),
                              onExit: (_) =>
                                  setState(() => _isSignInHovered = false),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _isSignInHovered
                                        ? Color(0xFFFF8A8A)
                                        : Color(0xFFFF6B6B),
                                    fontWeight: FontWeight.w800,
                                    decoration: _isSignInHovered
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationColor: _isSignInHovered
                                        ? Color(0xFFFF8A8A)
                                        : Color(0xFFFF6B6B),
                                    shadows: _isSignInHovered
                                        ? [
                                            Shadow(
                                              blurRadius: 12.0,
                                              color: Color(
                                                0xFFFF8A8A,
                                              ).withValues(alpha: 0.7),
                                              offset: Offset(0, 0),
                                            ),
                                          ]
                                        : [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Color(
                                                0xFFFF6B6B,
                                              ).withValues(alpha: 0.5),
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
