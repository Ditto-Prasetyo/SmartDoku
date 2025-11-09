import 'package:flutter/material.dart';

Widget buildEmptyStateWidget() {
  TextEditingController searchController = TextEditingController();
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Center(
      child: Text(
        searchController.text.trim().isEmpty
            ? 'Belum ada data surat.'
            : 'Tidak ada hasil untuk “${searchController.text.trim()}”.',
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

