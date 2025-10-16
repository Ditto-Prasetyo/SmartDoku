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
      
      print('[INFO] Login successful, token saved');
      return true;
    } else {
      print('[ERROR] Login failed: ${response.body}');
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
      print('[ERROR] Register failed: ${response.body}');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    print("[DEBUG] -> [STATE] Logging out ... ");
    await prefs.remove('jwt_token');
    await prefs.remove('user');
    await prefs.remove('disposisi');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    if (token == null) {
      print('[WARNING] No token found in SharedPreferences');
    }
    
    return token;
  }

  // NEW: Check if token is valid (basic check)
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      print('[ERROR] Token is null or empty');
      return false;
    }
    
    // Try to decode JWT and check expiration
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('[ERROR] Invalid token format');
        return false;
      }
      
      // Decode payload
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );
      
      // Check expiration
      final exp = payload['exp'];
      if (exp == null) {
        print('[WARNING] Token has no expiration');
        return true; // Assume valid if no exp claim
      }
      
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final isValid = DateTime.now().isBefore(expiryDate);
      
      if (!isValid) {
        print('[ERROR] Token expired at: $expiryDate');
      } else {
        print('[INFO] Token valid until: $expiryDate');
      }
      
      return isValid;
    } catch (e) {
      print('[ERROR] Token validation failed: $e');
      return false;
    }
  }

  // NEW: Verify token with backend
  Future<bool> verifyTokenWithBackend() async {
    try {
      final token = await getToken();
      if (token == null) return false;
      
      final url = Uri.parse('${dotenv.env['API_URL']}/auth/verify');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        print('[INFO] Token verified with backend');
        return true;
      } else {
        print('[ERROR] Token verification failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('[ERROR] Backend verification error: $e');
      return false;
    }
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
  
  // NEW: Get current user data
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');
      
      if (userData != null) {
        return UserModel.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      print('[ERROR] Failed to get current user: $e');
      return null;
    }
  }
}
