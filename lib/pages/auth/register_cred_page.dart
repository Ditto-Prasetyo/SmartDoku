import 'package:smart_doku/pages/auth/register_pages.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:smart_doku/utils/formatter.dart';
import 'package:smart_doku/utils/hover.dart';
import 'package:smart_doku/utils/dialog.dart';
import 'package:smart_doku/utils/function.dart';
import 'dart:ui';
import 'dart:math';

class RegisterCredPage extends StatefulWidget {
  final String? username;
  final String? password;
  final String? email;

  const RegisterCredPage({
    Key? key,
    required this.username,
    required this.password,
    required this.email,
  }) : super(key: key);

  @override
  State<RegisterCredPage> createState() => RegisterCredPageState();
}

class RegisterCredPageState extends State<RegisterCredPage>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isSignInHovered = false;
  bool _hasShownNameSpaceDialog = false;
  bool _isButtonHovered = false;
  Offset _buttonCursorPosition = Offset.zero;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _sectionWorkController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _sectionWorkFocus = FocusNode();

  String? _selectedWorkField;
  String? _workFieldError;

  final Map<String, String> _workFields = {
    'Penataan Ruang dan PB': 'PRPB',
    'Perumahan': 'Perumahan',
    'Permukiman': 'Permukiman',
    'Sekretariat': 'Sekretariat',
    'UPT Pengelolaan Air Limbah Domestik': 'UPT_PALD',
    'UPT Pertamanan': 'UPT_Taman',
  };

  final List<IconData> _workFieldIcons = [
    Icons.admin_panel_settings,
    Icons.location_city,
    Icons.house_rounded,
    Icons.map_outlined,
    Icons.water_drop_outlined,
    Icons.park_rounded,
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
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
                          opacity: _formAnimation.value.clamp(0.0, 1.0),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 50),
                            child: Text(
                              "Fill your biodata to complete",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
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
                  AnimatedBuilder(
                    animation: _formAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * _formAnimation.value),
                        child: Opacity(
                          opacity: _formAnimation.value.clamp(0.0, 1.0),
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
                                    // Name field
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
                                        controller: _nameController,
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          checkLengthName(
                                            context,
                                            value,
                                            _nameController,
                                          );

                                          int spaceCount = RegExp(
                                            r' ',
                                          ).allMatches(value).length;
                                          if (spaceCount > 5) {
                                            showErrorDialog(
                                              context,
                                              '⛔ Gunakan Nama Asli Anda',
                                              "Nama Anda Tidak Boleh Lebih Dari Lima Spasi!",
                                              Colors.deepOrange,
                                              _nameController,
                                            );
                                          }

                                          if (spaceCount <= 5) {
                                            _hasShownNameSpaceDialog = false;
                                          }
                                        },
                                        focusNode: _nameFocus,
                                        keyboardType: TextInputType.name,
                                        inputFormatters: [
                                          FullNameFormatter(
                                            onInvalidInput: (msg) {
                                              showModernErrorDialog(
                                                context,
                                                '⚠️ Gunakan Nama Asli Anda',
                                                msg,
                                                Colors.orange,
                                              );
                                            },
                                          ),
                                        ],
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_phoneFocus);
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
                                            padding: EdgeInsets.only(
                                              left: 16,
                                              right: 14,
                                              top: 12,
                                              bottom: 12,
                                            ),
                                            child: Icon(
                                              Icons.person_outline_rounded,
                                              color: Color(0xFF00D4FF),
                                              size: 24,
                                            ),
                                          ),
                                          hintText: "Nama Anda",
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

                                    // Phone field
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
                                        controller: _phoneController,
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          checkLengthPhone(
                                            context,
                                            value,
                                            _phoneController,
                                          );
                                        },
                                        focusNode: _phoneFocus,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          DigitOnlyWithErrorFormatter(
                                            onInvalidInput: (msg) =>
                                                showModernErrorDialog(
                                                  context,
                                                  '⚠️ Gunakan Nomor Asli Anda',
                                                  'Pastikan Anda Hanya Memasukkan Angka Sesuai Nomor Anda!',
                                                  Colors.orange,
                                                ),
                                          ),
                                        ],
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_addressFocus);
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
                                            padding: EdgeInsets.only(
                                              left: 16,
                                              right: 14,
                                              top: 12,
                                              bottom: 12,
                                            ),
                                            child: Icon(
                                              Icons.phone_android_rounded,
                                              color: Color(0xFF00D4FF),
                                              size: 24,
                                            ),
                                          ),
                                          hintText: "Nomor Telepon Anda",
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
                                    // Address field
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
                                        controller: _addressController,
                                        cursorColor: Colors.white,
                                        onChanged: (value) {
                                          checkLengthAddress(
                                            context,
                                            value,
                                            _addressController,
                                          );
                                        },
                                        focusNode: _addressFocus,
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        inputFormatters: [
                                          NormalAddressFormatter(
                                            onInvalidInput: (msg) =>
                                                showModernErrorDialog(
                                                  context,
                                                  '⛔ Error',
                                                  'Pastikan Anda Memasukkan Alamat Sesuai Dengan Lokasi Anda Sebenarnya!',
                                                  Colors.deepOrange,
                                                ),
                                          ),
                                        ],

                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_sectionWorkFocus);
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
                                            padding: EdgeInsets.only(
                                              left: 16,
                                              right: 14,
                                              top: 12,
                                              bottom: 12,
                                            ),
                                            child: Icon(
                                              Icons.home,
                                              color: Color(0xFF00D4FF),
                                              size: 24,
                                            ),
                                          ),
                                          hintText: "Alamat Rumah Anda",
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
                                    // Section of Work field
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
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          isExpanded: true,
                                          value: _selectedWorkField,
                                          hint: Row(
                                            children: [
                                              Icon(
                                                Icons.work,
                                                color: Color(0xFF00D4FF),
                                                size: 24,
                                              ),
                                              SizedBox(width: 18),
                                              Expanded(
                                                child: Text(
                                                  "Bidang Pekerjaan Anda",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.6),
                                                  ),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: _workFields.entries
                                              .toList()
                                              .asMap()
                                              .entries
                                              .map((indexedEntry) {
                                                final index = indexedEntry.key;
                                                final entry =
                                                    indexedEntry.value;

                                                final label = entry
                                                    .key; // "Penataan Ruang dan PB"
                                                final value =
                                                    entry.value; // "PRPB"

                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: HoverMenuItem(
                                                    label: label,
                                                    icon:
                                                        _workFieldIcons[index],
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedWorkField =
                                                            value;
                                                        _sectionWorkController
                                                                .text =
                                                            value;
                                                        _workFieldError = null;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                );
                                              })
                                              .toList(),

                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white.withValues(
                                                    alpha: 0.1,
                                                  ),
                                                  Colors.white.withValues(
                                                    alpha: 0.05,
                                                  ),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                              ),
                                            ),
                                            elevation: 8,
                                            padding: EdgeInsets.only(
                                              top: 6,
                                              bottom: 6,
                                            ),
                                          ),
                                          iconStyleData: IconStyleData(
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          buttonStyleData: ButtonStyleData(
                                            padding: EdgeInsets.only(right: 20),
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          dropdownSearchData:
                                              DropdownSearchData(
                                                searchInnerWidget: null,
                                                searchInnerWidgetHeight: null,
                                              ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedWorkField = newValue;
                                              _sectionWorkController.text =
                                                  newValue!;
                                              _workFieldError = null;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    if (_workFieldError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          left: 12,
                                        ),
                                        child: Text(
                                          _workFieldError!,
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
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
                                                handleRegister(
                                                  context,
                                                  _selectedWorkField,
                                                  widget.username,
                                                  widget.email,
                                                  widget.password,
                                                  _nameController,
                                                  _phoneController,
                                                  _addressController,
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
                                                    Icons.arrow_forward_rounded,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Register',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 1,
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
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Go Back",
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
