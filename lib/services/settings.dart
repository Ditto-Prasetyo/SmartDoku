import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Setter
  Future<void> setPart1(String value) async {
    await _prefs.setString('part1', value);
  }

  Future<void> setPart3(String value) async {
    await _prefs.setString('part3', value);
  }

  // Getter
  String get part1 => _prefs.getString('part1') ?? '35.07.303';
  String get part3 => _prefs.getString('part3') ?? '2025';

  // Reset to default
  Future<void> reset() async {
    await _prefs.setString('part1', '35.07.303');
    await _prefs.setString('part3', '2025');
  }
}
