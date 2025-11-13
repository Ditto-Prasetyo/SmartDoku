import 'package:smart_doku/models/user.dart';

class UserManagementSearch {
  static List<UserModel?> filterAndSort(List<UserModel?> source, String query) {
    final q = query.toLowerCase().trim();

    // 1) Filter
    final List<UserModel?> filtered = q.isEmpty
        ? List<UserModel?>.from(source)
        : source.where((e) {
            final s = e!;
            final name = (s.name ?? '').toLowerCase();
            final email = (s.email ?? '').toLowerCase();
            final username = (s.username ?? '').toLowerCase();
            final role = (s.role ?? '').toLowerCase();

            return name.contains(q) ||
                email.contains(q) ||
                username.contains(q) ||
                role.contains(q);
          }).toList();

    // 2) Sort by relevansi
    filtered.sort((a, b) {
      final aa = a!, bb = b!;
      final sa = _scoreUser(aa, q);
      final sb = _scoreUser(bb, q);
      if (sb != sa) return sb.compareTo(sa); // skor tertinggi dulu

      // tie-breaker jika skor sama: alfabetis nama → email
      final byName = (a!.name ?? '').toLowerCase().compareTo(
        (b!.name ?? '').toLowerCase(),
      );
      if (byName != 0) return byName;
      return (a.email ?? '').toLowerCase().compareTo(
        (b.email ?? '').toLowerCase(),
      );
    });

    return filtered;
  }

  // ===== Helpers (private) =====

  static int _scoreUser(UserModel s, String q) {
    if (q.isEmpty) return 0;
    final ql = q.toLowerCase().trim();
    int score = 0;

    // Pakai bobot yang sama seperti di page lo
    score += 9 * _scoreField(s.name, ql);
    score += 9 * _scoreField(s.email, ql);
    score += 7 * _scoreField(s.username, ql);
    score += 5 * _scoreField(s.role, ql);

    return score;
  }

  static int _scoreField(String? field, String q) {
    if (field == null || q.isEmpty) return 0;
    final f = field.toLowerCase();
    if (f == q) return 1000; // exact
    if (f.startsWith(q)) return 600; // prefix
    if (f.contains(q)) {
      final hits = RegExp(RegExp.escape(q)).allMatches(f).length;
      return 100 + hits * 30; // substring + bonus kemunculan
    }
    return 0;
  }
}
