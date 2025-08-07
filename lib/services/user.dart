import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/user.dart';

class UserService {
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = await prefs.getString('user');

    if (userJson != null) {
      final data = jsonDecode(userJson);
      return UserModel.fromJson(data);
    }

    return null;
  }
}