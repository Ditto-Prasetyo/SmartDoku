import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:smart_doku/services/auth.dart';
import 'package:smart_doku/utils/map.dart';
import 'package:collection/collection.dart';

class UserService {
  AuthService _authService = AuthService();

  Future<bool> _checkTokenValidity(BuildContext context) async {
    final isValid = await _authService.isTokenValid();
    
    if (!isValid) {
      print('[ERROR] Token invalid or expired');
      _showTokenExpiredDialog(context);
      return false;
    }
    
    return true;
  }

  void _showTokenExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF1F2937),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Text(
              'Sesi Berakhir',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        content: Text(
          'Sesi login Anda telah berakhir atau tidak valid. Silakan login kembali untuk melanjutkan.',
          style: TextStyle(
            color: Colors.white70,
            decoration: TextDecoration.none,
            fontSize: 14,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _authService.logout();
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text('Login Kembali'),
          ),
        ],
      ),
    );
  }

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
        'Authorization': 'Bearer ${token}',
      },
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
        'Authorization': 'Bearer ${token}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<UserModel> allData = data
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Filter sesuai bidang
      final List<UserModel> filtered = allData
          .where((user) => user.bidang == bidang)
          .toList();

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

  Future<UserModel?> addUser({
    String? name,
    String? username,
    String? email,
    String? password,
    String? bidang,
    String? role,
    String? address,
    String? phone,
  }) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/users');
    final token = await _authService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
        'name': name,
        'bidang': bidang,
        'role': role,
        'address': address,
        'phone_number': phone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data != null) {
        return UserModel.fromJson(data);
      }

      return null;
    } else {
      print('Register failed: ${response.body}');
      return null;
    }
  }

  Future<bool> editUser({
    required BuildContext context,
    String? id,
    String? name,
    String? username,
    String? email,
    String? bidang,
    String? address,
    String? phone,
    String? role,
  }) async {
    // Check token validity first
    final isTokenValid = await _checkTokenValidity(context);
    if (!isTokenValid) {
      throw Exception('Token invalid or expired');
    }
    
    final url = Uri.parse('${dotenv.env['API_URL']}/users/$id');
    final token = await _authService.getToken();
    
    print('[DEBUG] ===== EDIT USER REQUEST =====');
    print('[DEBUG] URL: $url');
    print('[DEBUG] User ID: $id');
    print('[DEBUG] Token (first 30 chars): ${token?.substring(0, 30)}...');
    print('[DEBUG] Request Body:');
    print('  - name: $name');
    print('  - username: $username');
    print('  - email: $email');
    print('  - bidang: $bidang');
    print('  - role: $role');
    print('  - address: $address');
    print('  - phone: $phone');
    print('[DEBUG] ================================');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'email': email,
        'username': username, 
        'name': name,
        'bidang': bidang,
        'address': address,
        'phone_number': phone,
        'role': role,
      }),
    );

    print('[DEBUG] ===== EDIT USER RESPONSE =====');
    print('[DEBUG] Status Code: ${response.statusCode}');
    print('[DEBUG] Response Body: ${response.body}');
    print('[DEBUG] =================================');

    if (response.statusCode == 200) {
      print('[SUCCESS] User updated successfully');
      return true;
    } else if (response.statusCode == 401) {
      print('[ERROR] Unauthorized - Token invalid');
      _showTokenExpiredDialog(context);
      throw Exception('Authentication failed');
    } else {
      print('[ERROR] Update failed with status: ${response.statusCode}');
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<bool> deleteUser(String id) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/users/$id');
    final token = await _authService.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    print('[DEBUG] :: [STATE] : ID = $id');

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Delete failed: ${response.body}');
      return false;
    }
  }
}
