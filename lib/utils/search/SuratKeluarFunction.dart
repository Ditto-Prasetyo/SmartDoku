import 'package:smart_doku/models/surat.dart';

class SuratKeluarSearch {
  static List<SuratKeluarModel?> filterAndSort(
    List<SuratKeluarModel?> source,
    String query,
  ) {
    final q = query.toLowerCase().trim();

    // 1) Filter
    final List<SuratKeluarModel?> filtered = q.isEmpty
        ? List<SuratKeluarModel?>.from(source)
        : source.where((e) {
            final s = e!;
            final kode        = (s.kode ?? '').toLowerCase();
            final klasifikasi = (s.klasifikasi ?? '').toLowerCase();
            final noRegister  = (s.no_register ?? '').toString().toLowerCase();
            final tujuan      = (s.tujuan_surat ?? '').toLowerCase();
            final perihal     = (s.perihal ?? '').toLowerCase();
            final pengolah    = (s.pengolah ?? '').toLowerCase();
            final pembuat     = (s.pembuat ?? '').toLowerCase();
            final catatan     = (s.catatan ?? '').toLowerCase();
            final link        = (s.link_surat ?? '').toLowerCase();
            final k1          = (s.koreksi_1 ?? '').toLowerCase();
            final k2          = (s.koreksi_2 ?? '').toLowerCase();
            final status      = (s.status ?? '').toLowerCase();

            return kode.contains(q) ||
                   klasifikasi.contains(q) ||
                   noRegister.contains(q) ||
                   tujuan.contains(q) ||
                   perihal.contains(q) ||
                   pengolah.contains(q) ||
                   pembuat.contains(q) ||
                   catatan.contains(q) ||
                   link.contains(q) ||
                   k1.contains(q) ||
                   k2.contains(q) ||
                   status.contains(q);
          }).toList();

    // 2) Sort by relevansi
    filtered.sort((a, b) {
      final aa = a!, bb = b!;
      final sa = _scoreSurat(aa, q);
      final sb = _scoreSurat(bb, q);
      if (sb != sa) return sb.compareTo(sa); // skor tertinggi dulu

      // tie-breaker 1: tanggal surat terbaru
      final da = _parseDateSafe(aa.tanggal_surat);
      final db = _parseDateSafe(bb.tanggal_surat);
      final byDate = db.compareTo(da);
      if (byDate != 0) return byDate;

      // tie-breaker 2: no_register menaik
      final na = int.tryParse('${aa.no_register ?? ''}') ?? -1;
      final nb = int.tryParse('${bb.no_register ?? ''}') ?? -1;
      return na.compareTo(nb);
    });

    return filtered;
  }

  // ===== Helpers (private) =====

  static int _scoreSurat(SuratKeluarModel s, String q) {
    if (q.isEmpty) return 0;
    final ql = q.toLowerCase().trim();
    int score = 0;

    // Pakai bobot yang sama seperti di page lo
    score += 9 * _scoreField(s.klasifikasi, ql);
    score += 9 * _scoreField(s.no_register, ql);
    score += 9 * _scoreField(s.dok_final, ql);
    score += 9 * _scoreField(s.kode, ql);
    score += 8 * _scoreField(s.tujuan_surat, ql);
    score += 7 * _scoreField(s.perihal, ql);
    score += 6 * _scoreField(s.pengolah, ql);
    score += 5 * _scoreField(s.pembuat, ql);
    score += 4 * _scoreField(s.catatan, ql);
    score += 3 * _scoreField(s.link_surat, ql);
    score += 3 * _scoreField(s.koreksi_1, ql);
    score += 3 * _scoreField(s.koreksi_2, ql);
    score += 3 * _scoreField(s.status, ql);

    // Bonus kecil untuk tanggal (di-string-kan)
    final tgl     = _parseDateSafe(s.tanggal_surat);
    final dikirim = _parseDateSafe(s.dok_dikirim);
    final terima  = _parseDateSafe(s.tanda_terima);
    score += 2 * _scoreField(tgl.toIso8601String(), ql);
    score += 2 * _scoreField(dikirim.toIso8601String(), ql);
    score += 2 * _scoreField(terima.toIso8601String(), ql);

    return score;
  }

  static int _scoreField(String? field, String q) {
    if (field == null || q.isEmpty) return 0;
    final f = field.toLowerCase();
    if (f == q) return 1000;           // exact
    if (f.startsWith(q)) return 600;   // prefix
    if (f.contains(q)) {
      final hits = RegExp(RegExp.escape(q)).allMatches(f).length;
      return 100 + hits * 30;          // substring + bonus kemunculan
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
