import 'package:shared_preferences/shared_preferences.dart';

class Bookmarks {
  Future<List<String>?> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('bookmarks');

    return data == null || data == [] ? null : data;
  }
}