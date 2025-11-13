import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkItem {
  final String id;
  final String title;
  final String? route;
  final String? type; // 'surat_masuk' | 'surat_keluar' | null
  final DateTime? savedAt;

  BookmarkItem({
    required this.id,
    required this.title,
    this.route,
    this.type,
    this.savedAt,
  });

  BookmarkItem copyWith({
    String? id,
    String? title,
    String? route,
    String? type,
    DateTime? savedAt,
  }) {
    return BookmarkItem(
      id: id ?? this.id,
      title: title ?? this.title,
      route: route ?? this.route,
      type: type ?? this.type,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': title,
    'route': route,
    'type': type,
    'savedAt': savedAt?.toIso8601String(),
  };

  static BookmarkItem fromRaw(String raw) {
    // 1) JSON
    try {
      final m = jsonDecode(raw);
      if (m is Map<String, dynamic>) {
        return BookmarkItem(
          id: (m['id'] ?? m['key'] ?? m['index'] ?? raw).toString(),
          title: (m['judul'] ?? m['title'] ?? m['no_surat'] ?? 'Surat').toString(),
          route: m['route']?.toString(),
          type: m['type']?.toString(),
          savedAt: m['savedAt'] != null ? DateTime.tryParse(m['savedAt']) : null,
        );
      }
    } catch (_) {}

    // 2) Pipe-delimited: "id|title|route|type"
    if (raw.contains('|')) {
      final p = raw.split('|');
      return BookmarkItem(
        id: p[0],
        title: p.length > 1 ? p[1] : p[0],
        route: p.length > 2 ? p[2] : null,
        type:  p.length > 3 ? p[3] : null,
      );
    }

    // 3) String polos
    return BookmarkItem(id: raw, title: raw);
  }
}

class Bookmarks {
  static const key = 'bookmarks';

  /// Ambil raw list (bisa kosong).
  static Future<List<String>> _raw() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? <String>[];
  }

  /// Tulis ulang list dengan format JSON yang sudah dibersihkan.
  static Future<void> _saveAll(List<BookmarkItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  /// Baca + parse semua format + DEDUP by id (ambil yang savedAt paling baru).
  static Future<List<BookmarkItem>> list() async {
    final raw = await _raw();
    final map = <String, BookmarkItem>{};
    for (final s in raw) {
      final it = BookmarkItem.fromRaw(s);
      final prev = map[it.id];
      if (prev == null) {
        map[it.id] = it;
      } else {
        final a = it.savedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final b = prev.savedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        if (a.isAfter(b)) map[it.id] = it;
      }
    }
    return map.values.toList();
  }

  /// Sekaligus MIGRASI: panggil sekali di awal app/homepage.
  static Future<void> normalize() async {
    final items = await list();
    await _saveAll(items);
  }

  /// Toggle: kalau ada -> hapus; kalau belum -> tambahkan (di depan).
  static Future<void> toggle(BookmarkItem item) async {
    final items = await list();
    final i = items.indexWhere((e) => e.id == item.id);
    if (i >= 0) {
      items.removeAt(i);
    } else {
      items.insert(0, item.copyWith(savedAt: DateTime.now()));
    }
    await _saveAll(items);
  }

  /// Hapus by id (bersih—semua format udah dinormalisasi di list()).
  static Future<void> removeById(String id) async {
    final items = await list();
    items.removeWhere((e) => e.id == id);
    await _saveAll(items);
  }

  /// Backward-compat: kalau masih mau akses mentah (hindari pakai ini)
  static Future<List<String>> getBookmarks() async {
    // jangan pakai `== []`, cukup cek isEmpty
    final items = await list();
    return items.isEmpty
        ? <String>[]
        : items.map((e) => jsonEncode(e.toJson())).toList();
  }
}
