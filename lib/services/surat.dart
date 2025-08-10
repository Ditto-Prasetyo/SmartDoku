import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_doku/models/surat.dart';

class SuratMasuk {
  Future<List<SuratMasukModel?>> listSurat() async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/masuk');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SuratMasukModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data surat masuk');
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
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return SuratMasukModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<SuratMasukModel?> addSurat({
    String? suratDari,
    DateTime? tanggalDiterima,
    DateTime? tanggalSurat,
    String? kode,
    String? noAgenda,
    String? noSurat,
    String? hal,
    DateTime? tanggalWaktu,
    String? tempat,
    dynamic disposisi,
    String? index,
    String? pengolah,
    String? sifat,
    String? linkScan,
    String? disp1Kadin,
    String? disp2Sekdin,
    String? disp3Kabid,
    String? disp4Kadin,
    String? disp1Notes,
    String? disp2Notes,
    String? disp3Notes,
    String? disp4Notes,
    String? dispLanjut,
    DateTime? tindakLanjut1,
    DateTime? tindakLanjut2,
    String? tl1Notes,
    String? tl2Notes,
    String? status,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/masuk");

      final body = {
        'nama_surat': suratDari,
        'tanggal_diterima': tanggalDiterima?.toIso8601String(),
        'tanggal_surat': tanggalSurat?.toIso8601String(),
        'kode': kode,
        'no_agenda': noAgenda,
        'no_surat': noSurat,
        'hal': hal,
        'tanggal_waktu': tanggalWaktu?.toIso8601String(),
        'tempat': tempat,
        'disposisi': disposisi,
        'index': index,
        'pengolah': pengolah,
        'sifat': sifat,
        'link_scan': linkScan,
        'disp_1': disp1Kadin,
        'disp_2': disp2Sekdin,
        'disp_3': disp3Kabid,
        'disp_4': disp4Kadin,
        'disp_1_notes': disp1Notes,
        'disp_2_notes': disp2Notes,
        'disp_3_notes': disp3Notes,
        'disp_4_notes': disp4Notes,
        'disp_lanjut': dispLanjut,
        'tindak_lanjut_1': tindakLanjut1?.toIso8601String(),
        'tindak_lanjut_2': tindakLanjut2?.toIso8601String(),
        'tl_notes_1': tl1Notes,
        'tl_notes_2': tl2Notes,
        'status': status,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SuratMasukModel.fromJson(data);
      } else {
        print('Gagal tambah surat: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error addSurat: $e');
      return null;
    }
  }

  Future<SuratMasukModel?> editSurat({
    int? nomor_urut,
    String? suratDari,
    DateTime? tanggalDiterima,
    DateTime? tanggalSurat,
    String? kode,
    String? noAgenda,
    String? noSurat,
    String? hal,
    DateTime? tanggalWaktu,
    String? tempat,
    dynamic disposisi,
    String? index,
    String? pengolah,
    String? sifat,
    String? linkScan,
    String? disp1Kadin,
    String? disp2Sekdin,
    String? disp3Kabid,
    String? disp4Kadin,
    String? disp1Notes,
    String? disp2Notes,
    String? disp3Notes,
    String? disp4Notes,
    String? dispLanjut,
    DateTime? tindakLanjut1,
    DateTime? tindakLanjut2,
    String? tl1Notes,
    String? tl2Notes,
    String? status,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/masuk/$nomor_urut");

      final body = {
        'nama_surat': suratDari,
        'tanggal_diterima': tanggalDiterima?.toIso8601String(),
        'tanggal_surat': tanggalSurat?.toIso8601String(),
        'kode': kode,
        'no_agenda': noAgenda,
        'no_surat': noSurat,
        'hal': hal,
        'tanggal_waktu': tanggalWaktu?.toIso8601String(),
        'tempat': tempat,
        'disposisi': disposisi,
        'index': index,
        'pengolah': pengolah,
        'sifat': sifat,
        'link_scan': linkScan,
        'disp_1': disp1Kadin,
        'disp_2': disp2Sekdin,
        'disp_3': disp3Kabid,
        'disp_4': disp4Kadin,
        'disp_1_notes': disp1Notes,
        'disp_2_notes': disp2Notes,
        'disp_3_notes': disp3Notes,
        'disp_4_notes': disp4Notes,
        'disp_lanjut': dispLanjut,
        'tindak_lanjut_1': tindakLanjut1?.toIso8601String(),
        'tindak_lanjut_2': tindakLanjut2?.toIso8601String(),
        'tl_notes_1': tl1Notes,
        'tl_notes_2': tl2Notes,
        'status': status,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SuratMasukModel.fromJson(data);
      } else {
        print('Gagal tambah surat: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error addSurat: $e');
      return null;
    }
  }

  Future<SuratMasukModel?> deleteSurat({
    int? nomor_urut
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/masuk/$nomor_urut");

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SuratMasukModel.fromJson(data);
      } else {
        print('Gagal tambah surat: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error addSurat: $e');
      return null;
    }
  }

  // Upload file
  Future<bool> uploadFile(int nomor_urut, File file) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${dotenv.env['API_URL']}/upload/surat/masuk/$nomor_urut'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return response.statusCode == 200;
  }

  Future<File?> downloadFile(int fileId, String savePath) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');

    final uri = Uri.parse('${dotenv.env['API_URL']}/download/surat/masuk/$fileId');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      print("Download berhasil: $savePath");
      return file;
    } else {
      print("Download gagal: ${response.body}");
      return null;
    }
  }
}

class SuratKeluar {
  Future<List<SuratKeluarModel?>> listSurat() async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/keluar');
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('jwt_token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((e) => SuratKeluarModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data surat keluar');
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
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return SuratKeluarModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<SuratKeluarModel?> addSurat({
    String? suratDari,
    DateTime? tanggalDiterima,
    DateTime? tanggalSurat,
    String? kode,
    String? noAgenda,
    String? noSurat,
    String? hal,
    DateTime? tanggalWaktu,
    String? tempat,
    dynamic disposisi,
    String? index,
    String? pengolah,
    String? sifat,
    String? linkScan,
    String? disp1Kadin,
    String? disp2Sekdin,
    String? disp3Kabid,
    String? disp4Kadin,
    String? disp1Notes,
    String? disp2Notes,
    String? disp3Notes,
    String? disp4Notes,
    String? dispLanjut,
    DateTime? tindakLanjut1,
    DateTime? tindakLanjut2,
    String? tl1Notes,
    String? tl2Notes,
    String? status,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/masuk");

      final body = {
        'nama_surat': suratDari,
        'tanggal_diterima': tanggalDiterima?.toIso8601String(),
        'tanggal_surat': tanggalSurat?.toIso8601String(),
        'kode': kode,
        'no_agenda': noAgenda,
        'no_surat': noSurat,
        'hal': hal,
        'tanggal_waktu': tanggalWaktu?.toIso8601String(),
        'tempat': tempat,
        'disposisi': disposisi,
        'index': index,
        'pengolah': pengolah,
        'sifat': sifat,
        'link_scan': linkScan,
        'disp_1': disp1Kadin,
        'disp_2': disp2Sekdin,
        'disp_3': disp3Kabid,
        'disp_4': disp4Kadin,
        'disp_1_notes': disp1Notes,
        'disp_2_notes': disp2Notes,
        'disp_3_notes': disp3Notes,
        'disp_4_notes': disp4Notes,
        'disp_lanjut': dispLanjut,
        'tindak_lanjut_1': tindakLanjut1?.toIso8601String(),
        'tindak_lanjut_2': tindakLanjut2?.toIso8601String(),
        'tl_notes_1': tl1Notes,
        'tl_notes_2': tl2Notes,
        'status': status,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SuratKeluarModel.fromJson(data);
      } else {
        print('Gagal tambah surat: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error addSurat: $e');
      return null;
    }
  }

  Future<SuratMasukModel?> editSurat({
    int? nomor_urut,
    String? suratDari,
    DateTime? tanggalDiterima,
    DateTime? tanggalSurat,
    String? kode,
    String? noAgenda,
    String? noSurat,
    String? hal,
    DateTime? tanggalWaktu,
    String? tempat,
    dynamic disposisi,
    String? index,
    String? pengolah,
    String? sifat,
    String? linkScan,
    String? disp1Kadin,
    String? disp2Sekdin,
    String? disp3Kabid,
    String? disp4Kadin,
    String? disp1Notes,
    String? disp2Notes,
    String? disp3Notes,
    String? disp4Notes,
    String? dispLanjut,
    DateTime? tindakLanjut1,
    DateTime? tindakLanjut2,
    String? tl1Notes,
    String? tl2Notes,
    String? status,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/masuk/$nomor_urut");

      final body = {
        'nama_surat': suratDari,
        'tanggal_diterima': tanggalDiterima?.toIso8601String(),
        'tanggal_surat': tanggalSurat?.toIso8601String(),
        'kode': kode,
        'no_agenda': noAgenda,
        'no_surat': noSurat,
        'hal': hal,
        'tanggal_waktu': tanggalWaktu?.toIso8601String(),
        'tempat': tempat,
        'disposisi': disposisi,
        'index': index,
        'pengolah': pengolah,
        'sifat': sifat,
        'link_scan': linkScan,
        'disp_1': disp1Kadin,
        'disp_2': disp2Sekdin,
        'disp_3': disp3Kabid,
        'disp_4': disp4Kadin,
        'disp_1_notes': disp1Notes,
        'disp_2_notes': disp2Notes,
        'disp_3_notes': disp3Notes,
        'disp_4_notes': disp4Notes,
        'disp_lanjut': dispLanjut,
        'tindak_lanjut_1': tindakLanjut1?.toIso8601String(),
        'tindak_lanjut_2': tindakLanjut2?.toIso8601String(),
        'tl_notes_1': tl1Notes,
        'tl_notes_2': tl2Notes,
        'status': status,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SuratMasukModel.fromJson(data);
      } else {
        print('Gagal tambah surat: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error addSurat: $e');
      return null;
    }
  }

  Future<SuratKeluarModel?> deleteSurat({
    int? nomor_urut
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/masuk/$nomor_urut");

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SuratKeluarModel.fromJson(data);
      } else {
        print('Gagal tambah surat: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error addSurat: $e');
      return null;
    }
  }

  // Upload file
  Future<bool> uploadFile(int nomor_urut, File file) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${dotenv.env['API_URL']}/upload/surat/keluar/$nomor_urut'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return response.statusCode == 200;
  }

  Future<File?> downloadFile(int fileId, String savePath) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');

    final uri = Uri.parse('${dotenv.env['API_URL']}/download/surat/keluar/$fileId');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      print("Download berhasil: $savePath");
      return file;
    } else {
      print("Download gagal: ${response.body}");
      return null;
    }
  }
}
