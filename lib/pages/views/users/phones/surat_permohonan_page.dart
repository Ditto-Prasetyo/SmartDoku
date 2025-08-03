import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:ui';
import 'package:smart_doku/utils/function.dart';

class PermohonanLetterPage extends StatefulWidget {
  const PermohonanLetterPage({super.key});

  @override
  State<PermohonanLetterPage> createState() => _PermohonanLetterPage();
}

class _PermohonanLetterPage extends State<PermohonanLetterPage>
    with TickerProviderStateMixin {
  var height, width;
  OverlayEntry? _overlayEntry;

  bool isRefreshing = false;
  bool isSearchActive = false;
  bool showSearchOptions = false;
  String selectedSearchType = 'judul';

  TextEditingController searchController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  // Animation controllers and animations
  late AnimationController _backgroundController;
  late AnimationController _searchController;
  late AnimationController _optionsController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _searchAnimation;
  late Animation<double> _optionsAnimation;

  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    // API buat call data disini yak..

    setState(() {
      isRefreshing = false;
    });
  }

  List<Map<String, dynamic>> searchOptions = [
    {'value': 'judul', 'label': 'Judul Surat', 'icon': Icons.title_rounded},
    {'value': 'perihal', 'label': 'Perihal', 'icon': Icons.description_rounded},
    {
      'value': 'tanggal',
      'label': 'Tanggal',
      'icon': Icons.calendar_today_rounded,
    },
    {'value': 'status', 'label': 'Pengirim', 'icon': Icons.person_rounded},
    {'value': 'status', 'label': 'Status', 'icon': Icons.flag_rounded},
  ];

  List<Map<String, dynamic>> suratData = [
    {
      'id': '1',
      'judul': 'Surat Pemberitahuan Rapat Bulanan',
      'perihal':
          'Mengundang seluruh staff untuk menghadiri rapat evaluasi bulanan',
      'tanggal': '28 Juli 2025',
      'pengirim': 'HRD Department',
      'status': 'Proses',
    },
    {
      'id': '2',
      'judul': 'Pengajuan Cuti Tahunan',
      'perihal': 'Permohonan persetujuan cuti tahunan untuk bulan Agustus',
      'tanggal': '27 Juli 2025',
      'pengirim': 'Karyawan - Ahmad Rizki',
      'status': 'Selesai',
    },
    {
      'id': '3',
      'judul': 'Laporan Keuangan Q2 2025',
      'perihal': 'Report keuangan triwulan kedua tahun 2025',
      'tanggal': '26 Juli 2025',
      'pengirim': 'Finance Department',
      'status': 'Proses',
    },
    {
      'id': '4',
      'judul': 'Undangan Seminar IT',
      'perihal': 'Mengundang untuk menghadiri seminar teknologi terbaru',
      'tanggal': '25 Juli 2025',
      'pengirim': 'IT Department',
      'status': 'Selesai',
    },
    {
      'id': '5',
      'judul': 'Surat Peringatan Kedisiplinan',
      'perihal': 'Teguran untuk meningkatkan kedisiplinan dalam bekerja',
      'tanggal': '24 Juli 2025',
      'pengirim': 'HRD Department',
      'status': 'Selesai',
    },
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'proses':
        return Color(0xFFF59E0B);
      case 'selesai':
        return Color(0xFF10B981);
      default:
        return Color(0xFF6366F1);
    }
  }

  @override
  void initState() {
    super.initState();

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
    _searchController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchController, curve: Curves.easeInOutCubic),
    );
    _optionsController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    _optionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _optionsController, curve: Curves.easeOutBack),
    );

    _backgroundController.repeat(reverse: true);
  }

  // Function toggle search options
  void _toggleSearchOptions() {
    if (showSearchOptions) {
      // Hide overlay
      _overlayEntry?.remove();
      _overlayEntry = null;
      _optionsController.reverse().then((_) {
        setState(() {
          showSearchOptions = false;
        });
      });
    } else {
      // Show overlay
      setState(() {
        showSearchOptions = true;
      });
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _optionsController.forward();
    }
  }

  // Function select search type
  void _selectSearchType(String type) {
    setState(() {
      selectedSearchType = type;
      showSearchOptions = false;
      isSearchActive = true;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
    _optionsController.reverse();
    _searchController.forward();

    Future.delayed(Duration(milliseconds: 150), () {
      searchFocusNode.requestFocus();
    });
  }

  // Close search function
  void _closeSearch() {
    setState(() {
      isSearchActive = false;
      showSearchOptions = false;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.reverse();
    _optionsController.reverse();
    searchController.clear();
    searchFocusNode.unfocus();
  }

  void actionSetState(int index) {
    setState(() {
      suratData.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dokumen berhasil dihapus'),
        backgroundColor: Colors.red,
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + 85, // Adjust position sesuai header
        right: 15,
        child: Material(
          color: Colors.transparent,
          elevation: 20,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedBuilder(
            animation: _optionsAnimation,
            builder: (context, child) {
              print("Opacity Value ${_optionsAnimation.value}");
              return Transform.scale(
                scale: _optionsAnimation.value,
                alignment: Alignment.topRight,
                child: Opacity(
                  opacity: _optionsAnimation.value.clamp(0.0, 1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 40,
                              offset: Offset(0, 15),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4F46E5).withValues(alpha: 0.3),
                                    Color(0xFF7C3AED).withValues(alpha: 0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.tune_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Cari Berdasarkan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Options List
                            ...searchOptions.map((option) {
                              bool isSelected =
                                  selectedSearchType == option['value'];
                              return InkWell(
                                onTap: () => _selectSearchType(option['value']),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              Color(
                                                0xFF10B981,
                                              ).withValues(alpha: 0.3),
                                              Color(
                                                0xFF059669,
                                              ).withValues(alpha: 0.2),
                                            ],
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: isSelected
                                                ? [
                                                    Color(0xFF10B981),
                                                    Color(0xFF059669),
                                                  ]
                                                : [
                                                    Colors.white.withValues(
                                                      alpha: 0.2,
                                                    ),
                                                    Colors.white.withValues(
                                                      alpha: 0.1,
                                                    ),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          option['icon'],
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          option['label'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Color(0xFF10B981),
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _overlayEntry?.remove();
    _searchController.dispose();
    _optionsController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
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
                    bottom: 15,
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
                                      color: Colors.white,
                                      fit: BoxFit.cover,
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
                                    home(context);
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
                                  onTap: () {
                                    logout(context);
                                  },
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _searchAnimation,
                        builder: (context, child) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 30,
                              left: 15,
                              right: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Menu Button
                                Transform.translate(
                                  offset: Offset(
                                    -60 * _searchAnimation.value,
                                    0,
                                  ),
                                  child: Opacity(
                                    opacity: 1 - _searchAnimation.value,
                                    child: Builder(
                                      builder: (context) => InkWell(
                                        onTap: isSearchActive
                                            ? null
                                            : () {
                                                Scaffold.of(
                                                  context,
                                                ).openDrawer();
                                              },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: EdgeInsets.all(4.5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.2,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.menu_rounded,
                                            color: Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              1,
                                            ),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Search Box Container
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 60 * (1 - _searchAnimation.value),
                                    ),
                                    child: Row(
                                      children: [
                                        // Search Input Field
                                        if (isSearchActive)
                                          Expanded(
                                            child: Transform.scale(
                                              scale: _searchAnimation.value,
                                              alignment: Alignment.centerRight,
                                              child: Opacity(
                                                opacity: _searchAnimation.value,
                                                child: Container(
                                                  height: 42,
                                                  margin: EdgeInsets.only(
                                                    right: 10,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                        sigmaX: 15,
                                                        sigmaY: 15,
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              Colors.white
                                                                  .withValues(
                                                                    alpha: 0.25,
                                                                  ),
                                                              Colors.white
                                                                  .withValues(
                                                                    alpha: 0.1,
                                                                  ),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        child: TextField(
                                                          controller:
                                                              searchController,
                                                          focusNode:
                                                              searchFocusNode,
                                                          cursorColor:
                                                              Colors.white,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Roboto',
                                                          ),
                                                          decoration: InputDecoration(
                                                            hintText:
                                                                'Cari berdasarkan ${searchOptions.firstWhere((option) => option['value'] == selectedSearchType)['label'].toString().toLowerCase()}...',
                                                            hintStyle: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.6,
                                                                  ),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Roboto',
                                                            ),
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 6,
                                                                ),
                                                            prefixIcon: Icon(
                                                              searchOptions.firstWhere(
                                                                (option) =>
                                                                    option['value'] ==
                                                                    selectedSearchType,
                                                              )['icon'],
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.7,
                                                                  ),
                                                              size: 20,
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            print(
                                                              'Searching $selectedSearchType: $value',
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        if (!isSearchActive) Spacer(),

                                        // Search/Close Button
                                        InkWell(
                                          onTap: isSearchActive
                                              ? _closeSearch
                                              : _toggleSearchOptions,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(4.5),
                                            decoration: BoxDecoration(
                                              color: isSearchActive
                                                  ? Color(
                                                      0xFFEF4444,
                                                    ).withValues(alpha: 0.2)
                                                  : showSearchOptions
                                                  ? Color(
                                                      0xFF10B981,
                                                    ).withValues(alpha: 0.2)
                                                  : Colors.white.withValues(
                                                      alpha: 0.1,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSearchActive
                                                    ? Color(
                                                        0xFFEF4444,
                                                      ).withValues(alpha: 0.4)
                                                    : showSearchOptions
                                                    ? Color(
                                                        0xFF10B981,
                                                      ).withValues(alpha: 0.4)
                                                    : Colors.white.withValues(
                                                        alpha: 0.2,
                                                      ),
                                                width: 1,
                                              ),
                                              boxShadow:
                                                  (isSearchActive ||
                                                      showSearchOptions)
                                                  ? [
                                                      BoxShadow(
                                                        color: isSearchActive
                                                            ? Color(
                                                                0xFFEF4444,
                                                              ).withValues(
                                                                alpha: 0.3,
                                                              )
                                                            : Color(
                                                                0xFF10B981,
                                                              ).withValues(
                                                                alpha: 0.3,
                                                              ),
                                                        blurRadius: 8,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: AnimatedSwitcher(
                                              duration: Duration(
                                                milliseconds: 200,
                                              ),
                                              child: Icon(
                                                isSearchActive
                                                    ? Icons.close_rounded
                                                    : Icons.search,
                                                key: ValueKey(isSearchActive),
                                                color: Color.fromRGBO(
                                                  255,
                                                  255,
                                                  255,
                                                  1,
                                                ),
                                                size: 24,
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
                          );
                        },
                      ),

                      // Title
                      AnimatedBuilder(
                        animation: _searchAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -20 * _searchAnimation.value),
                            child: Opacity(
                              opacity: 1 - (_searchAnimation.value * 0.7),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 35,
                                  left: 15,
                                  right: 15,
                                ),
                                child: Center(
                                  child: Text(
                                    "Surat Masuk",
                                    style: TextStyle(
                                      fontSize:
                                          30 - (8 * _searchAnimation.value),
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Main Content Container
                Expanded(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(255, 255, 255, 0.3),
                          Color.fromRGBO(248, 250, 252, 0.1),
                          Color.fromRGBO(241, 245, 249, 0.1),
                          Color.fromRGBO(255, 255, 255, 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            height: height * 0.75,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: isRefreshing
                                                ? [
                                                    Colors.white.withValues(
                                                      alpha: 0.2,
                                                    ),
                                                    Colors.white.withValues(
                                                      alpha: 0.05,
                                                    ),
                                                  ]
                                                : [
                                                    Color(
                                                      0xFF10B981,
                                                    ).withValues(alpha: 0.3),
                                                    Color(
                                                      0xFF059669,
                                                    ).withValues(alpha: 0.2),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          border: Border.all(
                                            color: isRefreshing
                                                ? Colors.white.withValues(
                                                    alpha: 0.3,
                                                  )
                                                : Color(
                                                    0xFF10B981,
                                                  ).withValues(alpha: 0.3),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 15,
                                              offset: Offset(0, 5),
                                            ),
                                            BoxShadow(
                                              color: Colors.white.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 3,
                                              offset: Offset(0, -1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Info text
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Data Surat Masuk',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    isRefreshing
                                                        ? 'Sedang memperbarui data...'
                                                        : 'Tarik ke bawah untuk refresh',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      fontSize: 12,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Sync button
                                            InkWell(
                                              onTap: isRefreshing
                                                  ? null
                                                  : _refreshData,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: isRefreshing
                                                        ? [
                                                            Color(
                                                              0xFF6B7280,
                                                            ).withValues(
                                                              alpha: 0.3,
                                                            ),
                                                            Color(
                                                              0xFF4B5563,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            ),
                                                          ]
                                                        : [
                                                            Color(
                                                              0xFF10B981,
                                                            ).withValues(
                                                              alpha: 0.3,
                                                            ),
                                                            Color(
                                                              0xFF059669,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            ),
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: isRefreshing
                                                        ? Color(
                                                            0xFF6B7280,
                                                          ).withValues(
                                                            alpha: 0.4,
                                                          )
                                                        : Color(
                                                            0xFF10B981,
                                                          ).withValues(
                                                            alpha: 0.4,
                                                          ),
                                                    width: 1.5,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: isRefreshing
                                                          ? Color(
                                                              0xFF6B7280,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            )
                                                          : Color(
                                                              0xFF10B981,
                                                            ).withValues(
                                                              alpha: 0.2,
                                                            ),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: isRefreshing
                                                    ? SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(
                                                                Colors.white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                              ),
                                                        ),
                                                      )
                                                    : Icon(
                                                        Icons.sync_rounded,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // ListView dengan RefreshIndicator
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: _refreshData,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    color: Color(0xFF10B981),
                                    strokeWidth: 3,
                                    child: ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(
                                        parent: BouncingScrollPhysics(),
                                      ), // Enable pull to refresh even when list is short
                                      itemCount: suratData.length,
                                      padding: EdgeInsets.only(bottom: 20),
                                      itemBuilder: (context, index) {
                                        final surat = suratData[index];

                                        return Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 15,
                                                sigmaY: 15,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Colors.white.withValues(
                                                        alpha: 0.25,
                                                      ),
                                                      Colors.white.withValues(
                                                        alpha: 0.1,
                                                      ),
                                                      Colors.white.withValues(
                                                        alpha: 0.05,
                                                      ),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.3),
                                                    width: 1.5,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      blurRadius: 20,
                                                      offset: Offset(0, 10),
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      blurRadius: 5,
                                                      offset: Offset(0, -2),
                                                    ),
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    action(
                                                      index,
                                                      context,
                                                      suratData,
                                                      (i) => editDokumen(
                                                        index,
                                                        suratData,
                                                      ),
                                                      (i) => viewDetail(
                                                        context,
                                                        index,
                                                        suratData,
                                                      ),
                                                      (i) => hapusDokumen(
                                                        context,
                                                        index,
                                                        suratData,
                                                        actionSetState,
                                                      ),
                                                    );
                                                    print(
                                                      'Surat dipilih: ${surat['judul']}',
                                                    );
                                                  },
                                                  onLongPress: () {
                                                    action(
                                                      index,
                                                      context,
                                                      suratData,
                                                      (i) => editDokumen(
                                                        index,
                                                        suratData,
                                                      ),
                                                      (i) => viewDetail(
                                                        context,
                                                        index,
                                                        suratData,
                                                      ),
                                                      (i) => hapusDokumen(
                                                        context,
                                                        index,
                                                        suratData,
                                                        actionSetState,
                                                      ),
                                                    );
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Header dengan status badge
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 6,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    getStatusColor(
                                                                      surat['status'],
                                                                    ),
                                                                    getStatusColor(
                                                                      surat['status'],
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      20,
                                                                    ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color:
                                                                        getStatusColor(
                                                                          surat['status'],
                                                                        ).withValues(
                                                                          alpha:
                                                                              0.3,
                                                                        ),
                                                                    blurRadius:
                                                                        8,
                                                                    offset:
                                                                        Offset(
                                                                          0,
                                                                          2,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Text(
                                                                surat['status'],
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                ),
                                                              ),
                                                            ),
                                                            // Tanggal
                                                            Text(
                                                              surat['tanggal'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.7,
                                                                    ),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Roboto',
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        SizedBox(height: 15),

                                                        // Judul Surat
                                                        Text(
                                                          surat['judul'],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Roboto',
                                                            height: 1.3,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),

                                                        SizedBox(height: 8),

                                                        // Perihal
                                                        Text(
                                                          surat['perihal'],
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Roboto',
                                                            height: 1.4,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),

                                                        SizedBox(height: 15),

                                                        // Footer dengan pengirim dan icon
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            // Pengirim
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          6,
                                                                        ),
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                        colors: [
                                                                          Color(
                                                                            0xFF4F46E5,
                                                                          ).withValues(
                                                                            alpha:
                                                                                0.3,
                                                                          ),
                                                                          Color(
                                                                            0xFF7C3AED,
                                                                          ).withValues(
                                                                            alpha:
                                                                                0.2,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .person_outline_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      surat['pengirim'],
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white
                                                                            .withValues(
                                                                              alpha: 0.7,
                                                                            ),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Roboto',
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            // Arrow icon
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    6,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    Colors.white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.2,
                                                                        ),
                                                                    Colors.white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.1,
                                                                        ),
                                                                  ],
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .more_vert_rounded,
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                                size: 14,
                                                              ),
                                                            ),
                                                          ],
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
