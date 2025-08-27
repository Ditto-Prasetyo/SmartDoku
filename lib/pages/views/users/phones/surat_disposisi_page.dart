import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/services/surat.dart';
import 'dart:ui';
import 'dart:io';
import 'package:smart_doku/utils/dialog.dart';
import 'package:smart_doku/utils/function.dart';
import 'package:smart_doku/utils/widget.dart';

class DispositionLetterPage extends StatefulWidget {
  final Map<String, dynamic>? suratData;
  const DispositionLetterPage({super.key, this.suratData});

  @override
  State<DispositionLetterPage> createState() => _DispositionLetterPage();
}

class _DispositionLetterPage extends State<DispositionLetterPage>
    with TickerProviderStateMixin {
  var height, width;
  bool isCheckedSangatSegera = false;
  bool isCheckedSegera = false;
  bool isCheckedRahasia = false;
  final TextEditingController nomorUrutController = TextEditingController();

  // Animation controllers and animations
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  SuratMasuk _suratService = SuratMasuk();
  List<SuratMasukModel?> _listSurat = [];
  bool isLoading = true;

  Map<String, dynamic> getDisposisiData() {
    final dataBase = widget.suratData ?? {};

    return {
      'judul': 'Dinas Perumahan, Kawasan Permukiman Dan Cipta Karya',
      'alamat': 'Jl. Trunojoyo Kav 6 Kepanjen, Kabupaten Malang, Jawa Timur',
      'telepon/laman':
          'Telepon (0341) 391679 Laman : perumahan-ciptakarya.malangkab.go.id',
      'pos/kode': 'Pos-el : dppck.mlg@gmail.com, Kode Pos : 65163',
      'judulsurat': 'LEMBAR DISPOSISI',
      'surat_dari': dataBase['surat_dari'] ?? 'HRD Department',
      'diterima_tgl':
          dataBase['diterima_tgl'] ??
          (DateTime.now().day).toString() +
              '/' +
              (DateTime.now().month).toString() +
              '/' +
              (DateTime.now().year).toString(),
      'nomor_surat': dataBase['no_surat'] == null
          ? 'Data Nomor Surat Kosong'
          : dataBase['no_surat'],
      'nomor_agenda':
          '${dataBase['kode'] ?? ''}/${dataBase['no_urut'] ?? ''}/35.07.303/2025',
      'tgl_surat': dataBase['tgl_surat'] ?? '28 Juli 2025',
      'hal': dataBase['perihal'] == null
          ? 'Data Perihal Kosong'
          : dataBase['perihal'],
      'hari_tanggal_waktu': dataBase['hari_tanggal_waktu'],
      'waktu': '09:00 WIB',
      'tempat': dataBase['tempat'],
    };
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

  Future<void> _loadAllData() async {
    print("[DEBUG] -> [INFO] : Loading all data surat masuk ...");
    try {
      final data = await _suratService.listSurat();
      setState(() {
        _listSurat = data;
        isLoading = false;
      });
      print("[DEBUG] -> [STATE] : Set Surat Masuk data to listSurat!");
    } catch (e) {
      setState(() => isLoading = false);
      print("[ERROR] -> gagal load data: $e");
      // tampilkan error dialog modern
      showModernErrorDialog(
        context,
        "Gagal Memuat Data",
        "Tidak dapat mengambil data surat masuk.\nDetail: $e",
        Colors.redAccent,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAllData(); 

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final surat = getDisposisiData();
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
                            "Surat Disposisi",
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
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: buildSectionTitleDisposisi(
                                  'Lembar Disposisi',
                                ),
                              ),
                              buildMenuActionDisposisiAdmin(context, nomorUrutController),
                            ],
                          ),
                          SizedBox(height: 16),
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
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
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
                                          fontSize: 12,
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
                                      bool shouldWrap =
                                          constraints.maxWidth < 600;

                                      if (shouldWrap) {
                                        return Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Text(
                                                'Surat Dari: ${surat['surat_dari'] ?? '404 Not Found'}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
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
                                              child: Text(
                                                'Diterima Tanggal: ${surat['diterima_tgl'] ?? '404 Not Found'}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
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
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    left: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Surat Dari: ${surat['surat_dari'] ?? '404 Not Found'}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
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
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    right: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    left: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
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
                                                    fontSize: 10,
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      bool shouldWrap =
                                          constraints.maxWidth < 600;
                                      if (shouldWrap) {
                                        return Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Text(
                                                'Nomor Urut: ${surat['nomor_surat'] ?? '404 Not Found'}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
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
                                              child: Text(
                                                'Nomor Agenda: ${surat['nomor_agenda'] ?? '404 Not Found'}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
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
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    left: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Nomor Surat: ${surat['nomor_surat'] ?? '404 Not Found'}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
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
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    right: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    left: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
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
                                                    fontSize: 10,
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      bool shouldWrap =
                                          constraints.maxWidth < 600;
                                      if (shouldWrap) {
                                        return Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(12),
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
                                              child: Text(
                                                'Tanggal Surat: ${surat['tgl_surat'] ?? '404 Not Found'}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
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
                                                    MainAxisAlignment
                                                        .spaceEvenly,
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
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
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
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
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
                                                          Container(
                                                            width: 18,
                                                            height: 18,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
                                                                    ),
                                                                width: 1.5,
                                                              ),
                                                              color:
                                                                  isCheckedSegera
                                                                  ? Colors.white
                                                                  : Colors
                                                                        .transparent,
                                                            ),
                                                            child:
                                                                isCheckedSegera
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
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
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
                                                          Container(
                                                            width: 18,
                                                            height: 18,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.8,
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
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 8,
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
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
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
                                                    fontSize: 10,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    right: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
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
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.8,
                                                                      ),
                                                                  width: 1.5,
                                                                ),
                                                                color:
                                                                    isCheckedSangatSegera
                                                                    ? Colors
                                                                          .white
                                                                    : Colors
                                                                          .transparent,
                                                              ),
                                                              child:
                                                                  isCheckedSangatSegera
                                                                  ? Icon(
                                                                      Icons
                                                                          .check,
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
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8,
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
                                                            Container(
                                                              width: 18,
                                                              height: 18,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.8,
                                                                      ),
                                                                  width: 1.5,
                                                                ),
                                                                color:
                                                                    isCheckedSegera
                                                                    ? Colors
                                                                          .white
                                                                    : Colors
                                                                          .transparent,
                                                              ),
                                                              child:
                                                                  isCheckedSegera
                                                                  ? Icon(
                                                                      Icons
                                                                          .check,
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
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8,
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
                                                            Container(
                                                              width: 18,
                                                              height: 18,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.8,
                                                                      ),
                                                                  width: 1.5,
                                                                ),
                                                                color:
                                                                    isCheckedRahasia
                                                                    ? Colors
                                                                          .white
                                                                    : Colors
                                                                          .transparent,
                                                              ),
                                                              child:
                                                                  isCheckedRahasia
                                                                  ? Icon(
                                                                      Icons
                                                                          .check,
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
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8,
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
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
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
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
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
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
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
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),

                                      Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            constraints: BoxConstraints(
                                              minHeight: 80,
                                              maxHeight: 150,
                                            ),
                                            padding: EdgeInsets.only(bottom: 100, left: 12, right: 12),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.3),
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
                                                  padding: EdgeInsets.only(bottom: 80, left: 12, right: 12),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                  padding: EdgeInsets.only(bottom: 80, left: 12, right: 12),
                                                  child: Center(
                                                    child: Text(
                                                      'DISPOSISI KEPALA BIDANG / UPT',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
