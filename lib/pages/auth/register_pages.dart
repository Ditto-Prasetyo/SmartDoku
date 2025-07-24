import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:smart_doku/pages/auth/register_cred_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/services.dart';

class NormalUsernameFormatter extends TextInputFormatter {
  final Function(String) onInvalidInput;

  NormalUsernameFormatter({required this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final allowedRegex = RegExp(r'^[a-zA-Z0-9\s.,\-\/]*$');

    if (!allowedRegex.hasMatch(newValue.text)) {
      onInvalidInput(
        "Username hanya boleh mengandung huruf, angka, spasi, dan tanda baca umum (, . - /)",
      );
      return oldValue;
    }

    return newValue;
  }
}

class NormalEmailFormatter extends TextInputFormatter {
  final Function(String) onInvalidInput;

  NormalEmailFormatter({required this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final allowedRegex = RegExp(r'^[a-zA-Z0-9\s.,@\-\/]*$');

    if (!allowedRegex.hasMatch(newValue.text)) {
      onInvalidInput(
        "Email hanya boleh mengandung huruf, angka, spasi, dan tanda baca umum (, . - / @)",
      );
      return oldValue;
    }

    return newValue;
  }
}

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

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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

  void _handleSession() {
    final usernameChecker = _usernameController.text.trim();
    final passwordChecker = _passwordController.text.trim();
    final emailChecker = _passwordController.text.trim();

    if (usernameChecker.isEmpty &&
        passwordChecker.isEmpty &&
        emailChecker.isEmpty) {
      _showModernErrorDialog(
        '❌ Login Error',
        'Username, Password, dan Email tidak boleh kosong!',
        Colors.redAccent,
      );
      return;
    } else if (usernameChecker.isEmpty && passwordChecker.isEmpty) {
      _showModernErrorDialog(
        '❌ Username and Password Required',
        'Username dan Password tidak boleh kosong!',
        Colors.orange,
      );
      return;
    } else if (passwordChecker.isEmpty && emailChecker.isEmpty) {
      _showModernErrorDialog(
        '❌ Password and Email Required',
        'Password dan Email tidak boleh kosong!',
        Colors.orange,
      );
      return;
    } else if (usernameChecker.isEmpty && emailChecker.isEmpty) {
      _showModernErrorDialog(
        '❌ Username and Email Required',
        'Username dan Email tidak boleh kosong',
        Colors.orange,
      );
      return;
    } else if (usernameChecker.isEmpty) {
      _showModernErrorDialog(
        '❌ Username Required',
        'Username tidak boleh kosong',
        Colors.orange,
      );
      return;
    } else if (passwordChecker.isEmpty) {
      _showModernErrorDialog(
        '❌ Password Required',
        'Password tidak boleh kosong',
        Colors.orange,
      );
      return;
    } else if (emailChecker.isEmpty) {
      _showModernErrorDialog(
        '❌ Email Required',
        'Email tidak boleh kosong',
        Colors.orange,
      );
      return;
    }

    final value = _emailController.text.trim();

    if (!value.contains('@')) {
      _showErrorDialogEmailFormat(
        '⚠️ Email Tidak Valid',
        "Email harus mengandung simbol '@'!",
        Colors.orange,
      );
      return;
    }

    bool isAllowedDomain = allowedDomains.any(
      (domain) => value.endsWith(domain),
    );
    if (!isAllowedDomain) {
      _showErrorDialogEmailFormat(
        '⚠️ Email Tidak Valid',
        "Email hanya boleh dari domain berikut:\n" + allowedDomains.join(', '),
        Colors.orange,
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterCredPage()),
    );
  }

  void _checkLengthPassword(String value) {
    if (value.contains(' ')) {
      _showErrorDialogPasswordSpaceChecker(
        '⚠️ Invalid Format',
        'Password tidak boleh mengandung spasi!',
        Colors.amber,
      );
      return;
    }

    if (value.length > _maxLengthPassword) {
      _passwordController.text = value.substring(0, _maxLengthPassword);
      _passwordController.selection = TextSelection.fromPosition(
        TextPosition(offset: _passwordController.text.length),
      );
      _showErrorDialogLengthPassword(
        '⛔ Error',
        'Pastikan Bahwa Anda Mengisi Username Dengan Benar!',
        Colors.deepOrange,
      );
    }
  }

  void _checkLengthUsername(String value) {
    if (value.length > _maxLengthUsername) {
      _usernameController.text = value.substring(0, _maxLengthUsername);
      _usernameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _usernameController.text.length),
      );
      _showErrorDialogLengthUsername(
        '⛔ Error',
        'Pastikan Bahwa Anda Mengisi Username Dengan Benar!',
        Colors.deepOrange,
      );
    }
  }

  void _checkLengthEmail(String value) {
    if (value.contains(' ')) {
      _showErrorDialogEmailSpaceChecker(
        '⚠️ Invalid Format',
        'Email Tidak Boleh Mengandung Spasi',
        Colors.orange,
      );
    }
    if (value.length > _maxLengthEmail) {
      _emailController.text = value.substring(0, _maxLengthEmail);
      _emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: _emailController.text.length),
      );
      _showErrorDialogLengthEmail(
        '⛔ Error',
        'Pastikan Bahwa Anda Mengisi Username Dengan Benar!',
        Colors.deepOrange,
      );
    }
  }

  void _showErrorDialogLengthUsername(
    String title,
    String message,
    Color accentColor,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Modern Error Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.8),
                                accentColor.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _usernameController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: accentColor.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
        );
      },
    );
  }

  void _showErrorDialogLengthPassword(
    String title,
    String message,
    Color accentColor,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Modern Error Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.8),
                                accentColor.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _passwordController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: accentColor.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
        );
      },
    );
  }

  void _showErrorDialogLengthEmail(
    String title,
    String message,
    Color accentColor,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Modern Error Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.8),
                                accentColor.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _emailController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: accentColor.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
        );
      },
    );
  }

  void _showErrorDialogEmailFormat(
    String title,
    String message,
    Color accentColor,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Modern Error Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.8),
                                accentColor.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: accentColor.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
        );
      },
    );
  }

  void _showErrorDialogUsernameSpaceChecker(
    String title,
    String message,
    Color accentColor,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Modern Error Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.8),
                                accentColor.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _usernameController.text = _usernameController
                                  .text
                                  .replaceAll(' ', '');
                              _usernameController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _usernameController.text.length,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: accentColor.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
        );
      },
    );
  }

  void _showErrorDialogPasswordSpaceChecker(
    String title,
    String message,
    Color accentColor,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Modern Error Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.8),
                                accentColor.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _passwordController.text = _passwordController
                                  .text
                                  .replaceAll(' ', '');
                              _passwordController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _passwordController.text.length,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: accentColor.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
        );
      },
    );
  }

  void _showErrorDialogEmailSpaceChecker(
    String title,
    String message,
    Color accentColor,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Modern Error Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.8),
                                accentColor.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _emailController.text = _emailController.text
                                  .replaceAll(' ', '');
                              _emailController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _emailController.text.length,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: accentColor.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
        );
      },
    );
  }

  void _showModernErrorDialog(String title, String message, Color accentColor) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Modern Error Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.8),
                                accentColor.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              shadowColor: accentColor.withValues(alpha: 0.4),
                            ),
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
        );
      },
    );
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
                                          _checkLengthUsername(value);

                                          int spaceCount = RegExp(
                                            r' ',
                                          ).allMatches(value).length;
                                          if (spaceCount > 3) {
                                            _showErrorDialogUsernameSpaceChecker(
                                              '⛔ Error ',
                                              "Username Tidak Boleh Lebih Dari Tiga Spasi!",
                                              Colors.deepOrange,
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
                                        onChanged: _checkLengthPassword,
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
                                        onChanged: _checkLengthEmail,
                                        focusNode: _emailFocus,
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (value) {
                                          _handleSession();
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
                                              onPressed: _handleSession,
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
