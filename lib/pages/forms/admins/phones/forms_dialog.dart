import 'package:flutter/material.dart';
import 'dart:ui';

void showModernTambahSuratFormDialog(
  BuildContext context,
  Color accentColor,
  Color accentColor2,
  Function(Map<String, dynamic>) onSuratAdded,
) {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'surat_dari': TextEditingController(),
    'diterima_tgl': TextEditingController(),
    'perihal': TextEditingController(),
    'tanggal': TextEditingController(),
    'pengirim': TextEditingController(),
    'tgl_surat': TextEditingController(),
    'kode': TextEditingController(),
    'no_urut': TextEditingController(),
    'no_surat': TextEditingController(),
    'hari_tanggal': TextEditingController(),
    'waktu': TextEditingController(),
    'tempat': TextEditingController(),
    'disposisi': TextEditingController(),
    'index': TextEditingController(),
    'pengolah': TextEditingController(),
    'sifat': TextEditingController(),
    'link_scan': TextEditingController(),
    'disposisi_kadin': TextEditingController(),
    'disposisi_sekdin': TextEditingController(),
    'disposisi_kabid': TextEditingController(),
    'disposisi_kasubag': TextEditingController(),
    'disposisi_lanjutan': TextEditingController(),
    'tindak_lanjut_1': TextEditingController(),
    'tindak_lanjut_2': TextEditingController(),
    'status': TextEditingController(),
    'dok_final': TextEditingController(),
    'dok_dikirim_tgl': TextEditingController(),
    'tanda_terima': TextEditingController(),
  };

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
      return BackdropFilter(
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
                                    color: accentColor.withValues(alpha: 0.4),
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
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Form Content
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              children: [
                                // Basic Info Section
                                _buildSectionTitle('Informasi Dasar'),
                                _buildModernTextField(
                                  controller: controllers['surat_dari']!,
                                  label: 'Surat Dari',
                                  icon: Icons.mail_outline_rounded,
                                  required: true,
                                ),
                                _buildModernTextField(
                                  controller: controllers['pengirim']!,
                                  label: 'Pengirim',
                                  icon: Icons.person_outline_rounded,
                                  required: true,
                                ),
                                _buildModernTextField(
                                  controller: controllers['perihal']!,
                                  label: 'Perihal',
                                  icon: Icons.subject_rounded,
                                  required: true,
                                  maxLines: 2,
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Date & Time Section
                                _buildSectionTitle('Tanggal & Waktu'),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['diterima_tgl']!,
                                        label: 'Tanggal Diterima',
                                        icon: Icons.calendar_today_rounded,
                                        required: true,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['tgl_surat']!,
                                        label: 'Tanggal Surat',
                                        icon: Icons.date_range_rounded,
                                        required: true,
                                      ),
                                    ),
                                  ],
                                ),
                                _buildModernTextField(
                                  controller: controllers['hari_tanggal']!,
                                  label: 'Hari, Tanggal',
                                  icon: Icons.event_note_rounded,
                                ),
                                _buildModernTextField(
                                  controller: controllers['waktu']!,
                                  label: 'Waktu',
                                  icon: Icons.access_time_rounded,
                                ),
                                _buildModernTextField(
                                  controller: controllers['tempat']!,
                                  label: 'Tempat',
                                  icon: Icons.location_on_outlined,
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Document Info Section
                                _buildSectionTitle('Informasi Dokumen'),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['kode']!,
                                        label: 'Kode',
                                        icon: Icons.code_rounded,
                                        required: true,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['no_urut']!,
                                        label: 'No. Urut',
                                        icon: Icons.format_list_numbered_rounded,
                                        required: true,
                                      ),
                                    ),
                                  ],
                                ),
                                _buildModernTextField(
                                  controller: controllers['no_surat']!,
                                  label: 'No. Surat',
                                  icon: Icons.confirmation_number_rounded,
                                  required: true,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['index']!,
                                        label: 'Index',
                                        icon: Icons.bookmark_outline_rounded,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['sifat']!,
                                        label: 'Sifat',
                                        icon: Icons.security_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Process Info Section
                                _buildSectionTitle('Informasi Proses'),
                                _buildModernTextField(
                                  controller: controllers['disposisi']!,
                                  label: 'Disposisi',
                                  icon: Icons.assignment_turned_in_rounded,
                                ),
                                _buildModernTextField(
                                  controller: controllers['pengolah']!,
                                  label: 'Pengolah',
                                  icon: Icons.admin_panel_settings_rounded,
                                ),
                                _buildModernTextField(
                                  controller: controllers['status']!,
                                  label: 'Status',
                                  icon: Icons.info_outline_rounded,
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Disposisi Dates Section
                                _buildSectionTitle('Tanggal Disposisi'),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['disposisi_kadin']!,
                                        label: 'Disposisi Kadin',
                                        icon: Icons.person_rounded,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['disposisi_sekdin']!,
                                        label: 'Disposisi Sekdin',
                                        icon: Icons.person_2_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['disposisi_kabid']!,
                                        label: 'Disposisi Kabid',
                                        icon: Icons.person_3_rounded,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['disposisi_kasubag']!,
                                        label: 'Disposisi Kasubag',
                                        icon: Icons.person_4_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Additional Info Section
                                _buildSectionTitle('Informasi Tambahan'),
                                _buildModernTextField(
                                  controller: controllers['disposisi_lanjutan']!,
                                  label: 'Disposisi Lanjutan',
                                  icon: Icons.next_plan_rounded,
                                  maxLines: 2,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['tindak_lanjut_1']!,
                                        label: 'Tindak Lanjut 1',
                                        icon: Icons.playlist_add_check_rounded,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['tindak_lanjut_2']!,
                                        label: 'Tindak Lanjut 2',
                                        icon: Icons.playlist_add_check_circle_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Document Links Section
                                _buildSectionTitle('Dokumen & Link'),
                                _buildModernTextField(
                                  controller: controllers['link_scan']!,
                                  label: 'Link Scan',
                                  icon: Icons.link_rounded,
                                ),
                                _buildModernTextField(
                                  controller: controllers['dok_final']!,
                                  label: 'Dokumen Final',
                                  icon: Icons.folder_open_rounded,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['dok_dikirim_tgl']!,
                                        label: 'Tanggal Dokumen Dikirim',
                                        icon: Icons.send_rounded,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: _buildModernTextField(
                                        controller: controllers['tanda_terima']!,
                                        label: 'Tanda Terima',
                                        icon: Icons.receipt_long_rounded,
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
                      
                      // Bottom Buttons
                      Container(
                        padding: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            // Save Button
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Create new surat data
                                    Map<String, dynamic> newSurat = {
                                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                                    };
                                    
                                    // Add all controller values to the map
                                    controllers.forEach((key, controller) {
                                      newSurat[key] = controller.text;
                                    });
                                    
                                    // Call the callback function
                                    onSuratAdded(newSurat);
                                    
                                    Navigator.pop(context);
                                    
                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Surat berhasil ditambahkan!'),
                                        backgroundColor: accentColor,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
      ));
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
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
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
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: required ? (value) {
        if (value == null || value.isEmpty) {
          return '$label wajib diisi';
        }
        return null;
      } : null,
    ),
  );
}