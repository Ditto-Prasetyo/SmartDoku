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