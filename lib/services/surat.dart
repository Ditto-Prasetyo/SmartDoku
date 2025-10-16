import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/services/auth.dart';
import 'package:smart_doku/services/settings.dart';
import 'package:smart_doku/utils/map.dart';
import 'package:path/path.dart' as p;

class SuratMasuk {
  final AuthService _authService = AuthService();

  Future<List<SuratMasukModel?>> listSurat() async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/masuk');
    final token = await _authService.getToken();

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

  Future<List<SuratMasukModel?>> getFilteredListSurat(String disposisi, bool? isSuperAdmin) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/masuk');
    final token = await _authService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      
      final List<SuratMasukModel> allData = data
        .map((e) => SuratMasukModel.fromJson(e as Map<String, dynamic>))
        .toList();

      // Filter sesuai disposisi
      final List<SuratMasukModel> filtered = allData.where((surat) => surat.disposisi.contains(disposisi)).toList();
      if (isSuperAdmin == false)
        return filtered;
      else 
        return allData;
    } else {
      throw Exception('Gagal mengambil data surat masuk');
    }
  }

  Future<SuratMasukModel?> getSurat(int number) async {
  final url = Uri.parse('${dotenv.env['API_URL']}/surat/masuk/$number');
  final token = await _authService.getToken();

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = response.body.trim();
      if (body.isEmpty) return null;

      final data = jsonDecode(body);

      // Cek apakah data valid (misal Map dan punya key tertentu)
      if (data == null || data is! Map<String, dynamic>) return null;

      return SuratMasukModel.fromJson(data);
    } else if (response.statusCode == 404) {
      // Data tidak ditemukan
      print('Surat dengan nomor $number tidak ditemukan');
      return null;
    } else if (response.statusCode == 401) {
      // Token invalid/expired
      print('Token kadaluarsa atau tidak valid');
      return null;
    } else {
      // Error umum
      print('Error ${response.statusCode}: ${response.body}');
      return null;
    }
  } catch (e) {
    // Handler kalau server down, timeout, atau error parsing JSON
    print('Terjadi kesalahan: $e');
    return null;
  }
}


  Future<SuratMasukModel?> addSurat({
    String? suratDari,
    DateTime? tanggalDiterima,
    DateTime? tanggalSurat,
    String? kode,
    String? noSurat,
    String? hal,
    DateTime? tanggalWaktu,
    String? tempat,
    dynamic disposisi,
    String? index,
    String? pengolah,
    String? sifat,
    String? linkScan,
    DateTime? disp1Kadin,
    DateTime? disp2Sekdin,
    DateTime? disp3Kabid,
    DateTime? disp4Kasubag,
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
      final token = await _authService.getToken();

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/masuk");

      final _settings = await AppSettings();
      final _suffix = "${_settings.part1}/${_settings.part3}";

      final body = {
        'nama_surat': suratDari,
        'tanggal_diterima': tanggalDiterima?.toIso8601String(),
        'tanggal_surat': tanggalSurat?.toIso8601String(),
        'kode': kode,
        'no_surat': noSurat,
        'hal': hal,
        'tanggal_waktu': tanggalWaktu?.toIso8601String(),
        'tempat': tempat,
        'disposisi': disposisi,
        'index': index,
        'pengolah': pengolah,
        'sifat': sifat,
        'link_scan': linkScan,
        'disp_1': disp1Kadin?.toIso8601String(),
        'disp_2': disp2Sekdin?.toIso8601String(),
        'disp_3': disp3Kabid?.toIso8601String(),
        'disp_4': disp4Kasubag?.toIso8601String(),
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
        'suffix_code': _suffix
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
    DateTime? disp1Kadin,
    DateTime? disp2Sekdin,
    DateTime? disp3Kabid,
    DateTime? disp4Kasubag,
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

      final token = await _authService.getToken();

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
        'disp_1': disp1Kadin?.toIso8601String(),
        'disp_2': disp2Sekdin?.toIso8601String(),
        'disp_3': disp3Kabid?.toIso8601String(),
        'disp_4': disp4Kasubag?.toIso8601String(),
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
        print('Gagal edit surat: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error editSurat: $e');
      return null;
    }
  }

  Future<SuratMasukModel?> deleteSurat(int nomor_urut) async {
    try {

      final token = await _authService.getToken();

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

  // Files services
  Future<bool> uploadFile(int nomor_urut, File file) async {
    final token = await _authService.getToken();

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
    final token = await _authService.getToken();

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

  Future<File?> downloadDisposisi(int fileId, String savePath) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('${dotenv.env['API_URL']}/download/disposisi/$fileId');
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

  Future<String> getDefaultDownloadPath() async {
    Directory? dir;

    if (Platform.isAndroid) {
      // Di Android 10 ke atas, kamu bisa pakai ini (tapi perlu permission)
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        dir = await getExternalStorageDirectory();
      }
    } else if (Platform.isWindows) {
      final downloadsDir = Directory(
        p.join(
          Platform.environment['USERPROFILE'] ?? '',
          'Downloads',
        ),
      );
      dir = downloadsDir;
    } else if (Platform.isLinux) {
      final downloadsDir = Directory(
        p.join(
          Platform.environment['HOME'] ?? '',
          'Downloads',
        ),
      );
      dir = downloadsDir;
    } else if (Platform.isMacOS) {
      final downloadsDir = Directory(
        p.join(
          Platform.environment['HOME'] ?? '',
          'Downloads',
        ),
      );
      dir = downloadsDir;
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    // Pastikan folder ada
    if (!await dir!.exists()) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }
}

class SuratKeluar {
  final AuthService _authService = AuthService();

  Future<List<SuratKeluarModel?>> listSurat() async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/keluar');
    final token = await _authService.getToken();

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

  Future<List<SuratKeluarModel?>> getFilteredListSurat(String disposisi, bool? isSuperAdmin) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/keluar');
    final token = await _authService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      
      final List<SuratKeluarModel> allData = data
        .map((e) => SuratKeluarModel.fromJson(e as Map<String, dynamic>))
        .toList();

      // Filter sesuai disposisi
      final List<SuratKeluarModel> filtered = allData.where((surat) => surat.pengolah == disposisi).toList();
      if (isSuperAdmin == false)
        return filtered;
      else 
        return allData;
    } else {
      throw Exception('Gagal mengambil data surat keluar');
    }
  }

  Future<SuratKeluarModel?> getSurat(int number) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/surat/keluar/$number');
    final token = await _authService.getToken();

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

  List<Map<String, String>> getDisposisiForAPI(List<String> selectedKeys) {
    return selectedKeys.map((key) {
      return { "tujuan": workFields[key]! };
    }).toList();
  }

  Future<SuratKeluarModel?> addSurat({
    String? kode,
    String? klasifikasi,
    String? tujuan_surat,
    String? perihal,
    DateTime? tanggal_surat,
    String? akses_arsip,
    String? pengolah,
    String? pembuat,
    String? catatan,
    String? link_surat,
    String? koreksi_1,
    String? koreksi_2,
    String? status,
    String? dok_final,
    DateTime? dok_dikirim,
    DateTime? tanda_terima
  }) async {
    try {

      final token = await _authService.getToken();

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/keluar");

      final _settings = await AppSettings();
      final _suffix = "${_settings.part1}/${_settings.part3}";

      final body = {
        'kode': kode,
        'klasifikasi': klasifikasi,
        'tujuan_surat': tujuan_surat,
        'perihal': perihal,
        'tanggal_surat': tanggal_surat?.toIso8601String(),
        'akses_arsip': akses_arsip,
        'pengolah': pengolah,
        'pembuat': pembuat,
        'catatan': catatan,
        'link_surat': link_surat,
        'koreksi_1': koreksi_1,
        'koreksi_2': koreksi_2,
        'status': status,
        'dok_final': dok_final,
        'dok_dikirim': dok_dikirim?.toIso8601String(),
        'tanda_terima': tanda_terima?.toIso8601String(),
        'suffix_code': _suffix
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

  Future<SuratKeluarModel?> editSurat({
    int? nomor_urut,
    String? kode,
    String? klasifikasi,
    String? no_register,
    String? tujuan_surat,
    String? perihal,
    DateTime? tanggal_surat,
    String? akses_arsip,
    String? pengolah,
    String? pembuat,
    String? catatan,
    String? link_surat,
    String? koreksi_1,
    String? koreksi_2,
    String? status,
    String? dok_final,
    DateTime? dok_dikirim,
    DateTime? tanda_terima
  }) async {
    try {

      final token = await _authService.getToken();

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/keluar/$nomor_urut");

      final body = {
        'kode': kode,
        'klasifikasi': klasifikasi,
        'no_register': no_register,
        'tujuan_surat': tujuan_surat,
        'perihal': perihal,
        'tanggal_surat': tanggal_surat?.toUtc().toIso8601String(),
        'akses_arsip': akses_arsip,
        'pengolah': pengolah,
        'pembuat': pembuat,
        'catatan': catatan,
        'link_surat': link_surat,
        'koreksi_1': koreksi_1,
        'koreksi_2': koreksi_2,
        'status': status,
        'dok_final': dok_final,
        'dok_dikirim': dok_dikirim?.toUtc().toIso8601String(),
        'tanda_terima': tanda_terima?.toUtc().toIso8601String()
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

  Future<SuratKeluarModel?> deleteSurat(int? nomor_urut) async {
    try {

      final token = await _authService.getToken();

      if (token == null) throw Exception('Token tidak ditemukan');

      final url = Uri.parse("${dotenv.env['API_URL']}/surat/keluar/$nomor_urut");

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
      print('Error deleteSurat: $e');
      return null;
    }
  }

  // Files services
  Future<bool> uploadFile(int nomor_urut, File file) async {
    final token = await _authService.getToken();

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
    final token = await _authService.getToken();

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
