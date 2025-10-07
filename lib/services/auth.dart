import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/user.dart';
import 'package:smart_doku/utils/map.dart';

class AuthService {
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = UserModel.fromJson(data["user"]);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user', jsonEncode(user.toJson()));
      await setDisposisi();
      
      return true;
    } else {
      print('Login failed: ${response.body}');
      return false;
    }
  }

  Future<bool> register(
    String name,
    String username,
    String email, 
    String password,
    String bidang,
    String address,
    String phone
    ) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email, 
        'password': password,
        'username': username,
        'name': name,
        'bidang': bidang,
        'address': address,
        'phone_number': phone
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Register failed: ${response.body}');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    print("[DEBUG] -> [STATE] Logging out ... ");
    await prefs.remove('jwt_token');
    await prefs.remove('user');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String?> setDisposisi() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = await prefs.getString('user');
    
    if (userData != null) {
      final user = jsonDecode(userData);
      final bidang = user['bidang'];

      final disposisi = workFields.entries.firstWhere(
        (e) => e.value == bidang,
        orElse: () => const MapEntry('Tidak Diketahui', 'Unknown')
      ).key;
      await prefs.setString('disposisi', disposisi);

      return disposisi;
    }

    return null;
  }
}
