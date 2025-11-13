import 'package:flutter/material.dart';

Widget buildEmptyStateWidget() {
  TextEditingController searchController = TextEditingController();
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Center(
      child: Text(
        searchController.text.trim().isEmpty 
            ? 'Tidak ada hasil untuk “${searchController.text.trim()}”.'
            : 'Belum ada data surat.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

