import 'package:flutter/material.dart';
import 'package:smart_doku/pages/forms/users/detail_page.dart';
import 'dart:ui';
import 'package:smart_doku/utils/dialog.dart';

void logout(BuildContext context) {
  Navigator.of(context).pop();
  showModernLogoutDialog(
    '⚠️ Logout',
    'Apakah Anda Yakin Ingin Keluar?',
    Colors.orange,
    Colors.deepOrange,
    context,
  );
}

void home(BuildContext context) {
  Navigator.of(context).pop();
  showModernHomeDialog(
    '⚠️ Go Home',
    'Apakah Anda Yakin Ingin Kembali ke Halaman Dashboard?',
    Colors.orange,
    Colors.deepOrange,
    context,
  );
}

void action(
  int index,
  BuildContext context,
  List<Map<String, dynamic>> suratData,
  void Function(int) editDokumen,
  void Function(int) viewDetail,
  void Function(int) hapusDokumen,
) {
  final surat = suratData[index];

  String perihal = surat['perihal'] ?? '';
  String perihalPendek = perihal.length > 30
      ? '${perihal.substring(0, 30)}...'
      : perihal;

  showModernActionDialog(
    index,
    '${surat['judul']}',
    'Surat ini berisi $perihalPendek\n\nSurat ini dikirimkan pada tanggal ${surat['tanggal']}',
    Color(0xFF10B981).withValues(alpha: 0.3),
    Colors.orange,
    Colors.deepOrange,
    context,
    suratData,
    editDokumen,
    viewDetail,
    hapusDokumen,
  );
}

void viewDetail(
  BuildContext context,
  int index,
  List<Map<String, dynamic>> suratData,
  ) {
  final surat = suratData[index];
  print('View Detail - ID: ${surat['id']}, Judul: ${surat['judul']}');

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailPage(suratData: surat),
    ),
  );
}

void editDokumen(
  int index,
  List<Map<String, dynamic>> suratData,
  ) {
  final surat = suratData[index];
  print('Edit Document - ID: ${surat['id']}, Judul: ${surat['judul']}');
}

void hapusDokumen(
  BuildContext context,
  int index,
  List<Map<String, dynamic>> suratData,
  void Function(int) onConfirmDelete, // ⬅️ Tambahin ini
) {
  final surat = suratData[index];
  showModernHapusDialog(
    '⚠️ Konfirmasi Hapus',
    'Apakah Anda yakin ingin menghapus surat "${surat['judul']}"?',
    Colors.orange,
    Colors.deepOrange,
    context,
    index,
    suratData,
    onConfirmDelete, // ⬅️ Callback buat jalanin setState nanti
  );
}

// Function untuk pick image (tambahin package image_picker di pubspec.yaml)
void pickImage(BuildContext context) async {
  // final ImagePicker picker = ImagePicker();
  // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  // if (image != null) {
  //   // Handle uploaded image
  //   print('Image selected: ${image.path}');
  // }

  // Sementara pake snackbar dulu
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Fitur upload gambar akan segera tersedia')),
  );
}

// Function untuk pick document (tambahin package file_picker di pubspec.yaml)
void pickDocument(BuildContext context) async {
  // final FilePickerResult? result = await FilePicker.platform.pickFiles(
  //   type: FileType.custom,
  //   allowedExtensions: ['pdf', 'doc', 'docx'],
  // );
  // if (result != null) {
  //   // Handle uploaded document
  //   print('Document selected: ${result.files.single.path}');
  // }

  // Sementara pake snackbar dulu
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Fitur upload dokumen akan segera tersedia')),
  );
}
