class QuoteItem {
  final String text;
  final String? source;    // optional
  final bool isCustom;     // biar bisa dihapus kalau buatan user
  QuoteItem({required this.text, this.source, this.isCustom = false});

  Map<String, dynamic> toMap() => {'text': text, 'source': source, 'isCustom': isCustom};
  factory QuoteItem.fromMap(Map<String,dynamic> m) =>
      QuoteItem(text: (m['text'] ?? '').toString(),
                source: (m['source'] ?? '') == '' ? null : m['source'].toString(),
                isCustom: (m['isCustom'] ?? false) as bool);
}