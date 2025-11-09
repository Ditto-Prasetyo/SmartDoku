import 'package:flutter/material.dart';
import 'dart:io';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/models/surat.dart';

class SuratMasukSearch {
  static List<SuratMasukModel?> filterAndSort(
    List<SuratMasukModel?> source,
    String query,
  ) {
    final q = query.toLowerCase().trim();

    // 1) Filter
    final List<SuratMasukModel?> filtered = q.isEmpty
        ? List<SuratMasukModel?>.from(source)
        : source.where((e) {
            final s = e!;
            final namaSurat = (s.nama_surat ?? '').toLowerCase();
            final hal       = (s.hal ?? '').toLowerCase();
            final noSurat   = (s.no_surat ?? '').toLowerCase();
            final kode      = (s.kode ?? '').toLowerCase();
            final pengolah  = (s.pengolah ?? '').toLowerCase();
            final tempat    = (s.tempat ?? '').toLowerCase();
            final status    = (s.status ?? '').toLowerCase();
            final noAgenda  = (s.no_agenda ?? '').toString().toLowerCase();
            final index     = (s.index ?? '').toLowerCase();
            final sifat     = (s.sifat ?? '').toLowerCase();
            final disposisi = (s.disposisi is List)
                ? (s.disposisi as List).map((e) => e.toString().toLowerCase()).join(' ')
                : '';

            return namaSurat.contains(q) ||
                   hal.contains(q) ||
                   noSurat.contains(q) ||
                   noAgenda.contains(q) ||
                   kode.contains(q) ||
                   pengolah.contains(q) ||
                   tempat.contains(q) ||
                   status.contains(q) ||
                   index.contains(q) ||
                   sifat.contains(q) ||
                   disposisi.contains(q);
          }).toList();

    // 2) Sort by relevansi
    filtered.sort((a, b) {
      final aa = a!, bb = b!;
      final sa = _scoreSurat(aa, q);
      final sb = _scoreSurat(bb, q);
      if (sb != sa) return sb.compareTo(sa); // skor tertinggi dulu

      // tie-breaker 1: tanggal terbaru dulu
      final da = _parseDateSafe(aa.tanggal_waktu);
      final db = _parseDateSafe(bb.tanggal_waktu);
      final byDate = db.compareTo(da);
      if (byDate != 0) return byDate;

      // tie-breaker 2: nomor_urut naik
      final na = int.tryParse('${aa.nomor_urut ?? ''}') ?? -1;
      final nb = int.tryParse('${bb.nomor_urut ?? ''}') ?? -1;
      return na.compareTo(nb);
    });

    return filtered;
  }

  // ===== Helpers (private) =====

  static int _scoreSurat(SuratMasukModel s, String q) {
    if (q.isEmpty) return 0;
    final ql = q.toLowerCase().trim();
    int score = 0;

    // Bobot prioritas kolom
    score += 9 * _scoreField(s.no_surat, ql);
    score += 8 * _scoreField(s.nama_surat, ql);
    score += 7 * _scoreField(s.hal, ql);
    score += 6 * _scoreField(s.no_agenda?.toString(), ql);
    score += 5 * _scoreField(s.kode, ql);
    score += 5 * _scoreField(s.pengolah, ql);
    score += 4 * _scoreField(s.tempat, ql);
    score += 4 * _scoreField(s.status, ql);
    score += 3 * _scoreField(s.index, ql);
    score += 3 * _scoreField(s.sifat, ql);

    if (s.disposisi is List) {
      final disp = (s.disposisi as List).map((e) => e.toString()).join(' ');
      score += 3 * _scoreField(disp, ql);
    }

    // Bonus kecil untuk kecocokan numerik di nomor_urut
    final numeric = int.tryParse(ql);
    if (numeric != null) {
      final noUrut = int.tryParse('${s.nomor_urut ?? ''}');
      if (noUrut != null && '$noUrut'.contains(ql)) score += 150;
    }

    return score;
  }

  static int _scoreField(String? field, String q) {
    if (field == null || q.isEmpty) return 0;
    final f = field.toLowerCase();
    if (f == q) return 1000;          // exact
    if (f.startsWith(q)) return 600;  // prefix
    if (f.contains(q)) {
      final hits = RegExp(RegExp.escape(q)).allMatches(f).length;
      return 100 + hits * 30;         // substring + bonus kemunculan
    }
    return 0;
  }

  static DateTime _parseDateSafe(dynamic v) {
    try {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}
