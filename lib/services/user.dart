import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:smart_doku/services/auth.dart';
import 'package:smart_doku/utils/map.dart';
import 'package:collection/collection.dart';

class UserService {
  AuthService _authService = AuthService();

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = await prefs.getString('user');
    print(userJson);

    if (userJson != null) {
      final data = jsonDecode(userJson);
      return UserModel.fromJson(data);
    }

    return null;
  }

  Future<List<UserModel>> listUsers() async {
    print("[DEBUG] -> [FUNC] : listUsers() used!");
    final token = await _authService.getToken();
    
    if (token == null) throw Exception('Token tidak ditemukan');

    final uri = Uri.parse("${dotenv.env['API_URL']}/users");

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}'
      }
    );

    print("[DEBUG] :: Showing response body");
    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      
      final List<UserModel> allData = data
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();

      return allData;
    } else {
      throw Exception('Gagal mengambil data users');
    }
  }

  Future<List<UserModel>> getFilteredUsers(String bidang) async {
    print("[DEBUG] -> [FUNC] : getFilteredUsers() used!");
    final token = await _authService.getToken();
    
    if (token == null) throw Exception('Token tidak ditemukan');

    final uri = Uri.parse("${dotenv.env['API_URL']}/users");

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}'
      }
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      
      final List<UserModel> allData = data
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();

      // Filter sesuai bidang
      final List<UserModel> filtered = allData.where((user) => user.bidang == bidang).toList();

      return filtered;
    } else {
      throw Exception('Gagal mengambil data users');
    }
  }

  Future<bool> getSuperAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = await prefs.getString('user');

    if (userData != null) {
      final user = jsonDecode(userData);
      final role = user['role'];

      return role == 'SUPERADMIN' ? true : false;
    } else { 
      return false;
    }
  }

  Future<String?> getDisposisi() async {
    final prefs = await SharedPreferences.getInstance();
    final disposisi = await prefs.getString('disposisi');
    return disposisi;
  }
}