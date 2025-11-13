import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> factoryResetAllPrefs(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  // Hapus SEMUA key milik app ini
  final ok = await prefs.clear();

  // (Opsional) force reload cache kalau versi plugin lo support
  try { await prefs.reload(); } catch (_) {}

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Data lokal di-reset' : 'Reset gagal')),
    );

    // Bersihin stack & balik ke login (ganti route sesuai app lo)
    Navigator.of(context).pushNamedAndRemoveUntil('/pages/auth/login', (route) => false);
  }
}

Future<void> confirmFactoryReset(BuildContext context) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Reset data lokal?'),
      content: Text(
        'Ini akan menghapus token login, user cache, bookmarks, saved filters, dll. '
        'Kamu akan diminta login ulang.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal')),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Reset')),
      ],
    ),
  );
  if (yes == true) {
    await factoryResetAllPrefs(context);
  }
}
