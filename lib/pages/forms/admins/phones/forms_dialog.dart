import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/models/user.dart';
import 'package:smart_doku/services/settings.dart';
import 'package:smart_doku/services/surat.dart';
import 'package:smart_doku/services/user.dart';
import 'package:smart_doku/utils/map.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:smart_doku/utils/dropdownDisposisi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

SuratMasuk _suratMasukService = SuratMasuk();
SuratKeluar _suratKeluarService = SuratKeluar();
UserService _userService = UserService();

void showModernTambahSuratFormDialog(
  BuildContext context,
  Color accentColor,
  Color accentColor2,

  Function(SuratMasukModel?) onSuratAdded,
  void Function() refreshState,
) async {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'surat_dari': TextEditingController(),
    'diterima_tgl': TextEditingController(),
    'perihal': TextEditingController(),
    'tanggal': TextEditingController(),
    'tgl_surat': TextEditingController(),
    'kode': TextEditingController(),
    'no_surat': TextEditingController(),
    'hari_tanggal': TextEditingController(),
    'waktu': TextEditingController(),
    'tempat': TextEditingController(),
    'index': TextEditingController(),
    'pengolah': TextEditingController(),
    'sifat': TextEditingController(),
    'link_scan': TextEditingController(),
    'disposisi_kadin': TextEditingController(),
    'disposisi_sekdin': TextEditingController(),
    'disposisi_kabid': TextEditingController(),
    'disposisi_kasubag': TextEditingController(),
    'disposisi_lanjutan': TextEditingController(),
    'notes_disposisi_kadin': TextEditingController(),
    'notes_disposisi_sekdin': TextEditingController(),
    'notes_disposisi_kabid': TextEditingController(),
    'notes_disposisi_kasubag': TextEditingController(),
    'tindak_lanjut_1': TextEditingController(),
    'tindak_lanjut_2': TextEditingController(),
    'notes_tl_1': TextEditingController(),
    'notes_tl_2': TextEditingController(),
    'status': TextEditingController(),
  };
  List<String> selectedDisposisi = [];

  final _appSettings = await AppSettings();
  final suffix1 = await _appSettings.part1;
  final suffix2 = await _appSettings.part3;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Form Tambah Surat Dialog",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return StatefulBuilder(
        builder: (context, setState) {
          final ScrollController _scrollController = ScrollController();
          return SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  height: MediaQuery.of(context).size.height * 0.9,
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
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
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
                            children: [
                              // Header
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Icon container
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
                                            color: accentColor.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.note_add_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(height: 15),

                                    // Title
                                    Text(
                                      'Form Tambah Surat Masuk',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    Text(
                                      'Lengkapi data surat masuk di bawah ini',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      '\nData selengkapnya anda bisa scroll ke bawah!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        height: 1.4,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Form Content
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: ScrollbarTheme(
                                    data: ScrollbarThemeData(
                                      thumbColor: WidgetStateProperty.all(
                                        Colors.white,
                                      ),
                                      thickness: WidgetStateProperty.all(6),
                                    ),
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollController,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                        child: Column(
                                          children: [
                                            // Basic Info Section
                                            _buildSectionTitle(
                                              'Informasi Dasar',
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['surat_dari']!,
                                              label: 'Surat Dari',
                                              icon: Icons.mail_outline_rounded,
                                              required: true,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['perihal']!,
                                              label: 'Perihal',
                                              icon: Icons.subject_rounded,
                                              required: true,
                                              maxLines: 2,
                                            ),

                                            SizedBox(height: 20),

                                            // Date & Time Section
                                            _buildSectionTitle(
                                              'Tanggal & Waktu',
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['diterima_tgl']!,
                                                    label: 'Tanggal Diterima',
                                                    icon: Icons
                                                        .calendar_today_rounded,
                                                    required: true,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['tgl_surat']!,
                                                    label: 'Tanggal Surat',
                                                    icon: Icons
                                                        .date_range_rounded,
                                                    required: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            buildDayDateTimePickerField(
                                              context: context,
                                              controller:
                                                  controllers['hari_tanggal']!,
                                              label: 'Hari, Tanggal',
                                              icon: Icons.event_note_rounded,
                                              required: true,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['tempat']!,
                                              label: 'Tempat',
                                              icon: Icons.location_on_outlined,
                                              required: true,
                                            ),

                                            SizedBox(height: 20),

                                            // Document Info Section
                                            _buildSectionTitle(
                                              'Informasi Dokumen',
                                            ),
                                            _buildModernTextField(
                                              controller: controllers['kode']!,
                                              label: 'Kode',
                                              icon: Icons.code_rounded,
                                              required: true,
                                            ),

                                            _buildModernTextField(
                                              controller:
                                                  controllers['no_surat']!,
                                              label: 'No. Surat',
                                              icon: Icons
                                                  .confirmation_number_rounded,
                                              required: true,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['index']!,
                                                    label: 'Index',
                                                    icon: Icons
                                                        .bookmark_outline_rounded,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['sifat']!,
                                                    label: 'Sifat',
                                                    icon:
                                                        Icons.security_rounded,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            // Process Info Section
                                            _buildSectionTitle(
                                              'Informasi Proses',
                                            ),

                                            // Multi-Select Disposisi Dropdown untuk ADD
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Disposisi',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(15),
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
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // List disposisi yg udah kepilih
                                                      if (selectedDisposisi
                                                          .isNotEmpty) ...[
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: selectedDisposisi.map((
                                                            disp,
                                                          ) {
                                                            return Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 6,
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
                                                                      20,
                                                                    ),
                                                                border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.3,
                                                                      ),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    disp,
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        selectedDisposisi
                                                                            .remove(
                                                                              disp,
                                                                            );
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .white
                                                                          .withValues(
                                                                            alpha:
                                                                                0.8,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        SizedBox(height: 12),
                                                      ],

                                                      // Dropdown untuk nambah disposisi
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.05,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                ),
                                                          ),
                                                        ),
                                                        child: DropdownButtonHideUnderline(
                                                          child: DropdownButton<String>(
                                                            hint: Text(
                                                              'Pilih Disposisi',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha: 1,
                                                                    ),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            value: null,
                                                            isExpanded: true,
                                                            dropdownColor:
                                                                Color(
                                                                  0xFF1F2937,
                                                                ),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Roboto',
                                                            ),
                                                            icon: Icon(
                                                              Icons.add,
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.7,
                                                                  ),
                                                              size: 20,
                                                            ),
                                                            items: listWorkfields
                                                                .where(
                                                                  (
                                                                    field,
                                                                  ) => !selectedDisposisi
                                                                      .contains(
                                                                        field,
                                                                      ),
                                                                )
                                                                .map((field) {
                                                                  return DropdownMenuItem<
                                                                    String
                                                                  >(
                                                                    value:
                                                                        field,
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .work_outline,
                                                                          color: Colors.white.withValues(
                                                                            alpha:
                                                                                0.7,
                                                                          ),
                                                                          size:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Expanded(
                                                                          child: Text(
                                                                            field,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                })
                                                                .toList(),
                                                            onChanged: (String? value) {
                                                              if (value !=
                                                                      null &&
                                                                  !selectedDisposisi
                                                                      .contains(
                                                                        value,
                                                                      )) {
                                                                setState(() {
                                                                  selectedDisposisi
                                                                      .add(
                                                                        value,
                                                                      );
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),

                                            _buildModernTextField(
                                              controller:
                                                  controllers['pengolah']!,
                                              label: 'Pengolah',
                                              icon: Icons
                                                  .admin_panel_settings_rounded,
                                              required: true,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              child: DropdownButtonFormField<String>(
                                                value:
                                                    controllers['status']!
                                                        .text
                                                        .isNotEmpty
                                                    ? controllers['status']!
                                                          .text
                                                    : null,
                                                items:
                                                    [
                                                          'Pending',
                                                          'Proses',
                                                          'Selesai',
                                                          'Ditolak',
                                                        ]
                                                        .map(
                                                          (
                                                            status,
                                                          ) => DropdownMenuItem(
                                                            value: status,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 10,
                                                                  height: 10,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color:
                                                                        getStatusColor(
                                                                          status,
                                                                        ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  status,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.9,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  controllers['status']!.text =
                                                      value ?? '';
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Status wajib diisi';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  labelText: 'Status',
                                                  labelStyle: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.info_outline_rounded,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white
                                                      .withValues(alpha: 0.05),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                        ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.4,
                                                              ),
                                                        ),
                                                      ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.red
                                                              .withValues(
                                                                alpha: 0.9,
                                                              ),
                                                        ),
                                                      ),
                                                ),
                                                dropdownColor: Colors.black
                                                    .withValues(alpha: 0.7),
                                                iconEnabledColor: Colors.white
                                                    .withValues(alpha: 0.9),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 20),

                                            // Disposisi Dates Section
                                            _buildSectionTitle(
                                              'Tanggal Disposisi',
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['disposisi_kadin']!,
                                                    label: 'Disposisi Kadin',
                                                    icon: Icons.person_rounded,
                                                    required: true,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['disposisi_sekdin']!,
                                                    label: 'Disposisi Sekdin',
                                                    icon:
                                                        Icons.person_2_rounded,
                                                    required: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['disposisi_kabid']!,
                                                    label: 'Disposisi Kabid',
                                                    icon:
                                                        Icons.person_3_rounded,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['disposisi_kasubag']!,
                                                    label: 'Disposisi Kasubag',
                                                    icon:
                                                        Icons.person_4_rounded,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            _buildSectionTitle(
                                              'Catatan Disposisi',
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['notes_disposisi_kadin']!,
                                              label: 'Catatan Disposisi Kadin',
                                              icon: Icons.sticky_note_2_rounded,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['notes_disposisi_sekdin']!,
                                              label: 'Catatan Disposisi Sekdin',
                                              icon: Icons.sticky_note_2_rounded,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['notes_disposisi_kabid']!,
                                              label: 'Catatan Disposisi Kabid',
                                              icon: Icons.sticky_note_2_rounded,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['notes_disposisi_kasubag']!,
                                              label:
                                                  'Catatan Disposisi Kasubag',
                                              icon: Icons.sticky_note_2_rounded,
                                            ),
                                            SizedBox(height: 20),

                                            // Additional Info Section
                                            _buildSectionTitle(
                                              'Informasi Tambahan',
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['disposisi_lanjutan']!,
                                              label: 'Disposisi Lanjutan',
                                              icon: Icons.next_plan_rounded,
                                              maxLines: 2,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['tindak_lanjut_1']!,
                                                    label: 'Tindak Lanjut 1',
                                                    icon: Icons
                                                        .playlist_add_check_rounded,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['tindak_lanjut_2']!,
                                                    label: 'Tindak Lanjut 2',
                                                    icon: Icons
                                                        .playlist_add_check_circle_rounded,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['notes_tl_1']!,
                                                    label:
                                                        'Notes Tindak Lanjut 1',
                                                    icon: Icons.notes,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['notes_tl_2']!,
                                                    label:
                                                        'Notes Tindak Lanjut 2',
                                                    icon: Icons.notes,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            // Document Links Section
                                            _buildSectionTitle(
                                              'Dokumen & Link',
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['link_scan']!,
                                              label: 'Link Scan',
                                              icon: Icons.link_rounded,
                                            ),

                                            SizedBox(height: 30),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom Buttons
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Save Button
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            SuratMasukModel?
                                            data = await _suratMasukService.addSurat(
                                              suratDari:
                                                  controllers['surat_dari']
                                                      ?.text,
                                              tanggalDiterima:
                                                  controllers['diterima_tgl']
                                                          ?.text
                                                          .isNotEmpty ==
                                                      true
                                                  ? DateTime.tryParse(
                                                      controllers['diterima_tgl']!
                                                          .text,
                                                    )
                                                  : null,
                                              tanggalSurat:
                                                  controllers['tgl_surat']
                                                          ?.text
                                                          .isNotEmpty ==
                                                      true
                                                  ? DateTime.tryParse(
                                                      controllers['tgl_surat']!
                                                          .text,
                                                    )
                                                  : null,
                                              kode: controllers['kode']?.text,
                                              noSurat:
                                                  controllers['no_surat']?.text,
                                              hal: controllers['perihal']?.text,
                                              tanggalWaktu:
                                                  controllers['hari_tanggal']
                                                          ?.text
                                                          .isNotEmpty ==
                                                      true
                                                  ? DateTime.tryParse(
                                                      controllers['hari_tanggal']!
                                                          .text,
                                                    )
                                                  : null,
                                              tempat:
                                                  controllers['tempat']?.text,
                                              disposisi: selectedDisposisi,
                                              index: controllers['index']?.text,
                                              pengolah:
                                                  controllers['pengolah']?.text,
                                              sifat: controllers['sifat']?.text,
                                              linkScan: controllers['link_scan']
                                                  ?.text,
                                              disp1Kadin:
                                                  controllers['disposisi_kadin']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['disposisi_kadin']!
                                                          .text,
                                                    )
                                                  : null,
                                              disp2Sekdin:
                                                  controllers['disposisi_sekdin']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['disposisi_sekdin']!
                                                          .text,
                                                    )
                                                  : null,
                                              disp3Kabid:
                                                  controllers['disposisi_kabid']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['disposisi_kabid']!
                                                          .text,
                                                    )
                                                  : null,
                                              disp4Kasubag:
                                                  controllers['disposisi_kasubag']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['disposisi_kasubag']!
                                                          .text,
                                                    )
                                                  : null,
                                              disp1Notes:
                                                  controllers['notes_disposisi_kadin']
                                                      ?.text,
                                              disp2Notes:
                                                  controllers['notes_disposisi_sekdin']
                                                      ?.text,
                                              disp3Notes:
                                                  controllers['notes_disposisi_kabid']
                                                      ?.text,
                                              disp4Notes:
                                                  controllers['notes_disposisi_kasubag']
                                                      ?.text,
                                              dispLanjut:
                                                  controllers['disposisi_lanjutan']
                                                      ?.text,
                                              tindakLanjut1:
                                                  controllers['tindak_lanjut_1']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['tindak_lanjut_1']!
                                                          .text,
                                                    )
                                                  : null,
                                              tindakLanjut2:
                                                  controllers['tindak_lanjut_2']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['tindak_lanjut_2']!
                                                          .text,
                                                    )
                                                  : null,
                                              tl1Notes:
                                                  controllers['notes_tl_1']
                                                      ?.text,
                                              tl2Notes:
                                                  controllers['notes_tl_2']
                                                      ?.text,
                                              status:
                                                  controllers['status']?.text,
                                            );

                                            // Call the callback function
                                            onSuratAdded(data);

                                            Navigator.pop(context);

                                            // Show success message
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Surat berhasil ditambahkan!',
                                                ),
                                                backgroundColor: accentColor,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: accentColor.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.save_rounded),
                                            SizedBox(width: 10),
                                            Text(
                                              'Simpan Surat',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    // Cancel Button
                                    Container(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.close_rounded),
                                            SizedBox(width: 10),
                                            Text(
                                              'Batal',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showModernTambahSuratKeluarFormDialog(
  BuildContext context,
  Color accentColor,
  Color accentColor2,
  Function(SuratKeluarModel?) onSuratKeluarAdded,
  void Function() refreshState,
) async {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'kode': TextEditingController(),
    'klasifikasi': TextEditingController(),
    'tujuan_surat': TextEditingController(),
    'perihal': TextEditingController(),
    'tgl_surat': TextEditingController(),
    'klasifikasi_arsip': TextEditingController(),
    'pengolah': TextEditingController(),
    'pembuat': TextEditingController(),
    'catatan': TextEditingController(),
    'link_surat': TextEditingController(),
    'koreksi_1': TextEditingController(),
    'koreksi_2': TextEditingController(),
    'status': TextEditingController(),
    'dok_final': TextEditingController(),
    'dok_dikirim_tgl': TextEditingController(),
    'tanda_terima': TextEditingController(),
  };

  final AppSettings _appSettings = AppSettings();
  final suf1 = _appSettings.part1;
  final suf2 = _appSettings.part3;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Form Tambah Surat Dialog Keluar",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      final ScrollController _scrollController = ScrollController();
      return SafeArea(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              height: MediaQuery.of(context).size.height * 0.9,
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
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
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
                        children: [
                          // Header
                          Container(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                // Icon container
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
                                        color: accentColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.note_add_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(height: 15),

                                // Title
                                Text(
                                  'Form Tambah Surat Keluar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(height: 8),

                                Text(
                                  'Lengkapi data surat keluar di bawah ini',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Text(
                                  '\nData selengkapnya anda bisa scroll ke bawah!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    height: 1.4,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Form Content
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: ScrollbarTheme(
                                data: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ),
                                  thickness: WidgetStateProperty.all(6),
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: _scrollController,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 25,
                                    ),
                                    child: Column(
                                      children: [
                                        // Document Info Section
                                        _buildSectionTitle('Informasi Dokumen'),

                                        _buildModernTextField(
                                          controller: controllers['kode']!,
                                          label: 'Kode',
                                          icon: Icons.qr_code_2_rounded,
                                          required: true,
                                        ),

                                        SizedBox(height: 20),

                                        // Basic Info Section
                                        _buildSectionTitle('Informasi Dasar'),
                                        _buildModernTextField(
                                          controller:
                                              controllers['klasifikasi']!,
                                          label: 'Klasifikasi',
                                          icon: Icons.category_rounded,
                                          required: true,
                                        ),
                                        _buildModernTextField(
                                          controller:
                                              controllers['tujuan_surat']!,
                                          label: 'Tujuan Surat',
                                          icon: Icons.send_rounded,
                                        ),
                                        _buildModernTextField(
                                          controller: controllers['perihal']!,
                                          label: 'Perihal',
                                          icon: Icons.subject_rounded,
                                          required: true,
                                          maxLines: 2,
                                        ),

                                        // Date & Time Section
                                        _buildSectionTitle('Tanggal & Waktu'),
                                        buildDatePickerField(
                                          context: context,
                                          controller: controllers['tgl_surat']!,
                                          label: 'Tanggal Surat',
                                          icon: Icons.date_range_rounded,
                                          required: true,
                                        ),
                                        SizedBox(height: 20),

                                        _buildSectionTitle('Sifat'),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildModernTextField(
                                                controller:
                                                    controllers['klasifikasi_arsip']!,
                                                label:
                                                    'Ket. Klasifikasi Keamanan \n& Akses Arsip',
                                                icon: Icons.security_rounded,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 20),

                                        // Process Info Section
                                        _buildSectionTitle('Informasi Proses'),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: DropdownButtonFormField<String>(
                                            value:
                                                controllers['pengolah']!
                                                    .text
                                                    .isNotEmpty
                                                ? controllers['pengolah']!.text
                                                : null,
                                            items: workFields.entries
                                                .map(
                                                  (entry) => DropdownMenuItem(
                                                    value: entry.value,
                                                    child: Text(
                                                      entry.key,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.9,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              controllers['pengolah']!.text =
                                                  value ?? '';
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Pengolah harus diisi';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Pengolah',
                                              labelStyle: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ),
                                              prefixIcon: Icon(
                                                Icons
                                                    .assignment_turned_in_rounded,
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white
                                                  .withValues(alpha: 0.05),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.4),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.red.withValues(
                                                    alpha: 0.7,
                                                  ),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                    ),
                                                  ),
                                            ),
                                            dropdownColor: Colors.black
                                                .withValues(alpha: 0.7),
                                            iconEnabledColor: Colors.white
                                                .withValues(alpha: 0.9),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        _buildModernTextField(
                                          controller: controllers['pembuat']!,
                                          label: 'Pembuat',
                                          icon: Icons
                                              .admin_panel_settings_rounded,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: DropdownButtonFormField<String>(
                                            value:
                                                controllers['status']!
                                                    .text
                                                    .isNotEmpty
                                                ? controllers['status']!.text
                                                : null,
                                            items:
                                                [
                                                      'Pending',
                                                      'Proses',
                                                      'Selesai',
                                                      'Ditolak',
                                                    ]
                                                    .map(
                                                      (
                                                        status,
                                                      ) => DropdownMenuItem(
                                                        value: status,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 10,
                                                              height: 10,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    getStatusColor(
                                                                      status,
                                                                    ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(status),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged: (value) {
                                              controllers['status']!.text =
                                                  value ?? '';
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Status wajib diisi';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Status',
                                              labelStyle: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.info_outline_rounded,
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white
                                                  .withValues(alpha: 0.05),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.4),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.red.withValues(
                                                    alpha: 0.7,
                                                  ),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                    ),
                                                  ),
                                            ),
                                            dropdownColor: Colors.black
                                                .withValues(alpha: 0.7),
                                            iconEnabledColor: Colors.white
                                                .withValues(alpha: 0.9),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20),

                                        // Additional Info Section
                                        _buildSectionTitle(
                                          'Informasi Tambahan',
                                        ),
                                        _buildModernTextField(
                                          controller: controllers['catatan']!,
                                          label: 'Catatan',
                                          icon: Icons.next_plan_rounded,
                                          maxLines: 2,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildModernTextField(
                                                controller:
                                                    controllers['koreksi_1']!,
                                                label: 'Koreksi 1',
                                                icon: Icons
                                                    .playlist_add_check_rounded,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: _buildModernTextField(
                                                controller:
                                                    controllers['koreksi_2']!,
                                                label: 'Koreksi 2',
                                                icon: Icons
                                                    .playlist_add_check_circle_rounded,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 20),

                                        // Document Links Section
                                        _buildSectionTitle('Dokumen & Link'),
                                        _buildModernTextField(
                                          controller: controllers['dok_final']!,
                                          label: 'Dokumen Final',
                                          icon: Icons.folder_open_rounded,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: buildDatePickerField(
                                                context: context,
                                                controller:
                                                    controllers['dok_dikirim_tgl']!,
                                                label:
                                                    'Tanggal Dokumen Dikirim',
                                                icon: Icons.send_rounded,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: buildDatePickerField(
                                                context: context,
                                                controller:
                                                    controllers['tanda_terima']!,
                                                label: 'Tanda Terima',
                                                icon:
                                                    Icons.receipt_long_rounded,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          // Bottom Buttons
                          Container(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                // Save Button
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        // Create new surat data
                                        // Map<String, dynamic> newSurat = {
                                        //   'id': DateTime.now()
                                        //       .millisecondsSinceEpoch
                                        //       .toString(),
                                        // };

                                        // // Add all controller values to the map
                                        // controllers.forEach((key, controller) {
                                        //   newSurat[key] = controller.text;
                                        // });

                                        SuratKeluarModel?
                                        data = await _suratKeluarService.addSurat(
                                          kode: controllers['kode']?.text,
                                          klasifikasi:
                                              controllers['klasifikasi']?.text,
                                          tujuan_surat:
                                              controllers['tujuan_surat']?.text,
                                          perihal: controllers['perihal']?.text,
                                          tanggal_surat:
                                              controllers['tgl_surat']!
                                                  .text
                                                  .isNotEmpty
                                              ? DateTime.tryParse(
                                                  controllers['tgl_surat']!
                                                      .text,
                                                )
                                              : null,
                                          akses_arsip:
                                              controllers['klasifikasi_arsip']
                                                  ?.text,
                                          pengolah:
                                              controllers['pengolah']?.text,
                                          pembuat: controllers['pembuat']?.text,
                                          catatan: controllers['catatan']?.text,
                                          link_surat:
                                              controllers['link_surat']?.text,
                                          koreksi_1:
                                              controllers['koreksi_1']?.text,
                                          koreksi_2:
                                              controllers['koreksi_2']?.text,
                                          status: controllers['status']?.text,
                                          dok_final:
                                              controllers['dok_final']?.text,
                                          dok_dikirim:
                                              controllers['dok_dikirim_tgl']!
                                                  .text
                                                  .isNotEmpty
                                              ? DateTime.tryParse(
                                                  controllers['dok_dikirim_tgl']!
                                                      .text,
                                                )
                                              : null,
                                          tanda_terima:
                                              controllers['tanda_terima']!
                                                  .text
                                                  .isNotEmpty
                                              ? DateTime.tryParse(
                                                  controllers['tanda_terima']!
                                                      .text,
                                                )
                                              : null,
                                        );

                                        // Call the callback function
                                        onSuratKeluarAdded(data);
                                        refreshState();

                                        Navigator.pop(context);

                                        // Show success message
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Surat berhasil ditambahkan!',
                                            ),
                                            backgroundColor: accentColor,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 8,
                                      shadowColor: accentColor.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.save_rounded),
                                        SizedBox(width: 10),
                                        Text(
                                          'Simpan Surat',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Cancel Button
                                Container(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      side: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close_rounded),
                                        SizedBox(width: 10),
                                        Text(
                                          'Batal',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
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

void showModernTambahSuratMasukFormDialog(
  BuildContext context,
  Color accentColor,
  Color accentColor2,

  Function(SuratMasukModel?) onSuratAdded,
  void Function() refreshState,
) async {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'surat_dari': TextEditingController(),
    'diterima_tgl': TextEditingController(),
    'perihal': TextEditingController(),
    'tanggal': TextEditingController(),
    'tgl_surat': TextEditingController(),
    'kode': TextEditingController(),
    'no_surat': TextEditingController(),
    'hari_tanggal': TextEditingController(),
    'waktu': TextEditingController(),
    'tempat': TextEditingController(),
    'index': TextEditingController(),
    'pengolah': TextEditingController(),
    'sifat': TextEditingController(),
    'link_scan': TextEditingController(),
    'disposisi_kadin': TextEditingController(),
    'disposisi_sekdin': TextEditingController(),
    'disposisi_kabid': TextEditingController(),
    'disposisi_kasubag': TextEditingController(),
    'disposisi_lanjutan': TextEditingController(),
    'notes_disposisi_kadin': TextEditingController(),
    'notes_disposisi_sekdin': TextEditingController(),
    'notes_disposisi_kabid': TextEditingController(),
    'notes_disposisi_kasubag': TextEditingController(),
    'tindak_lanjut_1': TextEditingController(),
    'tindak_lanjut_2': TextEditingController(),
    'notes_tl_1': TextEditingController(),
    'notes_tl_2': TextEditingController(),
    'status': TextEditingController(),
  };
  Size size = MediaQuery.of(context).size;
  List<String> selectedDisposisi = [];

  final _appSettings = await AppSettings();
  final suffix1 = await _appSettings.part1;
  final suffix2 = await _appSettings.part3;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Form Tambah Surat Dialog",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return StatefulBuilder(
        builder: (context, setState) {
          final ScrollController _scrollController = ScrollController();
          return SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width:
                      (Platform.isWindows ||
                          Platform.isLinux ||
                          Platform.isMacOS)
                      ? size.width / 2
                      : size.width,
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
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
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
                            children: [
                              // Header
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Icon container
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
                                            color: accentColor.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.note_add_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(height: 15),

                                    // Title
                                    Text(
                                      'Form Tambah Surat Masuk',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    Text(
                                      'Lengkapi data surat masuk di bawah ini',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      '\nData selengkapnya anda bisa scroll ke bawah!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        height: 1.4,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Form Content
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: ScrollbarTheme(
                                    data: ScrollbarThemeData(
                                      thumbColor: WidgetStateProperty.all(
                                        Colors.white,
                                      ),
                                      thickness: WidgetStateProperty.all(6),
                                    ),
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollController,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                        child: Column(
                                          children: [
                                            // Basic Info Section
                                            _buildSectionTitle(
                                              'Informasi Dasar',
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['surat_dari']!,
                                              label: 'Surat Dari',
                                              icon: Icons.mail_outline_rounded,
                                              required: true,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['perihal']!,
                                              label: 'Perihal',
                                              icon: Icons.subject_rounded,
                                              required: true,
                                              maxLines: 2,
                                            ),

                                            SizedBox(height: 20),

                                            // Date & Time Section
                                            _buildSectionTitle(
                                              'Tanggal & Waktu',
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['diterima_tgl']!,
                                                    label: 'Tanggal Diterima',
                                                    icon: Icons
                                                        .calendar_today_rounded,
                                                    required: true,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['tgl_surat']!,
                                                    label: 'Tanggal Surat',
                                                    icon: Icons
                                                        .date_range_rounded,
                                                    required: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            buildDayDateTimePickerField(
                                              context: context,
                                              controller:
                                                  controllers['hari_tanggal']!,
                                              label: 'Hari, Tanggal',
                                              icon: Icons.event_note_rounded,
                                              required: true,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['tempat']!,
                                              label: 'Tempat',
                                              icon: Icons.location_on_outlined,
                                              required: true,
                                            ),

                                            SizedBox(height: 20),

                                            // Document Info Section
                                            _buildSectionTitle(
                                              'Informasi Dokumen',
                                            ),
                                            _buildModernTextField(
                                              controller: controllers['kode']!,
                                              label: 'Kode',
                                              icon: Icons.code_rounded,
                                              required: true,
                                            ),

                                            _buildModernTextField(
                                              controller:
                                                  controllers['no_surat']!,
                                              label: 'No. Surat',
                                              icon: Icons
                                                  .confirmation_number_rounded,
                                              required: true,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['index']!,
                                                    label: 'Index',
                                                    icon: Icons
                                                        .bookmark_outline_rounded,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['sifat']!,
                                                    label: 'Sifat',
                                                    icon:
                                                        Icons.security_rounded,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            // Process Info Section
                                            _buildSectionTitle(
                                              'Informasi Proses',
                                            ),

                                            // Multi-Select Disposisi Dropdown untuk ADD
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Disposisi',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(15),
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
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // List disposisi yg udah kepilih
                                                      if (selectedDisposisi
                                                          .isNotEmpty) ...[
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: selectedDisposisi.map((
                                                            disp,
                                                          ) {
                                                            return Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 6,
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
                                                                      20,
                                                                    ),
                                                                border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.3,
                                                                      ),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    disp,
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        selectedDisposisi
                                                                            .remove(
                                                                              disp,
                                                                            );
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .white
                                                                          .withValues(
                                                                            alpha:
                                                                                0.8,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        SizedBox(height: 12),
                                                      ],

                                                      // Dropdown untuk nambah disposisi
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.05,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                ),
                                                          ),
                                                        ),
                                                        child: DropdownButtonHideUnderline(
                                                          child: DropdownButton<String>(
                                                            hint: Text(
                                                              'Pilih Disposisi',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha: 1,
                                                                    ),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            value: null,
                                                            isExpanded: true,
                                                            dropdownColor:
                                                                Color(
                                                                  0xFF1F2937,
                                                                ),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Roboto',
                                                            ),
                                                            icon: Icon(
                                                              Icons.add,
                                                              color: Colors
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.7,
                                                                  ),
                                                              size: 20,
                                                            ),
                                                            items: listWorkfields
                                                                .where(
                                                                  (
                                                                    field,
                                                                  ) => !selectedDisposisi
                                                                      .contains(
                                                                        field,
                                                                      ),
                                                                )
                                                                .map((field) {
                                                                  return DropdownMenuItem<
                                                                    String
                                                                  >(
                                                                    value:
                                                                        field,
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .work_outline,
                                                                          color: Colors.white.withValues(
                                                                            alpha:
                                                                                0.7,
                                                                          ),
                                                                          size:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Expanded(
                                                                          child: Text(
                                                                            field,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                })
                                                                .toList(),
                                                            onChanged: (String? value) {
                                                              if (value !=
                                                                      null &&
                                                                  !selectedDisposisi
                                                                      .contains(
                                                                        value,
                                                                      )) {
                                                                setState(() {
                                                                  selectedDisposisi
                                                                      .add(
                                                                        value,
                                                                      );
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),

                                            _buildModernTextField(
                                              controller:
                                                  controllers['pengolah']!,
                                              label: 'Pengolah',
                                              icon: Icons
                                                  .admin_panel_settings_rounded,
                                              required: true,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              child: DropdownButtonFormField<String>(
                                                value:
                                                    controllers['status']!
                                                        .text
                                                        .isNotEmpty
                                                    ? controllers['status']!
                                                          .text
                                                    : null,
                                                items:
                                                    [
                                                          'Pending',
                                                          'Proses',
                                                          'Selesai',
                                                          'Ditolak',
                                                        ]
                                                        .map(
                                                          (
                                                            status,
                                                          ) => DropdownMenuItem(
                                                            value: status,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 10,
                                                                  height: 10,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color:
                                                                        getStatusColor(
                                                                          status,
                                                                        ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  status,
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.9,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                onChanged: (value) {
                                                  controllers['status']!.text =
                                                      value ?? '';
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Status wajib diisi';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  labelText: 'Status',
                                                  labelStyle: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.info_outline_rounded,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white
                                                      .withValues(alpha: 0.05),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                        ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.4,
                                                              ),
                                                        ),
                                                      ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.red
                                                              .withValues(
                                                                alpha: 0.9,
                                                              ),
                                                        ),
                                                      ),
                                                ),
                                                dropdownColor: Colors.black
                                                    .withValues(alpha: 0.7),
                                                iconEnabledColor: Colors.white
                                                    .withValues(alpha: 0.9),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 20),

                                            // Disposisi Dates Section
                                            _buildSectionTitle(
                                              'Tanggal Disposisi',
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['disposisi_kadin']!,
                                                    label: 'Disposisi Kadin',
                                                    icon: Icons.person_rounded,
                                                    required: true,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['disposisi_sekdin']!,
                                                    label: 'Disposisi Sekdin',
                                                    icon:
                                                        Icons.person_2_rounded,
                                                    required: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['disposisi_kabid']!,
                                                    label: 'Disposisi Kabid',
                                                    icon:
                                                        Icons.person_3_rounded,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['disposisi_kasubag']!,
                                                    label: 'Disposisi Kasubag',
                                                    icon:
                                                        Icons.person_4_rounded,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            _buildSectionTitle(
                                              'Catatan Disposisi',
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['notes_disposisi_kadin']!,
                                              label: 'Catatan Disposisi Kadin',
                                              icon: Icons.sticky_note_2_rounded,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['notes_disposisi_sekdin']!,
                                              label: 'Catatan Disposisi Sekdin',
                                              icon: Icons.sticky_note_2_rounded,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['notes_disposisi_kabid']!,
                                              label: 'Catatan Disposisi Kabid',
                                              icon: Icons.sticky_note_2_rounded,
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['notes_disposisi_kasubag']!,
                                              label:
                                                  'Catatan Disposisi Kasubag',
                                              icon: Icons.sticky_note_2_rounded,
                                            ),
                                            SizedBox(height: 20),

                                            // Additional Info Section
                                            _buildSectionTitle(
                                              'Informasi Tambahan',
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['disposisi_lanjutan']!,
                                              label: 'Disposisi Lanjutan',
                                              icon: Icons.next_plan_rounded,
                                              maxLines: 2,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['tindak_lanjut_1']!,
                                                    label: 'Tindak Lanjut 1',
                                                    icon: Icons
                                                        .playlist_add_check_rounded,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: buildDatePickerField(
                                                    context: context,
                                                    controller:
                                                        controllers['tindak_lanjut_2']!,
                                                    label: 'Tindak Lanjut 2',
                                                    icon: Icons
                                                        .playlist_add_check_circle_rounded,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['notes_tl_1']!,
                                                    label:
                                                        'Notes Tindak Lanjut 1',
                                                    icon: Icons.notes,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['notes_tl_2']!,
                                                    label:
                                                        'Notes Tindak Lanjut 2',
                                                    icon: Icons.notes,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            // Document Links Section
                                            _buildSectionTitle(
                                              'Dokumen & Link',
                                            ),
                                            _buildModernTextField(
                                              controller:
                                                  controllers['link_scan']!,
                                              label: 'Link Scan',
                                              icon: Icons.link_rounded,
                                            ),

                                            SizedBox(height: 30),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom Buttons
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Save Button
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            SuratMasukModel?
                                            data = await _suratMasukService.addSurat(
                                              suratDari:
                                                  controllers['surat_dari']
                                                      ?.text,
                                              tanggalDiterima:
                                                  controllers['diterima_tgl']
                                                          ?.text
                                                          .isNotEmpty ==
                                                      true
                                                  ? DateTime.tryParse(
                                                      controllers['diterima_tgl']!
                                                          .text,
                                                    )
                                                  : null,
                                              tanggalSurat:
                                                  controllers['tgl_surat']
                                                          ?.text
                                                          .isNotEmpty ==
                                                      true
                                                  ? DateTime.tryParse(
                                                      controllers['tgl_surat']!
                                                          .text,
                                                    )
                                                  : null,
                                              kode: controllers['kode']?.text,
                                              noSurat:
                                                  controllers['no_surat']?.text,
                                              hal: controllers['perihal']?.text,
                                              tanggalWaktu:
                                                  controllers['hari_tanggal']
                                                          ?.text
                                                          .isNotEmpty ==
                                                      true
                                                  ? DateTime.tryParse(
                                                      controllers['hari_tanggal']!
                                                          .text,
                                                    )
                                                  : null,
                                              tempat:
                                                  controllers['tempat']?.text,
                                              disposisi: selectedDisposisi,
                                              index: controllers['index']?.text,
                                              pengolah:
                                                  controllers['pengolah']?.text,
                                              sifat: controllers['sifat']?.text,
                                              linkScan: controllers['link_scan']
                                                  ?.text,
                                              disp1Kadin:
                                                  controllers['disposisi_kadin']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['disposisi_kadin']!
                                                          .text,
                                                    )
                                                  : null,
                                              disp2Sekdin:
                                                  controllers['disposisi_sekdin']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['disposisi_sekdin']!
                                                          .text,
                                                    )
                                                  : null,
                                              disp3Kabid:
                                                  controllers['disposisi_kabid']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['disposisi_kabid']!
                                                          .text,
                                                    )
                                                  : null,
                                              disp4Kasubag:
                                                  controllers['disposisi_kasubag']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['disposisi_kasubag']!
                                                          .text,
                                                    )
                                                  : null,
                                              disp1Notes:
                                                  controllers['notes_disposisi_kadin']
                                                      ?.text,
                                              disp2Notes:
                                                  controllers['notes_disposisi_sekdin']
                                                      ?.text,
                                              disp3Notes:
                                                  controllers['notes_disposisi_kabid']
                                                      ?.text,
                                              disp4Notes:
                                                  controllers['notes_disposisi_kasubag']
                                                      ?.text,
                                              dispLanjut:
                                                  controllers['disposisi_lanjutan']
                                                      ?.text,
                                              tindakLanjut1:
                                                  controllers['tindak_lanjut_1']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['tindak_lanjut_1']!
                                                          .text,
                                                    )
                                                  : null,
                                              tindakLanjut2:
                                                  controllers['tindak_lanjut_2']!
                                                      .text
                                                      .isNotEmpty
                                                  ? DateTime.tryParse(
                                                      controllers['tindak_lanjut_2']!
                                                          .text,
                                                    )
                                                  : null,
                                              tl1Notes:
                                                  controllers['notes_tl_1']
                                                      ?.text,
                                              tl2Notes:
                                                  controllers['notes_tl_2']
                                                      ?.text,
                                              status:
                                                  controllers['status']?.text,
                                            );

                                            // Call the callback function
                                            onSuratAdded(data);

                                            refreshState();

                                            Navigator.pop(context);

                                            // Show success message
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Surat berhasil ditambahkan!',
                                                ),
                                                backgroundColor: accentColor,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: accentColor.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.save_rounded),
                                            SizedBox(width: 10),
                                            Text(
                                              'Simpan Surat',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    // Cancel Button
                                    Container(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.close_rounded),
                                            SizedBox(width: 10),
                                            Text(
                                              'Batal',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showModernTambahSuratKeluarFormDesktopDialog(
  BuildContext context,
  Color accentColor,
  Color accentColor2,
  Function(SuratKeluarModel?) onSuratKeluarAdded,
  void Function() refreshState,
) async {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'kode': TextEditingController(),
    'klasifikasi': TextEditingController(),
    'no_register': TextEditingController(),
    'tujuan_surat': TextEditingController(),
    'perihal': TextEditingController(),
    'tgl_surat': TextEditingController(),
    'klasifikasi_arsip': TextEditingController(),
    'pengolah': TextEditingController(),
    'pembuat': TextEditingController(),
    'catatan': TextEditingController(),
    'link_surat': TextEditingController(),
    'koreksi_1': TextEditingController(),
    'koreksi_2': TextEditingController(),
    'status': TextEditingController(),
    'dok_final': TextEditingController(),
    'dok_dikirim_tgl': TextEditingController(),
    'tanda_terima': TextEditingController(),
  };

  final AppSettings _appSettings = AppSettings();
  final suf1 = _appSettings.part1;
  final suf2 = _appSettings.part3;

  Size size = MediaQuery.of(context).size;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Form Tambah Surat Dialog Keluar",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      final ScrollController _scrollController = ScrollController();
      return SafeArea(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              height: MediaQuery.of(context).size.height * 0.9,
              width:
                  (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                  ? size.width / 2
                  : size.width,
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
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
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
                        children: [
                          // Header
                          Container(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                // Icon container
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
                                        color: accentColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.note_add_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(height: 15),

                                // Title
                                Text(
                                  'Form Tambah Surat Keluar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(height: 8),

                                Text(
                                  'Lengkapi data surat keluar di bawah ini',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Text(
                                  '\nData selengkapnya anda bisa scroll ke bawah!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    height: 1.4,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Form Content
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: ScrollbarTheme(
                                data: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ),
                                  thickness: WidgetStateProperty.all(6),
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: _scrollController,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 25,
                                    ),
                                    child: Column(
                                      children: [
                                        // Document Info Section
                                        _buildSectionTitle('Informasi Dokumen'),

                                        _buildModernTextField(
                                          controller: controllers['kode']!,
                                          label: 'Kode',
                                          icon: Icons.qr_code_2_rounded,
                                          required: true,
                                        ),

                                        SizedBox(height: 20),

                                        // Basic Info Section
                                        _buildSectionTitle('Informasi Dasar'),
                                        _buildModernTextField(
                                          controller:
                                              controllers['klasifikasi']!,
                                          label: 'Klasifikasi',
                                          icon: Icons.category_rounded,
                                          required: true,
                                        ),
                                        _buildModernTextField(
                                          controller:
                                              controllers['tujuan_surat']!,
                                          label: 'Tujuan Surat',
                                          icon: Icons.send_rounded,
                                        ),
                                        _buildModernTextField(
                                          controller: controllers['perihal']!,
                                          label: 'Perihal',
                                          icon: Icons.subject_rounded,
                                          required: true,
                                          maxLines: 2,
                                        ),

                                        // Date & Time Section
                                        _buildSectionTitle('Tanggal & Waktu'),
                                        buildDatePickerField(
                                          context: context,
                                          controller: controllers['tgl_surat']!,
                                          label: 'Tanggal Surat',
                                          icon: Icons.date_range_rounded,
                                          required: true,
                                        ),
                                        SizedBox(height: 20),

                                        _buildSectionTitle('Sifat'),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildModernTextField(
                                                controller:
                                                    controllers['klasifikasi_arsip']!,
                                                label:
                                                    'Ket. Klasifikasi Keamanan \n& Akses Arsip',
                                                icon: Icons.security_rounded,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 20),

                                        // Process Info Section
                                        _buildSectionTitle('Informasi Proses'),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: DropdownButtonFormField<String>(
                                            value:
                                                controllers['pengolah']!
                                                    .text
                                                    .isNotEmpty
                                                ? controllers['pengolah']!.text
                                                : null,
                                            items: workFields.entries
                                                .map(
                                                  (entry) => DropdownMenuItem(
                                                    value: entry.value,
                                                    child: Text(
                                                      entry.key,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withValues(
                                                              alpha: 0.9,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              controllers['pengolah']!.text =
                                                  value ?? '';
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Pengolah harus diisi';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Pengolah',
                                              labelStyle: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ),
                                              prefixIcon: Icon(
                                                Icons
                                                    .assignment_turned_in_rounded,
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white
                                                  .withValues(alpha: 0.05),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.4),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.red.withValues(
                                                    alpha: 0.7,
                                                  ),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                    ),
                                                  ),
                                            ),
                                            dropdownColor: Colors.black
                                                .withValues(alpha: 0.7),
                                            iconEnabledColor: Colors.white
                                                .withValues(alpha: 0.9),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        _buildModernTextField(
                                          controller: controllers['pembuat']!,
                                          label: 'Pembuat',
                                          icon: Icons
                                              .admin_panel_settings_rounded,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: DropdownButtonFormField<String>(
                                            value:
                                                controllers['status']!
                                                    .text
                                                    .isNotEmpty
                                                ? controllers['status']!.text
                                                : null,
                                            items:
                                                [
                                                      'Pending',
                                                      'Proses',
                                                      'Selesai',
                                                      'Ditolak',
                                                    ]
                                                    .map(
                                                      (
                                                        status,
                                                      ) => DropdownMenuItem(
                                                        value: status,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 10,
                                                              height: 10,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    getStatusColor(
                                                                      status,
                                                                    ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(status),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged: (value) {
                                              controllers['status']!.text =
                                                  value ?? '';
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Status wajib diisi';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Status',
                                              labelStyle: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ),
                                              prefixIcon: Icon(
                                                Icons.info_outline_rounded,
                                                color: Colors.white.withValues(
                                                  alpha: 0.9,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white
                                                  .withValues(alpha: 0.05),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.4),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide(
                                                  color: Colors.red.withValues(
                                                    alpha: 0.7,
                                                  ),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.9,
                                                          ),
                                                    ),
                                                  ),
                                            ),
                                            dropdownColor: Colors.black
                                                .withValues(alpha: 0.7),
                                            iconEnabledColor: Colors.white
                                                .withValues(alpha: 0.9),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20),

                                        // Additional Info Section
                                        _buildSectionTitle(
                                          'Informasi Tambahan',
                                        ),
                                        _buildModernTextField(
                                          controller: controllers['catatan']!,
                                          label: 'Catatan',
                                          icon: Icons.next_plan_rounded,
                                          maxLines: 2,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildModernTextField(
                                                controller:
                                                    controllers['koreksi_1']!,
                                                label: 'Koreksi 1',
                                                icon: Icons
                                                    .playlist_add_check_rounded,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: _buildModernTextField(
                                                controller:
                                                    controllers['koreksi_2']!,
                                                label: 'Koreksi 2',
                                                icon: Icons
                                                    .playlist_add_check_circle_rounded,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 20),

                                        // Document Links Section
                                        _buildSectionTitle('Dokumen & Link'),
                                        _buildModernTextField(
                                          controller: controllers['dok_final']!,
                                          label: 'Dokumen Final',
                                          icon: Icons.folder_open_rounded,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: buildDatePickerField(
                                                context: context,
                                                controller:
                                                    controllers['dok_dikirim_tgl']!,
                                                label:
                                                    'Tanggal Dokumen Dikirim',
                                                icon: Icons.send_rounded,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: buildDatePickerField(
                                                context: context,
                                                controller:
                                                    controllers['tanda_terima']!,
                                                label: 'Tanda Terima',
                                                icon:
                                                    Icons.receipt_long_rounded,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          // Bottom Buttons
                          Container(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                // Save Button
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        // Create new surat data
                                        // Map<String, dynamic> newSurat = {
                                        //   'id': DateTime.now()
                                        //       .millisecondsSinceEpoch
                                        //       .toString(),
                                        // };

                                        // // Add all controller values to the map
                                        // controllers.forEach((key, controller) {
                                        //   newSurat[key] = controller.text;
                                        // });

                                        SuratKeluarModel?
                                        data = await _suratKeluarService.addSurat(
                                          kode: controllers['kode']?.text,
                                          klasifikasi:
                                              controllers['klasifikasi']?.text,
                                          tujuan_surat:
                                              controllers['tujuan_surat']?.text,
                                          perihal: controllers['perihal']?.text,
                                          tanggal_surat:
                                              controllers['tgl_surat']!
                                                  .text
                                                  .isNotEmpty
                                              ? DateTime.tryParse(
                                                  controllers['tgl_surat']!
                                                      .text,
                                                )
                                              : null,
                                          akses_arsip:
                                              controllers['klasifikasi_arsip']
                                                  ?.text,
                                          pengolah:
                                              controllers['pengolah']?.text,
                                          pembuat: controllers['pembuat']?.text,
                                          catatan: controllers['catatan']?.text,
                                          link_surat:
                                              controllers['link_surat']?.text,
                                          koreksi_1:
                                              controllers['koreksi_1']?.text,
                                          koreksi_2:
                                              controllers['koreksi_2']?.text,
                                          status: controllers['status']?.text,
                                          dok_final:
                                              controllers['dok_final']?.text,
                                          dok_dikirim:
                                              controllers['dok_dikirim_tgl']!
                                                  .text
                                                  .isNotEmpty
                                              ? DateTime.tryParse(
                                                  controllers['dok_dikirim_tgl']!
                                                      .text,
                                                )
                                              : null,
                                          tanda_terima:
                                              controllers['tanda_terima']!
                                                  .text
                                                  .isNotEmpty
                                              ? DateTime.tryParse(
                                                  controllers['tanda_terima']!
                                                      .text,
                                                )
                                              : null,
                                        );

                                        // Call the callback function
                                        onSuratKeluarAdded(data);

                                        refreshState();

                                        Navigator.pop(context);

                                        // Show success message
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Surat berhasil ditambahkan!',
                                            ),
                                            backgroundColor: accentColor,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 8,
                                      shadowColor: accentColor.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.save_rounded),
                                        SizedBox(width: 10),
                                        Text(
                                          'Simpan Surat',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Cancel Button
                                Container(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      side: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close_rounded),
                                        SizedBox(width: 10),
                                        Text(
                                          'Batal',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
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

void showModernTambahUserFormDialog(
  BuildContext context,
  String bidang,
  Color accentColor,
  Color accentColor2,
  Function(UserModel?) onUserAdded,
  void Function() refreshState,
) async {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'username': TextEditingController(),
    'email': TextEditingController(),
    'bidang': TextEditingController(),
    'role': TextEditingController(),
    'address': TextEditingController(),
    'phone_number': TextEditingController(),
    'password': TextEditingController(),
  };
  controllers['bidang']!.text = bidang;
  Size size = MediaQuery.of(context).size;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Form Tambah User",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return StatefulBuilder(
        builder: (context, setState) {
          final ScrollController _scrollController = ScrollController();
          return SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width:
                      (Platform.isWindows ||
                          Platform.isLinux ||
                          Platform.isMacOS)
                      ? size.width / 2
                      : size.width,
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
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
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
                            children: [
                              // Header
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Icon container
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
                                            color: accentColor.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.note_add_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(height: 15),

                                    // Title
                                    Text(
                                      'Form Tambah User',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    Text(
                                      'Lengkapi data user di bawah ini',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      '\nData selengkapnya anda bisa scroll ke bawah!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        height: 1.4,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Form Content
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: ScrollbarTheme(
                                    data: ScrollbarThemeData(
                                      thumbColor: WidgetStateProperty.all(
                                        Colors.white,
                                      ),
                                      thickness: WidgetStateProperty.all(6),
                                    ),
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollController,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                        child: Column(
                                          children: [
                                            // Basic Info Section
                                            _buildSectionTitle(
                                              'Informasi User',
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['name']!,
                                                    label: 'Nama User',
                                                    icon: Icons.person,
                                                    required: true,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['username']!,
                                                    label: 'Username User',
                                                    icon: Icons.alternate_email,
                                                    required: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            _buildModernTextField(
                                              controller: controllers['email']!,
                                              label: 'Email User',
                                              icon: Icons.email,
                                              required: true,
                                            ),
                                            SizedBox(height: 5),
                                            _buildModernTextUserBidangField(
                                              controller:
                                                  controllers['bidang']!,
                                              label: 'Bidang',
                                              icon: Icons.work_outline,
                                              isRequired: true,
                                              // === Kunci nilai dari controller ===
                                              lockFromController: true,
                                            ),
                                            SizedBox(height: 5),
                                            // Dropdwon untuk add user role
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              child: DropdownButtonFormField<String>(
                                                value:
                                                    controllers['role']!
                                                        .text
                                                        .isNotEmpty
                                                    ? controllers['role']!.text
                                                    : null,
                                                items: roleField.entries
                                                    .map(
                                                      (entry) =>
                                                          DropdownMenuItem(
                                                            value: entry.value,
                                                            child: Text(
                                                              entry.key,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.9,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                    )
                                                    .toList(),
                                                onChanged: (value) {
                                                  controllers['role']!.text =
                                                      value ?? '';
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Role harus diisi';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  labelText: 'Role',
                                                  labelStyle: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.badge,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white
                                                      .withValues(alpha: 0.05),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                        ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.4,
                                                              ),
                                                        ),
                                                      ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.red
                                                              .withValues(
                                                                alpha: 0.9,
                                                              ),
                                                        ),
                                                      ),
                                                ),
                                                dropdownColor: Colors.black
                                                    .withValues(alpha: 0.7),
                                                iconEnabledColor: Colors.white
                                                    .withValues(alpha: 0.9),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                            // More info user
                                            _buildSectionTitle(
                                              'Informasi Tambahan User',
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['address']!,
                                                    label: 'Alamat User',
                                                    icon: Icons.home,
                                                    required: true,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['phone_number']!,
                                                    label: 'Nomor Telepon User',
                                                    icon: Icons.phone,
                                                    required: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),

                                            _buildModernTextField(
                                              controller:
                                                  controllers['password']!,
                                              label: 'Password User',
                                              icon: Icons.password,
                                              required: true,
                                            ),

                                            SizedBox(height: 30),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom Buttons
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Save Button
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            UserModel?
                                            data = await _userService.addUser(
                                              name: controllers['name']?.text,
                                              username:
                                                  controllers['username']?.text,
                                              email: controllers['email']?.text,
                                              bidang:
                                                  controllers['bidang']?.text,
                                              role: controllers['role']?.text,
                                              address:
                                                  controllers['address']?.text,
                                              phone: controllers['phone_number']
                                                  ?.text,
                                              password:
                                                  controllers['password']?.text,
                                            );

                                            // Call the callback function
                                            onUserAdded(data);

                                            refreshState();

                                            Navigator.pop(context);

                                            // Show success message
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Surat berhasil ditambahkan!',
                                                ),
                                                backgroundColor: accentColor,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: accentColor.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.save_rounded),
                                            SizedBox(width: 10),
                                            Text(
                                              'Simpan Surat',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    // Cancel Button
                                    Container(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.close_rounded),
                                            SizedBox(width: 10),
                                            Text(
                                              'Batal',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showModernTambahUserFormPhoneDialog(
  BuildContext context,
  Color accentColor,
  Color accentColor2,
  Function(UserModel?) onUserAdded,
  void Function() refreshState,
) async {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'username': TextEditingController(),
    'email': TextEditingController(),
    'bidang': TextEditingController(),
    'role': TextEditingController(),
    'address': TextEditingController(),
    'phone_number': TextEditingController(),
    'password': TextEditingController(),
  };
  Size size = MediaQuery.of(context).size;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Form Tambah User",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return StatefulBuilder(
        builder: (context, setState) {
          final ScrollController _scrollController = ScrollController();
          return SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width:
                      (Platform.isWindows ||
                          Platform.isLinux ||
                          Platform.isMacOS)
                      ? size.width / 2
                      : size.width,
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
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
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
                            children: [
                              // Header
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Icon container
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
                                            color: accentColor.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.note_add_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(height: 15),

                                    // Title
                                    Text(
                                      'Form Tambah User',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    Text(
                                      'Lengkapi data user di bawah ini',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      '\nData selengkapnya anda bisa scroll ke bawah!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        height: 1.4,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Form Content
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: ScrollbarTheme(
                                    data: ScrollbarThemeData(
                                      thumbColor: WidgetStateProperty.all(
                                        Colors.white,
                                      ),
                                      thickness: WidgetStateProperty.all(6),
                                    ),
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollController,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                        child: Column(
                                          children: [
                                            // Basic Info Section
                                            _buildSectionTitle(
                                              'Informasi User',
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['name']!,
                                                    label: 'Nama User',
                                                    icon: Icons.person,
                                                    required: true,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['username']!,
                                                    label: 'Username User',
                                                    icon: Icons.alternate_email,
                                                    required: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            _buildModernTextField(
                                              controller: controllers['email']!,
                                              label: 'Email User',
                                              icon: Icons.email,
                                              required: true,
                                            ),
                                            SizedBox(height: 5),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              child: DropdownButtonFormField<String>(
                                                isExpanded: true,
                                                value:
                                                    controllers['bidang']!
                                                        .text
                                                        .isNotEmpty
                                                    ? controllers['bidang']!.text
                                                    : null,
                                                items: workFields.entries
                                                    .map(
                                                      (entry) =>
                                                          DropdownMenuItem(
                                                            value: entry.value,
                                                            child: Text(
                                                              entry.key,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.9,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                    )
                                                    .toList(),
                                                onChanged: (value) {
                                                  controllers['bidang']!.text =
                                                      value ?? '';
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Bidang harus diisi';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  labelText: 'Bidang',
                                                  labelStyle: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.work,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white
                                                      .withValues(alpha: 0.05),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                        ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.4,
                                                              ),
                                                        ),
                                                      ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.red
                                                              .withValues(
                                                                alpha: 0.9,
                                                              ),
                                                        ),
                                                      ),
                                                ),
                                                dropdownColor: Colors.black
                                                    .withValues(alpha: 0.7),
                                                iconEnabledColor: Colors.white
                                                    .withValues(alpha: 0.9),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 5),
                                            // Dropdwon untuk add user role
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              child: DropdownButtonFormField<String>(
                                                value:
                                                    controllers['role']!
                                                        .text
                                                        .isNotEmpty
                                                    ? controllers['role']!.text
                                                    : null,
                                                items: roleField.entries
                                                    .map(
                                                      (entry) =>
                                                          DropdownMenuItem(
                                                            value: entry.value,
                                                            child: Text(
                                                              entry.key,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.9,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                    )
                                                    .toList(),
                                                onChanged: (value) {
                                                  controllers['role']!.text =
                                                      value ?? '';
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Role harus diisi';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  labelText: 'Role',
                                                  labelStyle: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.badge,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white
                                                      .withValues(alpha: 0.05),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                        ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.white
                                                              .withValues(
                                                                alpha: 0.4,
                                                              ),
                                                        ),
                                                      ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    borderSide: BorderSide(
                                                      color: Colors.red
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.red
                                                              .withValues(
                                                                alpha: 0.9,
                                                              ),
                                                        ),
                                                      ),
                                                ),
                                                dropdownColor: Colors.black
                                                    .withValues(alpha: 0.7),
                                                iconEnabledColor: Colors.white
                                                    .withValues(alpha: 0.9),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                            // More info user
                                            _buildSectionTitle(
                                              'Informasi Tambahan User',
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['address']!,
                                                    label: 'Alamat User',
                                                    icon: Icons.home,
                                                    required: true,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: _buildModernTextField(
                                                    controller:
                                                        controllers['phone_number']!,
                                                    label: 'Nomor Telepon User',
                                                    icon: Icons.phone,
                                                    required: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),

                                            _buildModernTextField(
                                              controller:
                                                  controllers['password']!,
                                              label: 'Password User',
                                              icon: Icons.password,
                                              required: true,
                                            ),

                                            SizedBox(height: 30),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom Buttons
                              Container(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // Save Button
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            UserModel?
                                            data = await _userService.addUser(
                                              name: controllers['name']?.text,
                                              username:
                                                  controllers['username']?.text,
                                              email: controllers['email']?.text,
                                              bidang:
                                                  controllers['bidang']?.text,
                                              role: controllers['role']?.text,
                                              address:
                                                  controllers['address']?.text,
                                              phone: controllers['phone_number']
                                                  ?.text,
                                              password:
                                                  controllers['password']?.text,
                                            );

                                            // Call the callback function
                                            onUserAdded(data);

                                            refreshState();

                                            Navigator.pop(context);

                                            // Show success message
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Surat berhasil ditambahkan!',
                                                ),
                                                backgroundColor: accentColor,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: accentColor.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.save_rounded),
                                            SizedBox(width: 10),
                                            Text(
                                              'Simpan Surat',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),

                                    // Cancel Button
                                    Container(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.close_rounded),
                                            SizedBox(width: 10),
                                            Text(
                                              'Batal',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildSectionTitle(String title) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.only(bottom: 15, top: 10),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.5,
        decoration: TextDecoration.none,
      ),
    ),
  );
}

Widget _buildModernTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool required = false,
  int maxLines = 1,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            }
          : null,
    ),
  );
}

Widget _buildModernTextUserBidangField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool isRequired = false,
  int maxLines = 1,

  // Opsi A: kirim langsung dari param form (mis. formParams['bidang'])
  String? fixedValue,

  // Opsi B: kalau true, dia bakal nge-lock nilai yang udah ada di controller.text
  // Cocok kalau lo sebelumnya sudah set controller dari param form.
  bool lockFromController = false,

  // Bisa matiin manual tanpa fixed value, kalau perlu.
  bool disabled = false,
}) {
  // Tentukan final fixed (prioritas: fixedValue param > lockFromController)
  final String? resolvedFixed =
      fixedValue ??
      (lockFromController && controller.text.isNotEmpty
          ? controller.text
          : null);

  // Sync ke controller biar bisa diakses di bawah (submit, dsb)
  if (resolvedFixed != null && controller.text != resolvedFixed) {
    controller.text = resolvedFixed;
  }

  final bool isFixed = resolvedFixed != null;
  final bool isEnabled = !isFixed && !disabled;

  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: !isEnabled,
      enabled: isEnabled,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (isRequired && isEnabled)
          ? (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            }
          : null,
    ),
  );
}

Widget buildDatePickerField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool required = false,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      readOnly: true, // Biar ga bisa ketik manual
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: _modernDecoration(label, icon, required),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        final selectedDate = pickedDate?.toIso8601String() == null
            ? null
            : pickedDate!.toIso8601String() + "Z";

        if (pickedDate != null) {
          controller.text = selectedDate!;
        }
      },
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            }
          : null,
    ),
  );
}

Widget buildTimePickerField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool required = false,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: _modernDecoration(label, icon, required),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final now = DateTime.now();
          final selectedTime = DateTime(
            now.year,
            now.month,
            now.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          final selectedTimeIso = selectedTime.toIso8601String() + "Z";
          controller.text = selectedTimeIso;
        }
      },
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            }
          : null,
    ),
  );
}

Widget buildDayDatePickerField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool required = false,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: _modernDecoration(label, icon, required),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          locale: const Locale('id', 'ID'), // Biar bahasa Indonesia
        );

        final selectedDate = pickedDate?.toUtc().toIso8601String();

        if (pickedDate != null) {
          String formattedDay = DateFormat(
            'EEEE',
            'id_ID',
          ).format(pickedDate); // Hari
          controller.text = selectedDate!;
        }
      },
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            }
          : null,
    ),
  );
}

Widget buildDayDateTimePickerField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool required = false,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      style: TextStyle(color: Colors.white, fontSize: 14),
      decoration: _modernDecoration(label, icon, required),
      onTap: () async {
        // Pilih Tanggal
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          locale: const Locale('id', 'ID'),
        );

        if (pickedDate != null) {
          // Pilih Jam
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (pickedTime != null) {
            final combinedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            final selectedDateTime = combinedDateTime.toIso8601String() + "Z";

            controller.text = selectedDateTime;
          }
        }
      },
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib diisi';
              }
              return null;
            }
          : null,
    ),
  );
}

InputDecoration _modernDecoration(String label, IconData icon, bool required) {
  return InputDecoration(
    labelText: label + (required ? ' *' : ''),
    labelStyle: TextStyle(
      color: Colors.white.withValues(alpha: 0.8),
      fontSize: 14,
    ),
    prefixIcon: Icon(
      icon,
      color: Colors.white.withValues(alpha: 0.8),
      size: 20,
    ),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.white.withValues(alpha: 0.3),
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.white.withValues(alpha: 0.3),
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'selesai':
      return Color(0xFF10B981);
    case 'proses':
      return Color(0xFF3B82F6);
    case 'terbatas':
      return Colors.orange;
    case 'ditolak':
      return Colors.red;
    case 'pending':
      return Colors.yellow;
    default:
      return Color(0xFF6B7280);
  }
}
