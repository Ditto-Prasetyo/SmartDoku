class SuratMasukModel {
  final String id;
  final int nomor_urut;
  final String nama_surat;
  final DateTime tanggal_diterima;
  final DateTime tanggal_surat;
  final String kode;
  final String no_agenda;
  final String no_surat;  
  final String hal;
  final DateTime tanggal_waktu;
  final String tempat;
  final List<dynamic> disposisi;
  final String? index;
  final String pengolah;
  final String? sifat;
  final String? link_scan;
  final DateTime disp_1;
  final DateTime disp_2;
  final DateTime? disp_3;
  final DateTime? disp_4;
  final String? disp_1_notes;
  final String? disp_2_notes;
  final String? disp_3_notes;
  final String? disp_4_notes;
  final String? disp_lanjut;
  final DateTime? tindak_lanjut_1;
  final DateTime? tindak_lanjut_2;
  final String? tl_notes_1;
  final String? tl_notes_2;
  final String status;
  final DateTime timestamp;

  SuratMasukModel({
    required this.id,
    required this.nomor_urut,
    required this.nama_surat,
    required this.tanggal_diterima,
    required this.tanggal_surat,
    required this.kode,
    required this.no_agenda,
    required this.no_surat,
    required this.hal,
    required this.tanggal_waktu,
    required this.tempat,
    required this.disposisi,
    required this.index,
    required this.pengolah,
    required this.sifat,
    required this.link_scan,
    required this.disp_1,
    required this.disp_2,
    required this.disp_3,
    required this.disp_4,
    required this.disp_1_notes,
    required this.disp_2_notes,
    required this.disp_3_notes,
    required this.disp_4_notes,
    required this.disp_lanjut,
    required this.tindak_lanjut_1,
    required this.tindak_lanjut_2,
    required this.tl_notes_1,
    required this.tl_notes_2,
    required this.status,
    required this.timestamp,
  });

  factory SuratMasukModel.fromJson(Map<String, dynamic> json) {
    return SuratMasukModel(
      id: json['id'],
      nomor_urut: json['nomor_urut'],
      nama_surat: json['nama_surat'],
      tanggal_diterima: DateTime.parse(json['tanggal_diterima']),
      tanggal_surat: DateTime.parse(json['tanggal_surat']),
      kode: json['kode'],
      no_agenda: json['no_agenda'],
      no_surat: json['no_surat'],
      hal: json['hal'],
      tanggal_waktu: DateTime.parse(json['tanggal_waktu']),
      tempat: json['tempat'],
      disposisi: json['disposisi'],
      index: json['index'],
      pengolah: json['pengolah'],
      sifat: json['sifat'],
      link_scan: json['link_scan'],
      disp_1: DateTime.parse(json['disp_1']),
      disp_2: DateTime.parse(json['disp_2']),
      disp_3: json['disp_3'] != null ? DateTime.parse(json['disp_3']) : null,
      disp_4: json['disp_4'] != null ? DateTime.parse(json['disp_4']) : null,
      disp_1_notes: json['disp_1_notes'],
      disp_2_notes: json['disp_2_notes'],
      disp_3_notes: json['disp_3_notes'],
      disp_4_notes: json['disp_4_notes'],
      disp_lanjut: json['disp_lanjut'],
      tindak_lanjut_1: json['tindak_lanjut_1'] != null ? DateTime.parse(json['tindak_lanjut_1']) : null,
      tindak_lanjut_2: json['tindak_lanjut_2'] != null ? DateTime.parse(json['tindak_lanjut_2']) : null,
      tl_notes_1: json['tl_notes_1'],
      tl_notes_2: json['tl_notes_2'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_urut': nomor_urut,
      'nama_surat': nama_surat,
      'tanggal_diterima': tanggal_diterima.toIso8601String(),
      'tanggal_surat': tanggal_surat.toIso8601String(),
      'kode': kode,
      'no_agenda': no_agenda,
      'no_surat': no_surat,
      'hal': hal,
      'tanggal_waktu': tanggal_waktu.toIso8601String(),
      'tempat': tempat,
      'disposisi': disposisi,
      'index': index,
      'pengolah': pengolah,
      'sifat': sifat,
      'link_scan': link_scan,
      'disp_1': disp_1.toIso8601String(),
      'disp_2': disp_2.toIso8601String(),
      'disp_3': disp_3?.toIso8601String(),
      'disp_4': disp_4?.toIso8601String(),
      'disp_1_notes': disp_1_notes,
      'disp_2_notes': disp_2_notes,
      'disp_3_notes': disp_3_notes,
      'disp_4_notes': disp_4_notes,
      'disp_lanjut': disp_lanjut,
      'tindak_lanjut_1': tindak_lanjut_1?.toIso8601String(),
      'tindak_lanjut_2': tindak_lanjut_2?.toIso8601String(),
      'tl_notes_1': tl_notes_1,
      'tl_notes_2': tl_notes_2,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class SuratKeluarModel {
  final String id;
  final int nomor_urut;
  final String kode;
  final String klasifikasi;
  final String no_register;
  final String? tujuan_surat;
  final String perihal;
  final DateTime tanggal_surat;
  final String akses_arsip;
  final String pengolah;
  final String? pembuat;
  final String? catatan;
  final String? link_surat;
  final String? koreksi_1;
  final String? koreksi_2;
  final String? status;
  final String? dok_final;
  final DateTime? dok_dikirim;
  final DateTime? tanda_terima;
  final DateTime? timestamp;
  SuratKeluarModel({
    required this.id,
    required this.nomor_urut,
    required this.kode,
    required this.klasifikasi,
    required this.no_register,
    required this.tujuan_surat,
    required this.perihal,
    required this.tanggal_surat,
    required this.akses_arsip,
    required this.pengolah,
    required this.pembuat,
    required this.catatan,
    required this.link_surat,
    required this.koreksi_1,
    required this.koreksi_2,
    required this.status,
    required this.dok_final,
    required this.dok_dikirim,
    required this.tanda_terima,
    required this.timestamp
  });

  factory SuratKeluarModel.fromJson(Map<String, dynamic> json) {
    return SuratKeluarModel(
      id: json['id'],
      nomor_urut: json['nomor_urut'],
      kode: json['kode'],
      klasifikasi: json['klasifikasi'],
      no_register: json['no_register'],
      tujuan_surat: json['tujuan_surat'],
      perihal: json['perihal'],
      tanggal_surat: DateTime.parse(json['tanggal_surat']),
      akses_arsip: json['akses_arsip'],
      pengolah: json['pengolah'],
      pembuat: json['pembuat'],
      catatan: json['catatan'],
      link_surat: json['link_surat'],
      koreksi_1: json['koreksi_1'],
      koreksi_2: json['koreksi_2'],
      status: json['status'],
      dok_final: json['dok_final'],
      dok_dikirim: json['dok_dikirim'] != null ? DateTime.parse(json['dok_dikirim']) : null,
      tanda_terima: json['tanda_terima'] != null ? DateTime.parse(json['tanda_terima']) : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_urut': nomor_urut,
      'kode': kode,
      'klasifikasi': klasifikasi,
      'no_register': no_register,
      'tujuan_surat': tujuan_surat,
      'perihal': perihal,
      'tanggal_surat': tanggal_surat,
      'akses_arsip': akses_arsip,
      'pengolah': pengolah,
      'pembuat': pembuat,
      'catatan': catatan,
      'link_surat': link_surat,
      'koreksi_1': koreksi_1,
      'koreksi_2': koreksi_2,
      'status': status,
      'dok_final': dok_final,
      'dok_dikirim': dok_dikirim,
      'tanda_terima': tanda_terima,
      'timestamp': timestamp 
    };
  }
}

