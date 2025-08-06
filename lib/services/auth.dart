import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/services/auth.dart';
import 'package:smart_doku/models/user.dart';

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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
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

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Register failed: ${response.body}');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
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
}
