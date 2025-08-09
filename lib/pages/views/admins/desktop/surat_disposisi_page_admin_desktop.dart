import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui';
import 'package:smart_doku/utils/function.dart';
import 'package:smart_doku/utils/widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_doku/pages/views/users/phones/surat_disposisi_page.dart';

class DispositionLetterAdminDesktop extends StatefulWidget {
  final Map<String, dynamic>? suratData;
  const DispositionLetterAdminDesktop({super.key, this.suratData});

  @override
  State<DispositionLetterAdminDesktop> createState() =>
      _DispositionLetterAdminDesktopState();
}

class _DispositionLetterAdminDesktopState
    extends State<DispositionLetterAdminDesktop>
    with TickerProviderStateMixin {
  var height, width;
  bool isCheckedSangatSegera = false;
  bool isCheckedSegera = false;
  bool isCheckedRahasia = false;
  final TextEditingController nomorUrutController = TextEditingController();

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  late Map<String, dynamic> disposisiData;

  // Selected sidebar item
  int _selectedIndex = 3;

  final List<Map<String, dynamic>> _sidebarItems = [
    {
      'icon': Icons.dashboard_rounded,
      'title': 'Dashboard',
      'route': '/admin/desktop/home_page_admin_desktop',
    },
    {
      'icon': LineIcons.envelopeOpen,
      'title': 'Surat Masuk',
      'route': '/admin/desktop/surat_permohonan_page_admin_desktop',
    },
    {
      'icon': FontAwesomeIcons.envelopeCircleCheck,
      'title': 'Surat Keluar',
      'route': '/admin/desktop/surat_keluar_page_admin_desktop',
    },
    {
      'icon': Icons.assignment_turned_in_rounded,
      'title': 'Disposisi',
      'route': '/admin/desktop/surat_disposisi_page_admin_desktop',
    },
    {
      'icon': Icons.people_outline_rounded,
      'title': 'Manajemen Pengguna',
      'route': '/admin/desktop/manajemen_pengguna_page',
    },
    {
      'icon': Icons.settings_outlined,
      'title': 'Pengaturan',
      'route': '/admin/desktop/setting_page',
    },
  ];

  Map<String, dynamic> getDisposisiData() {
    final dataBase = widget.suratData ?? {};

    return {
      'judul': 'Dinas Perumahan, Kawasan Permukiman Dan Cipta Karya',
      'alamat': 'Jl. Trunojoyo Kav 6 Kepanjen, Kabupaten Malang, Jawa Timur',
      'telepon/laman':
          'Telepon (0341) 391679 Laman : perumahan-ciptakarya.malangkab.go.id',
      'pos/kode': 'Pos-el : dppck.mlg@gmail.com, Kode Pos : 65163',
      'judulsurat': 'LEMBAR DISPOSISI',
      'surat_dari': dataBase['pengi rim'] ?? 'HRD Department',
      'diterima_tgl': '28 Juli 2025',
      'nomor_surat': '001',
      'nomor_agenda':
          'AG-${DateTime.now().year}-${dataBase['id']?.toString().padLeft(4, '0') ?? '0001'}',
      'tgl_surat': dataBase['tanggal'] ?? '28 Juli 2025',
      'hal': dataBase['judul'] ?? 'Surat Pemberitahuan',
      'hari_tanggal': 'Senin, ${dataBase['tanggal'] ?? '28 Juli 2025'}',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Utama',
      'disp_1': 'Kepala Bagian - Review dokumen',
      'disp_2': 'Manager Operasional - Persetujuan',
      'disp_3': 'Direktur - Final approval',
    };
  }

  // Widget untuk menampilkan nomor urut yang akan ter-update
  Widget buildNomorUrutDisplay() {
    final surat = getDisposisiData();
    return Text(
      'Nomor Urut: ${surat['nomor_surat'] == null ? '404 Not Found' : surat['nomor_surat']}',
      style: TextStyle(color: Colors.white, fontSize: 10),
      textAlign: TextAlign.center,
    );
  }

  // Method untuk update nomor urut
  void updateNomorUrut(String newValue) {
    setState(() {
      disposisiData['nomor_surat'] =
          newValue; // Update ke disposisiData, bukan surat
    });
    print('Updated nomor urut: $newValue');
  }

  void _navigateToPage(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  ) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushNamedAndRemoveUntil(context, item['route'], (route) => false);
  }

  List<Widget> buildCheckboxList(List<String> items, String category) {
    return items.map((item) {
      String key = '${category}_${items.indexOf(item)}'; // unique key
      bool isChecked = checkboxStates[key] ?? false;

      return Padding(
        padding: EdgeInsets.only(bottom: 6),
        child: GestureDetector(
          onTap: () {
            setState(() {
              checkboxStates[key] = !isChecked;
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 14,
                height: 14,
                margin: EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1.0,
                  ),
                  color: isChecked ? Colors.white : Colors.transparent,
                ),
                child: isChecked
                    ? Icon(Icons.check, color: Colors.black, size: 10)
                    : null,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(color: Colors.white, fontSize: 8),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Map<String, bool> checkboxStates = {};

  @override
  void initState() {
    super.initState();

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
    disposisiData = getDisposisiData();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    nomorUrutController.dispose();
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
                  child: Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 28,
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
                        'Admin Panel',
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
                    onTap: () => logoutDesktop(context),
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
        ],
      ),
    );
  }

  Widget _buildRecentActivity(Animation<double> _cardAnimation) {
    final surat = getDisposisiData();
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
              Row(
                children: [
                  Expanded(
                    child: buildSectionTitleDisposisiDesktop('Lembar Disposisi'),
                  ),
                  buildMenuActionDisposisiAdmin(
                    context,
                    nomorUrutController,
                    onDelete: () {
                      // Handle delete
                      print('Delete action');
                    },
                    onEditSave: updateNomorUrut, // Pass callback untuk save
                    currentNomorUrut:
                        surat['nomor_surat'], // Pass current value
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: buildSuratDisposisi(
                                  context,
                                  getDisposisiData,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                  right: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 15,
                                  left: 15,
                                  right: 15,
                                  bottom: 15,
                                ),
                                child: Center(
                                  child: Text(
                                    surat['judulsurat'] ?? '404 Not Found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 1.0,
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  bool shouldWrap = constraints.maxWidth < 600;

                                  if (shouldWrap) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            'Surat Dari: ${surat['surat_dari'] ?? '404 Not Found'}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                              right: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'Diterima Tanggal: ${surat['diterima_tgl'] ?? '404 Not Found'}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Surat Dari: ${surat['surat_dari'] ?? '404 Not Found'}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Diterima Tanggal: ${surat['diterima_tgl'] ?? '404 Not Found'}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  bool shouldWrap = constraints.maxWidth < 600;
                                  if (shouldWrap) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Nomor Urut: ${disposisiData['nomor_surat'] == null ? '404 Not Found' : disposisiData['nomor_surat']}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                              right: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'Nomor Agenda: ${surat['nomor_agenda'] ?? '404 Not Found'}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Nomor Surat: ${surat['nomor_surat'] ?? '404 Not Found'}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Nomor Agenda: ${surat['nomor_agenda'] ?? '404 Not Found'}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  bool shouldWrap = constraints.maxWidth < 600;
                                  if (shouldWrap) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                              right: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'Tanggal Surat: ${surat['tgl_surat'] ?? '404 Not Found'}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                              right: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isCheckedSangatSegera =
                                                          !isCheckedSangatSegera;
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
                                                            width: 1.5,
                                                          ),
                                                          color:
                                                              isCheckedSangatSegera
                                                              ? Colors.white
                                                              : Colors
                                                                    .transparent,
                                                        ),
                                                        child:
                                                            isCheckedSangatSegera
                                                            ? Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .black,
                                                                size: 12,
                                                              )
                                                            : null,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Flexible(
                                                        child: Text(
                                                          'Sangat Segera',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isCheckedSegera =
                                                          !isCheckedSegera;
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
                                                            width: 1.5,
                                                          ),
                                                          color: isCheckedSegera
                                                              ? Colors.white
                                                              : Colors
                                                                    .transparent,
                                                        ),
                                                        child: isCheckedSegera
                                                            ? Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .black,
                                                                size: 12,
                                                              )
                                                            : null,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Flexible(
                                                        child: Text(
                                                          'Segera',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isCheckedRahasia =
                                                          !isCheckedRahasia;
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 18,
                                                        height: 18,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
                                                            width: 1.5,
                                                          ),
                                                          color:
                                                              isCheckedRahasia
                                                              ? Colors.white
                                                              : Colors
                                                                    .transparent,
                                                        ),
                                                        child: isCheckedRahasia
                                                            ? Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .black,
                                                                size: 12,
                                                              )
                                                            : null,
                                                      ),
                                                      SizedBox(width: 6),
                                                      Flexible(
                                                        child: Text(
                                                          'Rahasia',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 12,
                                              left: 12,
                                              right: 12,
                                              bottom: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Tanggal Surat: ${surat['tgl_surat'] ?? '404 Not Found'}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isCheckedSangatSegera =
                                                            !isCheckedSangatSegera;
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(width: 34),
                                                        Container(
                                                          width: 18,
                                                          height: 18,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.8,
                                                                  ),
                                                              width: 1.5,
                                                            ),
                                                            color:
                                                                isCheckedSangatSegera
                                                                ? Colors.white
                                                                : Colors
                                                                      .transparent,
                                                          ),
                                                          child:
                                                              isCheckedSangatSegera
                                                              ? Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 12,
                                                                )
                                                              : null,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Flexible(
                                                          child: Text(
                                                            'Sangat Segera',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isCheckedSegera =
                                                            !isCheckedSegera;
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(width: 60),
                                                        Container(
                                                          width: 18,
                                                          height: 18,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.8,
                                                                  ),
                                                              width: 1.5,
                                                            ),
                                                            color:
                                                                isCheckedSegera
                                                                ? Colors.white
                                                                : Colors
                                                                      .transparent,
                                                          ),
                                                          child: isCheckedSegera
                                                              ? Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 12,
                                                                )
                                                              : null,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Flexible(
                                                          child: Text(
                                                            'Segera',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isCheckedRahasia =
                                                            !isCheckedRahasia;
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(width: 40),
                                                        Container(
                                                          width: 18,
                                                          height: 18,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.8,
                                                                  ),
                                                              width: 1.5,
                                                            ),
                                                            color:
                                                                isCheckedRahasia
                                                                ? Colors.white
                                                                : Colors
                                                                      .transparent,
                                                          ),
                                                          child:
                                                              isCheckedRahasia
                                                              ? Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 12,
                                                                )
                                                              : null,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Flexible(
                                                          child: Text(
                                                            'Rahasia',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                    );
                                  }
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  // biar ukurannya ngikutin lebar "Tanggal Surat"
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildBorderedText(
                                        'Hal : ${surat['hal'] ?? '404 Not Found'}',
                                      ),
                                      buildBorderedText(
                                        'Hari / Tanggal : ${surat['hari_tanggal'] ?? '404 Not Found'}',
                                      ),
                                      buildBorderedText(
                                        'Waktu : ${surat['waktu'] ?? '404 Not Found'}',
                                      ),
                                      buildBorderedText(
                                        'Tempat : ${surat['tempat'] ?? '404 Not Found'}',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Bagian 3 Checkbox
                                  IntrinsicHeight(
                                    // Biar semua tinggi kolom sejajar
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Diteruskan ke :',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                ...buildCheckboxList([
                                                  'A. Sekretariat',
                                                  'B. Bidang Permukiman',
                                                  'C. Bidang Perumahan',
                                                  'D. Bidang Penataan Ruang dan PB',
                                                  'E. UPT Air Limbah Domestik',
                                                  'F. UPT Pertamanan',
                                                ], 'diteruskan'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Dengan hormat harap :',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                ...buildCheckboxList([
                                                  'Tanggapan dan Saran',
                                                  'Proses lebih lanjut',
                                                  'Koordinasi/Konfirmasi',
                                                  'Untuk Ditindaklanjuti',
                                                  'Untuk Menjadi Perhatian',
                                                  'Hadir Sekdir/ Kabid/ JFT/EsIV/ Staf/ Tim',
                                                ], 'hormat'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 29),
                                                ...buildCheckboxList([
                                                  'Agenda Rapat',
                                                  'Proses Sesuai Aturan',
                                                  'Inventarisir',
                                                  'Arsip',
                                                  'Untuk Dikaji',
                                                ], 'lainnya'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Divider(
                                    height: 0,
                                    thickness: 1.5,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),

                                  Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        constraints: BoxConstraints(
                                          minHeight: 80,
                                          maxHeight: 150,
                                        ),
                                        padding: EdgeInsets.only(
                                          bottom: 100,
                                          left: 12,
                                          right: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'DISPOSISI KEPALA DINAS',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              constraints: BoxConstraints(
                                                minHeight: 100,
                                                maxHeight: 150,
                                              ),
                                              padding: EdgeInsets.only(
                                                bottom: 80,
                                                left: 12,
                                                right: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.3),
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'DISPOSISI SEKRETARIS DINAS',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              constraints: BoxConstraints(
                                                minHeight: 100,
                                                maxHeight: 150,
                                              ),
                                              padding: EdgeInsets.only(
                                                bottom: 80,
                                                left: 12,
                                                right: 12,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'DISPOSISI KEPALA BIDANG / UPT',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
                                  'Surat Disposisi',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Anda Dapat Mengatur Surat Disposisi di Sini!',
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
                                Icons.assignment_turned_in_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
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
