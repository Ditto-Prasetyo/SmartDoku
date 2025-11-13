import 'package:flutter/material.dart';

final Map<String, String> workFields = {
  'Penataan Ruang dan PB': 'PRPB',
  'Perumahan': 'Perumahan',
  'Permukiman': 'Permukiman',
  'Sekretariat': 'Sekretariat',
  'UPT Pengelolaan Air Limbah Domestik': 'UPT_PALD',
  'UPT Pertamanan': 'UPT_Taman',
};

final List<String> listWorkfields = [
  'Penataan Ruang dan PB',
  'Perumahan',
  'Permukiman',
  'Sekretariat',
  'UPT Pengelolaan Air Limbah Domestik',
  'UPT Pertamanan',
];

List<Map<String, dynamic>> boxData = [
  {
    'icon': Icons.admin_panel_settings,
    'title': 'Penataan Ruang dan PB',
    'colors': [
      Color(0xFF3B82F6),
      Color(0xFF2563EB),
    ],
    'route':
        'tables_page_admin.dart',
  },
  {
    'icon': Icons.location_city,
    'title': 'Perumahan',
    'colors': [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
    'route': 'tables_page_admin.dart',
  },
  {
    'icon': Icons.house_rounded,
    'title': 'Permukiman',
    'colors': [
      Color(0xFFF97316),
      Color(0xFFEF4444),
    ],
    'route':
        'tables_page_admin.dart',
  },
  {
    'icon': Icons.map_outlined,
    'title': 'Sekretariat',
    'colors': [
      Color(0xFF06B6D4),
      Color(0xFF0EA5E9),
    ],
    'route': 'tables_page_admin.dart',
  },
  {
    'icon': Icons.water_drop_outlined,
    'title': 'UPT Pengelolaan Air Limbah Domestik',
    'colors': [
      Color(0xFF22C55E),
      Color(0xFF16A34A),
    ],
    'route': 'tables_page_admin.dart',
  },
  {
    'icon': Icons.park_rounded,
    'title': 'UPT Pertamanan',
    'colors': [
      Color(0xFF7C2D12),
      Color(0xFF9A3412),
    ],
    'route': 'tables_page_admin.dart',
  },
];

final Map<String, String> roleField = {
  'User': 'USER',
  'Admin': 'ADMIN',
  'SuperAdmin': 'SUPERADMIN',
};

List<int> flexSuratKeluar = [
  25, // Kode
  55, // Klasifikasi
  55, // No. Register
  20, // Tujuan Surat
  90, // Perihal
  20, // Tanggal Surat
  90, // Akses Arsip
  40, // Pengolah
  38, // Pembuat
  22, // Catatan
  70, // Link Surat
  30, // Koreksi 1
  31, // Koreksi 2
  39, // Dokumen Dikirim
  35, // Dokumen Final
  35, // Tanda Terima
  30 // Status
];

List<int> flexSuratMasuk = [
  170, // Surat Dari/Nama Surat 0
  140, // Tanggal Diterima 1
  120, // Tanggal Surat 2
  80, // Kode 3
  110, // No. Urut 4
  120, // No. Agenda 5 
  60, // No Surat 6
  220, // Perihal 7
  150, // Hari, tanggal, waktu 8
  80, // Tempat 9
  110, // Disposisi 10
  100, // Index 11
  100, // Pengolah 12
  120, // Sifat 13
  100, // Link Scan 14
  125, // Disposisi kadin 15
  100, // Disposisi Sekdin 16
  125, // Diposisi Kabid 17
  130, // Disposisi Kasubag 18
  130, // Catatan Disposisi Kadin 19
  110, // Catatan Disposisi Sekdin 20
  120, // Catatan Disposisi Kabid 21
  130, // Catatan Disposisi Kasubag 22
  110, // Disposisi Lanjutan 23
  100, // Tindak Lanjut 1 24
  110, // Tindak Lanjut 2 25
  100, // Status 26
];