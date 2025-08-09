import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_doku/utils/widget.dart';
import 'package:smart_doku/utils/function.dart';

class DetailPageAdmin extends StatefulWidget {
  final Map<String, dynamic>? suratData; // Parameter untuk data surat

  const DetailPageAdmin({super.key, this.suratData});

  @override
  State<DetailPageAdmin> createState() => _DetailPageAdmin();
}

class _DetailPageAdmin extends State<DetailPageAdmin>
    with TickerProviderStateMixin {
  var height, width;

  bool isRefreshing = false;
  bool isSearchActive = false;
  bool showSearchOptions = false;
  String selectedSearchType = 'judul';

  TextEditingController searchController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  // Animation controllers and animations
  late AnimationController _backgroundController;

  late Animation<double> _backgroundAnimation;

  Map<String, dynamic> getDetailData() {
    // Kalau ada data yang di-pass, gabungin dengan detail data
    final baseData = widget.suratData ?? {};

    return {
      'nomor': baseData['id']?.toString() ?? '001',
      'surat_dari': baseData['pengirim'] ?? 'HRD Department',
      'diterima_tgl':
          baseData['diterima_tgl'] ??
          (DateTime.now().day).toString() + '/' +
              (DateTime.now().month).toString() + '/' +
              (DateTime.now().year).toString(),
      'tgl_surat': baseData['tgl_surat'] ?? '28 Juli 2025',
      'kode': 'SR-2025-${baseData['id']?.toString().padLeft(3, '0') ?? '001'}',
      'no_urut': '${baseData['no_urut']?.toString() ?? '1'}/25',
      'no_agenda': baseData['kode'] + '/' + baseData['no_urut'] + '/' + '35.07.303/2025' == null ? 'Data Kosong!' :  baseData['kode'] + '/' + baseData['no_urut'] + '/' + '35.07.303/2025',
      'no_surat': baseData['no_surat'] == null ? 'Data Kosong!' : baseData['no_surat'],
      'hal': baseData['perihal'] == null ? 'Data Kosong!' : baseData['perihal'],
      'hari_tanggal': baseData['hari_tanggal'] == null ? 'Data Kosong!' : baseData['hari_tanggal'],
      'waktu': baseData['waktu'] == null ? 'Data Kosong!' : baseData['waktu'],
      'tempat': baseData['tempat'] == null ? 'Data Kosong!' : baseData['tempat'],
      'disposisi': baseData['disposisi'] == null ? 'Data Kosong!' : baseData['disposisi'],
      'index': 'IDX-${baseData['index']?.toString() == null ? 'Data Kosong!' : baseData['index']}',
      'pengolah': baseData['pengolah'] == null ? 'Data Kosong!' : baseData['pengolah'],
      'sifat': baseData['sifat'] == null ? 'Data Kosong!' : baseData['sifat'],
      'link_scan': baseData['link_scan'] == null ? 'Data Kosong!' : baseData['link_scan'],
      'disp_1': baseData['disposisi_kadin'] == null ? 'Data Kosong!' : baseData['disposisi_kadin'],
      'disp_2': baseData['disposisi_sekdin'] == null ? 'Data Kosong!' : baseData['disposisi_sekdin'],
      'disp_3': baseData['disposisi_kabid'] == null ? 'Data Kosong!' : baseData['disposisi_kabid'],
      'disp_4': baseData['disposisi_kasubag'] == null ? 'Data Kosong!' : baseData['disposisi_kasubag'],
      'notes_disp_1' : baseData['notes_disposisi_kadin'] == null ? 'Data Kosong!' : baseData['notes_disposisi_kadin'],
      'notes_disp_2' : baseData['notes_disposisi_sekdin'] == null ? 'Data Kosong!' : baseData['notes_disposisi_sekdin'],
      'notes_disp_3' : baseData['notes_disposisi_kabid'] == null ? 'Data Kosong!' : baseData['notes_disposisi_kabid'],
      'notes_disp_4' : baseData['notes_disposisi_kasubag'] == null ? 'Data Kosong!' : baseData['notes_disposisi_kasubag'],
      'disp_lanjutan': baseData['disposisi_lanjutan'] == null ? 'Data Kosong!' : baseData['disposisi_lanjutan'],
      'tindak_lanjut_1': baseData['tindak_lanjut_1'] == null ? 'Data Kosong!' : baseData['tindak_lanjut_1'],
      'tindak_lanjut_2': baseData['tindak_lanjut_2'] == null ? 'Data Kosong!' : baseData['tindak_lanjut_2'],
      'status': baseData['status'] == null ? 'Data Kosong!' : baseData['status'],
    };
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

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final detailData = getDetailData();
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
                                    logout;
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
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(),
                  height: height * 0.25,
                  width: width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30, left: 15, right: 15),
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
                                    color: Colors.white.withValues(alpha: 0.1),
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
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.all(4.5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dashboard Title
                      Padding(
                        padding: EdgeInsets.only(top: 35, left: 15, right: 15),
                        child: Center(
                          child: Text(
                            "Detail Surat",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Info Card
                          buildHeaderCard(detailData),

                          SizedBox(height: 20),

                          // Basic Information Section
                          buildSectionTitle('Informasi Dasar'),
                          SizedBox(height: 15),
                          buildInfoCard([
                            buildDetailRow('Nomor', detailData['nomor'] == null ? 'Data Kosong!' : detailData['nomor']),
                            buildDetailRow(
                              'Surat Dari',
                              detailData['surat_dari'] == null ? 'Data Kosong!' : detailData['surat_dari'],
                            ),
                            buildDetailRow(
                              'Diterima Tanggal',
                              detailData['diterima_tgl'] == null ? 'Data Kosong!' : detailData['diterima_tgl'],
                            ),
                            buildDetailRow(
                              'Tanggal Surat',
                              detailData['tgl_surat'] == null ? 'Data Kosong!' : detailData['tgl_surat'],
                            ),
                            buildDetailRow('Kode', detailData['kode'] == null ? 'Data Kosong!' : detailData['kode']),
                            buildDetailRow('No. Urut', detailData['no_urut'] == null ? 'Data Kosong!' : detailData['no_urut']),
                          ]),

                          SizedBox(height: 20),

                          // Document Information Section
                          buildSectionTitle('Informasi Surat'),
                          SizedBox(height: 15),
                          buildInfoCard([
                            buildDetailRow(
                              'No. Agenda',
                              detailData['no_agenda'] == null ? 'Data Kosong!' : detailData['no_agenda'],
                            ),
                            buildDetailRow('No. Surat', detailData['no_surat'] == null ? 'Data Kosong!' : detailData['no_surat']),
                            buildDetailRow('Hal', detailData['hal'] == null ? 'Data Kosong!' : detailData['hal']),
                            buildDetailRow(
                              'Hari/Tanggal',
                              detailData['hari_tanggal'] == null ? 'Data Kosong!' : detailData['hari_tanggal'],
                            ),
                            buildDetailRow('Waktu', detailData['waktu'] == null ? 'Data Kosong!' : detailData['waktu']),
                            buildDetailRow('Tempat', detailData['tempat'] == null ? 'Data Kosong!' : detailData['tempat']),
                          ]),

                          SizedBox(height: 20),

                          // Processing Information Section
                          buildSectionTitle('Informasi Pemrosesan'),
                          SizedBox(height: 15),
                          buildInfoCard([
                            buildDetailRow(
                              'Disposisi',
                              detailData['disposisi'] == null ? 'Data Kosong!' : detailData['disposisi'],
                            ),
                            buildDetailRow('Index', detailData['index']),
                            buildDetailRow('Pengolah', detailData['pengolah'] == null ? 'Data Kosong!' : detailData['pengolah']),
                            buildDetailRow(
                              'Sifat',
                              detailData['sifat'],
                              isStatus: true,
                              statusColor: getSifatColor(detailData['sifat'] == null ? 'Data Kosong!' : detailData['sifat']),
                            ),
                            buildDetailRow(
                              'Link Scan',
                              detailData['link_scan'] == null ? 'Data Kosong!' : detailData['link_scan'],
                              isLink: true,
                            ),
                          ]),

                          SizedBox(height: 20),

                          // Disposition Section
                          buildSectionTitle('Disposisi'),
                          SizedBox(height: 15),
                          buildInfoCard([
                            buildDetailRow(
                              'Disposisi Kadin',
                              detailData['disp_1'] == null ? 'Data Kosong!' : detailData['disp_1'],
                            ),
                            buildDetailRow(
                              'Disposisi Sekdin',
                              detailData['disp_2'] == null ? 'Data Kosong!' : detailData['disp_2'],
                            ),
                            buildDetailRow(
                              'Disposisi Kabid / KaUPT',
                              detailData['disp_3'] == null ? 'Data Kosong!' : detailData['disp_3'],
                            ),
                            buildDetailRow(
                              'Disposisi Kasubag / Kasi',
                              detailData['disp_4'] == null ? 'Data Kosong!' : detailData['disp_4'],
                            ),
                          ]),

                          SizedBox(height: 20),

                          // Disposition Notes Section
                          buildSectionTitle('Catatan Disposisi'),
                          SizedBox(height: 15),
                          buildInfoCard([
                            buildDetailRow(
                              'Catatan Disposisi Kadin',
                              detailData['notes_disp_1'] == null ? 'Data Kosong!' : detailData['notes_disp_1'],
                            ),
                            buildDetailRow(
                              'Catatan Disposisi Sekdin',
                              detailData['notes_disp_2'] == null ? 'Data Kosong!' : detailData['notes_disp_2'],
                            ),
                            buildDetailRow(
                              'Catatan Disposisi Kabid / KaUPT',
                              detailData['notes_disp_3'] == null ? 'Data Kosong!' : detailData['notes_disp_3'],
                            ),
                            buildDetailRow(
                              'Catatan Disposisi Kasubag / Kasi',
                              detailData['notes_disp_4'] == null ? 'Data Kosong!' : detailData['notes_disp_4'],
                            ),
                            buildDetailRow(
                              'Disposisi Lanjutan',
                              detailData['disp_lanjutan'] == null ? 'Data Kosong!' : detailData['disp_lanjutan'],
                            ),
                          ]),

                          SizedBox(height: 20),

                          // Follow Up Section
                          buildSectionTitle('Tindak Lanjut'),
                          SizedBox(height: 15),
                          buildInfoCard([
                            buildDetailRow(
                              'Tindak Lanjut 1',
                              detailData['tindak_lanjut_1'] == null ? 'Data Kosong!' : detailData['tindak_lanjut_1'],
                            ),
                            buildDetailRow(
                              'Tindak Lanjut 2',
                              detailData['tindak_lanjut_2'] == null ? 'Data Kosong!' : detailData['tindak_lanjut_2'],
                            ),
                            buildDetailRow(
                              'Status',
                              detailData['status'] == null ? 'Data Kosong!' : detailData['status'],
                              isStatus: true,
                              statusColor: getStatusColor(detailData['status'] == null ? 'Data Kosong!' : detailData['status']),
                            ),
                          ]),

                          SizedBox(height: 20),

                          // Final Documents Section
                          buildSectionTitle('Dokumen Final'),
                          SizedBox(height: 15),
                          buildInfoCard([
                            buildDetailRow(
                              'Dokumen Final',
                              detailData['dokumen_final'] == null ? 'Data Kosong!' : detailData['dokumen_final'],
                            ),
                            buildDetailRow(
                              'Dokumen Dikirim',
                              detailData['dokumen_dikirim'] == null ? 'Data Kosong!' : detailData['dokumen_dikirim'],
                              isStatus: true,
                              statusColor: getYesNoColor(
                                detailData['dokumen_dikirim'] == null ? 'Data Kosong!' : detailData['dokumen_dikirim'],
                              ),
                            ),
                            buildDetailRow(
                              'Tanda Terima',
                              detailData['tanda_terima'] == null ? 'Data Kosong!' : detailData['tanda_terima'],
                              isStatus: true,
                              statusColor: getTandaTerimaColor(
                                detailData['tanda_terima'] == null ? 'Data Kosong!' : detailData['tanda_terima'],
                              ),
                            ),
                          ]),

                          SizedBox(height: 30),

                          buildBackButtonSection(context),
                        ],
                      ),
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
