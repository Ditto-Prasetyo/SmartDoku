import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui';
import 'package:smart_doku/utils/function.dart';

class PermohonanLettersPageAdminDesktop extends StatefulWidget {
  const PermohonanLettersPageAdminDesktop({super.key});

  @override
  State<PermohonanLettersPageAdminDesktop> createState() =>
      _PermohonanLettersPageAdminDesktopState();
}

class _PermohonanLettersPageAdminDesktopState
    extends State<PermohonanLettersPageAdminDesktop>
    with TickerProviderStateMixin {
  var height, width;

  // Animation controllers
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // Selected sidebar item
  int _selectedIndex = 1;

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
      'title': 'Manajemen User',
      'route': '/admin/desktop/manajemen_pengguna_page',
    },
    {
      'icon': Icons.settings_outlined,
      'title': 'Pengaturan',
      'route': '/admin/desktop/setting_page',
    },
  ];

  List<Map<String, dynamic>> suratData = [
    {
      'id': '1',
      'surat_dari': 'Surat Pemberitahuan Rapat Bulanan',
      'diterima_tgl': '28 Juli 2025',
      'perihal':
          'Mengundang seluruh staff untuk menghadiri rapat evaluasi bulanan',
      'tanggal': '28 Juli 2025',
      'pengirim': 'HRD Department',
      'tgl_surat': '28 Juli 2025',
      'kode': '600.3.3.2',
      'no_urut': '0001',
      'no_surat': '1001',
      'hari_tanggal': 'Selasa, 28 Juli 2025',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Paripurna',
      'disposisi': 'PRPB',
      'index': 'MC',
      'pengolah': 'Kominfo',
      'sifat': 'terbatas',
      'link_scan': 'https://drive.google.com/drive/my-drive?hl=RU',
      'disposisi_kadin': '06/01/2025',
      'disposisi_sekdin': '07/01/2025',
      'disposisi_kabid': '08/01/2025',
      'disposisi_kasubag': '08/01/2025',
      'disposisi_lanjutan': 'Pemanfaatan ruang dan bangunan',
      'tindak_lanjut_1': '08/01/2025',
      'tindak_lanjut_2': '30/01/2025',
      'status': 'Proses',
      'dok_final': '',
      'dok_dikirim_tgl': '',
      'tanda_terima': '',
    },
    {
      'id': '2',
      'surat_dari': 'Pengajuan Cuti Tahunan',
      'diterima_tgl': '28 Juli 2025',
      'perihal': 'Permohonan persetujuan cuti tahunan untuk bulan Agustus',
      'tgl_surat': '28 Juli 2025',
      'kode': '600.3.3.2',
      'no_urut': '0001',
      'no_surat': '1001',
      'hari_tanggal': 'Selasa, 28 Juli 2025',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Paripurna',
      'disposisi': 'PRPB',
      'index': 'MC',
      'pengolah': 'Kominfo',
      'sifat': 'terbatas',
      'link_scan': 'https://drive.google.com/drive/my-drive?hl=RU',
      'disposisi_kadin': '06/01/2025',
      'disposisi_sekdin': '07/01/2025',
      'disposisi_kabid': '08/01/2025',
      'disposisi_kasubag': '08/01/2025',
      'disposisi_lanjutan': 'Pemanfaatan ruang dan bangunan',
      'tindak_lanjut_1': '08/01/2025',
      'tindak_lanjut_2': '30/01/2025',
      'status': 'Selesai',
      'dok_final': '',
      'dok_dikirim_tgl': '',
      'tanda_terima': '',
    },
    {
      'id': '3',
      'surat_dari': 'Laporan Keuangan Q2 2025',
      'diterima_tgl': '28 Juli 2025',
      'perihal': 'Report keuangan triwulan kedua tahun 2025',
      'tgl_surat': '28 Juli 2025',
      'kode': '600.3.3.2',
      'no_urut': '0001',
      'no_surat': '1001',
      'hari_tanggal': 'Selasa, 28 Juli 2025',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Paripurna',
      'disposisi': 'PRPB',
      'index': 'MC',
      'pengolah': 'Kominfo',
      'sifat': 'terbatas',
      'link_scan': 'https://drive.google.com/drive/my-drive?hl=RU',
      'disposisi_kadin': '06/01/2025',
      'disposisi_sekdin': '07/01/2025',
      'disposisi_kabid': '08/01/2025',
      'disposisi_kasubag': '08/01/2025',
      'disposisi_lanjutan': 'Pemanfaatan ruang dan bangunan',
      'tindak_lanjut_1': '08/01/2025',
      'tindak_lanjut_2': '30/01/2025',
      'status': 'Proses',
      'dok_final': '',
      'dok_dikirim_tgl': '',
      'tanda_terima': '',
    },
    {
      'id': '4',
      'surat_dari': 'Undangan Seminar IT',
      'diterima_tgl': '28 Juli 2025',
      'perihal': 'Mengundang untuk menghadiri seminar teknologi terbaru',
      'tgl_surat': '28 Juli 2025',
      'kode': '600.3.3.2',
      'no_urut': '0001',
      'no_surat': '1001',
      'hari_tanggal': 'Selasa, 28 Juli 2025',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Paripurna',
      'disposisi': 'PRPB',
      'index': 'MC',
      'pengolah': 'Kominfo',
      'sifat': 'terbatas',
      'link_scan': 'https://drive.google.com/drive/my-drive?hl=RU',
      'disposisi_kadin': '06/01/2025',
      'disposisi_sekdin': '07/01/2025',
      'disposisi_kabid': '08/01/2025',
      'disposisi_kasubag': '08/01/2025',
      'disposisi_lanjutan': 'Pemanfaatan ruang dan bangunan',
      'tindak_lanjut_1': '08/01/2025',
      'tindak_lanjut_2': '30/01/2025',
      'status': 'Selesai',
      'dok_final': '',
      'dok_dikirim_tgl': '',
      'tanda_terima': '',
    },
    {
      'id': '5',
      'surat_dari': 'Surat Peringatan Kedisiplinan',
      'diterima_tgl': '28 Juli 2025',
      'perihal': 'Teguran untuk meningkatkan kedisiplinan dalam bekerja',
      'tgl_surat': '28 Juli 2025',
      'kode': '600.3.3.2',
      'no_urut': '0001',
      'no_surat': '1001',
      'hari_tanggal': 'Selasa, 28 Juli 2025',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Paripurna',
      'disposisi': 'PRPB',
      'index': 'MC',
      'pengolah': 'Kominfo',
      'sifat': 'terbatas',
      'link_scan': 'https://drive.google.com/drive/my-drive?hl=RU',
      'disposisi_kadin': '06/01/2025',
      'disposisi_sekdin': '07/01/2025',
      'disposisi_kabid': '08/01/2025',
      'disposisi_kasubag': '08/01/2025',
      'disposisi_lanjutan': 'Pemanfaatan ruang dan bangunan',
      'tindak_lanjut_1': '08/01/2025',
      'tindak_lanjut_2': '30/01/2025',
      'status': 'Selesai',
      'dok_final': '',
      'dok_dikirim_tgl': '',
      'tanda_terima': '',
    },
    {
      'id': '6',
      'surat_dari': 'Surat Peringatan Kedisiplinan',
      'diterima_tgl': '28 Juli 2025',
      'perihal': 'Teguran untuk meningkatkan kedisiplinan dalam bekerja',
      'tgl_surat': '28 Juli 2025',
      'kode': '600.3.3.2',
      'no_urut': '0001',
      'no_surat': '1001',
      'hari_tanggal': 'Selasa, 28 Juli 2025',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Paripurna',
      'disposisi': 'PRPB',
      'index': 'MC',
      'pengolah': 'Kominfo',
      'sifat': 'terbatas',
      'link_scan': 'https://drive.google.com/drive/my-drive?hl=RU',
      'disposisi_kadin': '06/01/2025',
      'disposisi_sekdin': '07/01/2025',
      'disposisi_kabid': '08/01/2025',
      'disposisi_kasubag': '08/01/2025',
      'disposisi_lanjutan': 'Pemanfaatan ruang dan bangunan',
      'tindak_lanjut_1': '08/01/2025',
      'tindak_lanjut_2': '30/01/2025',
      'status': 'Selesai',
      'dok_final': '',
      'dok_dikirim_tgl': '',
      'tanda_terima': '',
    },
    {
      'id': '7',
      'surat_dari': 'Surat Peringatan Kedisiplinan',
      'diterima_tgl': '28 Juli 2025',
      'perihal': 'Teguran untuk meningkatkan kedisiplinan dalam bekerja',
      'tgl_surat': '28 Juli 2025',
      'kode': '600.3.3.2',
      'no_urut': '0001',
      'no_surat': '1001',
      'hari_tanggal': 'Selasa, 28 Juli 2025',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Paripurna',
      'disposisi': 'PRPB',
      'index': 'MC',
      'pengolah': 'Kominfo',
      'sifat': 'terbatas',
      'link_scan': 'https://drive.google.com/drive/my-drive?hl=RU',
      'disposisi_kadin': '06/01/2025',
      'disposisi_sekdin': '07/01/2025',
      'disposisi_kabid': '08/01/2025',
      'disposisi_kasubag': '08/01/2025',
      'disposisi_lanjutan': 'Pemanfaatan ruang dan bangunan',
      'tindak_lanjut_1': '08/01/2025',
      'tindak_lanjut_2': '30/01/2025',
      'status': 'Proses',
      'dok_final': '',
      'dok_dikirim_tgl': '',
      'tanda_terima': '',
    },
    {
      'id': '8',
      'surat_dari': 'Surat Peringatan Kedisiplinan',
      'diterima_tgl': '28 Juli 2025',
      'perihal': 'Teguran untuk meningkatkan kedisiplinan dalam bekerja',
      'tgl_surat': '28 Juli 2025',
      'kode': '600.3.3.2',
      'no_urut': '0001',
      'no_surat': '1001',
      'hari_tanggal': 'Selasa, 28 Juli 2025',
      'waktu': '09:00 WIB',
      'tempat': 'Ruang Rapat Paripurna',
      'disposisi': 'PRPB',
      'index': 'MC',
      'pengolah': 'Kominfo',
      'sifat': 'terbatas',
      'link_scan': 'https://drive.google.com/drive/my-drive?hl=RU',
      'disposisi_kadin': '06/01/2025',
      'disposisi_sekdin': '07/01/2025',
      'disposisi_kabid': '08/01/2025',
      'disposisi_kasubag': '08/01/2025',
      'disposisi_lanjutan': 'Pemanfaatan ruang dan bangunan',
      'tindak_lanjut_1': '08/01/2025',
      'tindak_lanjut_2': '30/01/2025',
      'status': 'Proses',
      'dok_final': '',
      'dok_dikirim_tgl': '',
      'tanda_terima': '',
    },
  ];

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

  void refreshEditState() {
  setState(() {
    // Refresh ListView setelah edit data
    // Data suratData udah diupdate di modal
  });
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
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
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
    );
  }

  Widget _buildTableDataLetters(Animation<double> _cardAnimation) {
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aktivitas Terbaru',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF10B981).withValues(alpha: 0.3),
                          Color(0xFF059669).withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.table_chart_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${suratData.length} Data',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Table Container
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth:
                                MediaQuery.of(context).size.width -
                                48, // 48 = padding * 2
                            maxWidth: MediaQuery.of(context).size.width + (MediaQuery.of(context).size.width - 48)
                          ),
                          child: IntrinsicWidth(
                            child: Column(
                              children: [
                                // Header Row
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withValues(alpha: 0.15),
                                        Colors.white.withValues(alpha: 0.08),
                                      ],
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // 1. No - flex: 1
                                      SizedBox(
                                        width: 40,
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 2. Surat dari - flex: 200
                                      SizedBox(width: 20),
                                      Expanded(
                                        flex: 200,
                                        child: Text(
                                          'Surat Dari',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 3. Diterima TGL - flex: 100
                                      SizedBox(width: 8),
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'Diterima TGL',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 4. Tanggal Surat - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'TGL Surat',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 5. Kode - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'Kode',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 6. No Urut - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'No Urut',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 7. No Agenda - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'No Agenda',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 8. No Surat - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 70,
                                        child: Text(
                                          'No \nSurat',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 9. Perihal - flex: 200
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 230,
                                        child: Text(
                                          'Perihal',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 10. Hari/Tanggal - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Hari/Tanggal',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 11. Waktu - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text(
                                            'Waktu',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 12. Tempat - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Tempat',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 13. Disposisi - flex: 100
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Disposisi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 14. Index - flex: 100
                                      Expanded(
                                        flex: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Index',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 15. Pengolah - flex: 100
                                      Expanded(
                                        flex: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Pengolah',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 16. Sifat - flex: 100
                                      Expanded(
                                        flex: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Sifat',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 17. Link Scan - flex: 200
                                      Expanded(
                                        flex: 200,
                                        child: Text(
                                          'Link Scan',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 18. Disposisi Kadin - flex: 100
                                      Expanded(
                                        flex: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Disposisi \nKadin',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 19. Disposisi Sekdin - flex: 100
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'Disposisi \nSekdin',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 20. Disposisi Kabid - flex: 100
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'Disposisi\nKabid/KaUPT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 21. Disposisi Kasubag - flex: 100
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'Disposisi \nKasubag/Kasi',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),

                                      // 22. Disposisi Lanjutan - flex: 200
                                      Expanded(
                                        flex: 130,
                                        child: Text(
                                          'Disposisi \nLanjutan',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 23. Tindak Lanjut 1 - flex: 100
                                      Expanded(
                                        flex: 100,
                                        child: Text(
                                          'Tindak Lanjut 1',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 24. Tindak Lanjut 2 - flex: 100
                                      Expanded(
                                        flex: 110,
                                        child: Text(
                                          'Tindak Lanjut 2',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // 25. Status - flex: 100
                                      Expanded(
                                        flex: 120,
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),

                                      // Actions - width: 100 (fixed)
                                      SizedBox(width: 8),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          'Aksi',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Table Body
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: List.generate(suratData.length, (
                                        index,
                                      ) {
                                        final surat = suratData[index];

                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 1,
                                                ),
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              print(
                                                'Row tapped: ${surat['judul']}',
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4,
                                              ),
                                              child: Row(
                                                children: [
                                                  // 1. No - width: 40 (sama kayak header)
                                                  SizedBox(
                                                    width: 40,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFF4F46E5,
                                                                ).withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                                Color(
                                                                  0xFF7C3AED,
                                                                ).withValues(
                                                                  alpha: 0.2,
                                                                ),
                                                              ],
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        '${index + 1}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // 2. Surat dari - flex: 200
                                                  SizedBox(width: 20),
                                                  Expanded(
                                                    flex: 200,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          surat['surat_dari'],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Roboto',
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          surat['perihal'],
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.7,
                                                                ),
                                                            fontSize: 11,
                                                            fontFamily:
                                                                'Roboto',
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // 3. Diterima tgl - flex: 100
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['diterima_tgl'] ??
                                                          '',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),

                                                  // 4. Tanggal - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['tgl_surat'] ?? '',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),

                                                  // 5. Kode - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['kode'] ?? '',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),

                                                  // 6. No_urut - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['no_urut'] ?? '',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),

                                                  // 7. No_agenda - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['kode'] == null
                                                          ? '404 Not Found'
                                                          : surat['kode'] +
                                                                "/" +
                                                                surat['no_urut'] +
                                                                "/" +
                                                                '35.07.303/2025',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),

                                                  // 8. No surat - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 70,
                                                    child: Text(
                                                      surat['no_surat'] ?? '',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),

                                                  // 9. Perihal - flex: 200
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 230,
                                                    child: Text(
                                                      surat['perihal'] == null
                                                          ? '404 Not Found'
                                                          : surat['perihal'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      overflow:
                                                          TextOverflow.visible,
                                                      softWrap: true,
                                                    ),
                                                  ),

                                                  // 10. Hari/tanggal - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8.0,
                                                      ),
                                                      child: Text(
                                                        surat['hari_tanggal'] ==
                                                                null
                                                            ? '404 Not Found'
                                                            : surat['hari_tanggal'],
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          fontSize: 11,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ),

                                                  // 11. Waktu - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        right: 8,
                                                      ),
                                                      child: Text(
                                                        surat['waktu'] == null
                                                            ? '404 Not Found'
                                                            : surat['waktu'],
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          fontSize: 11,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // 12. Tempat - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                        surat['tempat'] == null
                                                            ? '404 Not Found'
                                                            : surat['tempat'],
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          fontSize: 11,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // 13. Disposisi - flex: 100
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    flex: 100,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                        surat['disposisi'] ==
                                                                null
                                                            ? '404 Not Found'
                                                            : surat['disposisi'],
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          fontSize: 11,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // 14. Index - flex: 100
                                                  Expanded(
                                                    flex: 100,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                        surat['index'] == null
                                                            ? '404 Not Found'
                                                            : surat['index'],
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          fontSize: 11,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // 15. Pengolah - flex: 100
                                                  Expanded(
                                                    flex: 100,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                        surat['pengolah'] ==
                                                                null
                                                            ? '404 Not Found'
                                                            : surat['pengolah'],
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          fontSize: 11,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  ),

                                                  // 16. Sifat - flex: 100
                                                  Expanded(
                                                    flex: 100,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                        surat['sifat'] == null
                                                            ? '404 Not Found'
                                                            : surat['sifat'],
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          fontSize: 11,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // 17. Link scan - flex: 200
                                                  Expanded(
                                                    flex: 200,
                                                    child: Text(
                                                      surat['link_scan'] == null
                                                          ? '404 Not Found'
                                                          : surat['link_scan'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),

                                                  // 18. Disposisi kadin - flex: 100
                                                  Expanded(
                                                    flex: 100,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                        surat['disposisi_kadin'] ==
                                                                null
                                                            ? '404 Not Found'
                                                            : surat['disposisi_kadin'],
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                          fontSize: 11,
                                                          fontFamily: 'Roboto',
                                                        ),
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  ),

                                                  // 19. Disposisi Sekdin - flex: 100
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['disposisi_sekdin'] ==
                                                              null
                                                          ? '404 Not Found'
                                                          : surat['disposisi_sekdin'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),

                                                  // 20. Disposisi Kabid - flex: 100
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['disposisi_kabid'] ==
                                                              null
                                                          ? '404 Not Found'
                                                          : surat['disposisi_kabid'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),

                                                  // 21. Disposisi Kasubag - flex: 100
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['disposisi_kasubag'] ==
                                                              null
                                                          ? '404 Not Found'
                                                          : surat['disposisi_kasubag'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),

                                                  // 22. Disposisi Lanjutan - flex: 200
                                                  Expanded(
                                                    flex: 130,
                                                    child: Text(
                                                      surat['disposisi_lanjutan'] ==
                                                              null
                                                          ? '404 Not Found'
                                                          : surat['disposisi_lanjutan'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),

                                                  // 23. Tindak lanjut 1 - flex: 100
                                                  Expanded(
                                                    flex: 100,
                                                    child: Text(
                                                      surat['tindak_lanjut_1'] ==
                                                              null
                                                          ? '404 Not Found'
                                                          : surat['tindak_lanjut_1'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),

                                                  // 24. Tindak lanjut 2 - flex: 100
                                                  Expanded(
                                                    flex: 110,
                                                    child: Text(
                                                      surat['tindak_lanjut_2'] ==
                                                              null
                                                          ? '404 Not Found'
                                                          : surat['tindak_lanjut_2'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                        fontSize: 11,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),

                                                  // 25. Status - flex: 100
                                                  Expanded(
                                                    flex: 120,
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      widthFactor: 1,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
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
                                                                alpha: 0.8,
                                                              ),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  getStatusColor(
                                                                    surat['status'],
                                                                  ).withValues(
                                                                    alpha: 0.3,
                                                                  ),
                                                              blurRadius: 4,
                                                              offset: Offset(
                                                                0,
                                                                1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          surat['status'],
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily: 'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // Actions - width: 100 (sama kayak header)
                                                  SizedBox(width: 8),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // View button
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                right: 4,
                                                              ),
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          decoration: BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                      0xFF3B82F6,
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.3,
                                                                    ),
                                                                    Color(
                                                                      0xFF1D4ED8,
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.2,
                                                                    ),
                                                                  ],
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              viewDetail(
                                                                context,
                                                                index,
                                                                suratData,
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .visibility_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        // Edit button
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                right: 4,
                                                              ),
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          decoration: BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                      0xFFF59E0B,
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.3,
                                                                    ),
                                                                    Color(
                                                                      0xFFD97706,
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.2,
                                                                    ),
                                                                  ],
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              editDokumen(
                                                                context,
                                                                index,
                                                                suratData,
                                                                refreshEditState
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        // Delete button
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          decoration: BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                      0xFFEF4444,
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.3,
                                                                    ),
                                                                    Color(
                                                                      0xFFDC2626,
                                                                    ).withValues(
                                                                      alpha:
                                                                          0.2,
                                                                    ),
                                                                  ],
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              hapusDokumen(
                                                                context,
                                                                index,
                                                                suratData,
                                                                actionSetState,
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color:
                                                                  Colors.white,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function untuk warna status (pastikan ini ada di class lu)
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Color(0xFF10B981); // Green
      case 'proses':
        return Color(0xFFF59E0B); // Orange
      case 'ditolak':
        return Color(0xFFEF4444); // Red
      default:
        return Color(0xFF6B7280); // Gray
    }
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
                                  'Surat Masuk',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Anda Dapat Mengatur Surat Masuk di Sini!',
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
                                LineIcons.envelopeOpen,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 40),

                        // Recent activity
                        Expanded(child: _buildTableDataLetters(_cardAnimation)),
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
