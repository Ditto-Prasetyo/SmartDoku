import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:smart_doku/utils/map.dart';
import 'package:collection/collection.dart';

class UserService {
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

  Future<Map<String, List<dynamic>>> getFilteredUsers(String bidang) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('jwt_token');
    
    if (token == null) throw Exception('Token tidak ditemukan');

    final uri = Uri.parse("${dotenv.env['API_URL']}/user");

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}'
      }
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      
      final List<dynamic> allData = data.map((e) => UserModel.fromJson(e)).toList();

      final Map<String, List<dynamic>> groupedData = groupBy(
        allData,
        (user) => user.bidang,
      );

      return groupedData;
    } else {
      throw Exception('Gagal mengambil data users');
    }
  }
}