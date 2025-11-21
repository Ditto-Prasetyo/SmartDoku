import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_doku/services/auth.dart';

class LogService {
  final AuthService _authService = AuthService();

  Future<List<dynamic>> getLogs({int limit = 100}) async {
    final token = await _authService.getToken();
    final uri = Uri.parse('${dotenv.env['API_URL']}/logs?limit=$limit');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        return jsonData['data'];
      } else {
        throw Exception('Gagal memuat log: ${jsonData['message']}');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token tidak valid atau expired');
    } else {
      throw Exception('Gagal memuat log: ${response.reasonPhrase}');
    }
  }
}
