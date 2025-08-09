import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/surat.dart';

class SuratMasuk {
  Future<SuratMasukModel?> listSurat() async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/masuk');
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('jwt_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return SuratMasukModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<SuratMasukModel?> getSurat(int number) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/masuk/$number');
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('jwt_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return SuratMasukModel.fromJson(data);
    } else {
      return null;
    }
  }
}

class SuratKeluar {
  Future<SuratKeluarModel?> listSurat() async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/keluar');
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('jwt_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return SuratKeluarModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<SuratKeluarModel?> getSurat(int number) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/keluar/$number');
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('jwt_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return SuratKeluarModel.fromJson(data);
    } else {
      return null;
    }
  }
}