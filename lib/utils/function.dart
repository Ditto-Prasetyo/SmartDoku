import 'package:flutter/material.dart';
import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:smart_doku/pages/auth/register_cred_page.dart';
import 'package:smart_doku/pages/forms/users/detail_page.dart';
import 'package:smart_doku/pages/splashs/splashscreen_after_page.dart';
import 'package:smart_doku/utils/dialog.dart';

// Auths Section

// -- Login Page --
void handleLogin(
  BuildContext context,
  TextEditingController usernameController,
  TextEditingController passwordController,
) {
  final usernameChecker = usernameController.text.trim();
  final passwordChecker = passwordController.text.trim();

  if (usernameChecker.isEmpty && passwordChecker.isEmpty) {
    showModernErrorDialog(
      context,
      '❌ Login Error',
      'Username dan Password tidak boleh kosong!',
      Colors.redAccent,
    );
    return;
  } else if (usernameChecker.isEmpty) {
    showModernErrorDialog(
      context,
      '❌ Username Required',
      'Username tidak boleh kosong!',
      Colors.orange,
    );
    return;
  } else if (passwordChecker.isEmpty) {
    showModernErrorDialog(
      context,
      '❌ Password Required',
      'Password tidak boleh kosong!',
      Colors.orange,
    );
    return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Splash()),
  );
}

void checkLengthPassword(
  BuildContext context,
  String value,
  TextEditingController passwordController,
) {
  final int _maxLengthPassword = 20;

  if (value.contains(' ')) {
    showErrorDialog(
      context,
      '⚠️ Invalid Format',
      'Password tidak boleh mengandung spasi!',
      Colors.amber,
      passwordController,
    );
    return;
  }

  if (value.length > _maxLengthPassword) {
    passwordController.text = value.substring(0, _maxLengthPassword);
    passwordController.selection = TextSelection.fromPosition(
      TextPosition(offset: passwordController.text.length),
    );
    showErrorDialog(
      context,
      '⛔ Error',
      'Pastikan Bahwa Anda Mengisi Password Dengan Benar!',
      Colors.deepOrange,
      passwordController,
    );
  }
}

void checkLengthUsername(
  BuildContext context,
  String value,
  TextEditingController usernameController,
) {
  final int maxLengthUsername = 30;
  if (value.length > maxLengthUsername) {
    usernameController.text = value.substring(0, maxLengthUsername);
    usernameController.selection = TextSelection.fromPosition(
      TextPosition(offset: usernameController.text.length),
    );
    showErrorDialog(
      context,
      '⛔ Error',
      'Pastikan Bahwa Anda Mengisi Username Dengan Benar!',
      Colors.deepOrange,
      usernameController,
    );
  }
}

// -- Register Page --
void handleSession(
  BuildContext context,
  TextEditingController usernameController,
  TextEditingController passwordController,
  TextEditingController emailController,
  final List<String> allowedDomains,
) {
  final usernameChecker = usernameController.text.trim();
  final passwordChecker = passwordController.text.trim();
  final emailChecker = emailController.text
      .trim(); // Fix: sebelumnya salah, keisi password

  List<String> kosongFields = [];

  if (usernameChecker.isEmpty) kosongFields.add('Username');
  if (passwordChecker.isEmpty) kosongFields.add('Password');
  if (emailChecker.isEmpty) kosongFields.add('Email');

  if (kosongFields.isNotEmpty) {
    String message = '';
    if (kosongFields.length == 1) {
      message = '${kosongFields[0]} tidak boleh kosong!';
    } else if (kosongFields.length == 2) {
      message = '${kosongFields[0]} dan ${kosongFields[1]} tidak boleh kosong!';
    } else {
      message =
          kosongFields.sublist(0, kosongFields.length - 1).join(', ') +
          ', dan ${kosongFields.last} tidak boleh kosong!';
    }

    showModernErrorDialog(context, '❌ Login Error', message, Colors.redAccent);
    return;
  }

  // Validasi format email
  if (!emailChecker.contains('@')) {
    showErrorDialogEmailFormat(
      context,
      '⚠️ Email Tidak Valid',
      "Email harus mengandung simbol '@'!",
      Colors.orange,
    );
    return;
  }

  // Validasi domain email
  bool isAllowedDomain = allowedDomains.any(
    (domain) => emailChecker.endsWith(domain),
  );
  if (!isAllowedDomain) {
    showErrorDialogEmailFormat(
      context,
      '⚠️ Email Tidak Valid',
      "Email hanya boleh dari domain berikut:\n" + allowedDomains.join(', '),
      Colors.orange,
    );
    return;
  }

  // Lanjut ke halaman register
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => RegisterCredPage()),
  );
}

void checkLengthEmail(
  BuildContext context,
  String value,
  TextEditingController emailController,
) {
  final int _maxLengthEmail = 20;
  if (value.contains(' ')) {
    showErrorDialogEmailSpaceChecker(
      context,
      '⚠️ Invalid Format',
      'Email Tidak Boleh Mengandung Spasi',
      Colors.orange,
      emailController,
    );
  }
  if (value.length > _maxLengthEmail) {
    emailController.text = value.substring(0, _maxLengthEmail);
    emailController.selection = TextSelection.fromPosition(
      TextPosition(offset: emailController.text.length),
    );
    showErrorDialogLengthEmail(
      context,
      '⛔ Error',
      'Pastikan Bahwa Anda Mengisi Username Dengan Benar!',
      Colors.deepOrange,
      emailController,
    );
  }
}

// -- Register Cred Page --
void handleRegister(
  BuildContext context,
  String? selectedWorkField,
  TextEditingController _nameController,
  TextEditingController _phoneController,
  TextEditingController _addressController,
) {
  final NameChecker = _nameController.text.trim();
  final PhoneChecker = _phoneController.text.trim();
  final AddressChecker = _addressController.text.trim();

  if (NameChecker.isEmpty ||
      PhoneChecker.isEmpty ||
      AddressChecker.isEmpty ||
      selectedWorkField == null) {
    List<String> kosongFields = [];

    if (NameChecker.isEmpty) kosongFields.add('Nama');
    if (PhoneChecker.isEmpty) kosongFields.add('Nomor Telepon');
    if (AddressChecker.isEmpty) kosongFields.add('Alamat');
    if (selectedWorkField == null) kosongFields.add('Bidang Pekerjaan');

    String message = '';
    if (kosongFields.length == 1) {
      message = '${kosongFields[0]} tidak boleh kosong!';
    } else if (kosongFields.length == 2) {
      message = '${kosongFields[0]} dan ${kosongFields[1]} tidak boleh kosong!';
    } else {
      message =
          kosongFields.sublist(0, kosongFields.length - 1).join(', ') +
          ', dan ${kosongFields.last} tidak boleh kosong!';
    }

    showModernErrorDialog(context, '❌ Login Error', message, Colors.redAccent);
    return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

void checkLengthName(
  BuildContext context,
  String value,
  TextEditingController _nameController,
) {
  final int _maxLengthname = 16;
  if (value.length > _maxLengthname) {
    _nameController.text = value.substring(0, _maxLengthname);
    _nameController.selection = TextSelection.fromPosition(
      TextPosition(offset: _nameController.text.length),
    );
    showErrorDialog(
      context,
      '⛔ Error',
      'Pastikan Bahwa Anda Mengisi Nama Dengan Benar!',
      Colors.deepOrange,
      _nameController,
    );
  }
}

void checkLengthPhone(
  BuildContext context,
  String value,
  TextEditingController _phoneController,
) {
  final int _maxLengthphone = 30;
  if (value.length > _maxLengthphone) {
    _phoneController.text = value.substring(0, _maxLengthphone);
    _phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: _phoneController.text.length),
    );
    showErrorDialog(
      context,
      '⛔ Error',
      'Pastikan Bahwa Anda Mengisi Nomor Telepon Dengan Benar!',
      Colors.deepOrange,
      _phoneController,
    );
  }
}

void checkLengthAddress(
  BuildContext context,
  String value,
  TextEditingController _addressController,
) {
  final int _maxLengthaddress = 191;
  if (value.length > _maxLengthaddress) {
    _addressController.text = value.substring(0, _maxLengthaddress);
    _addressController.selection = TextSelection.fromPosition(
      TextPosition(offset: _addressController.text.length),
    );
    showErrorDialog(
      context,
      '⛔ Error',
      'Pastikan Bahwa Anda Mengisi Alamat Rumah Dengan Benar!',
      Colors.deepOrange,
      _addressController,
    );
  }
}
// Other Functions

void logout(BuildContext context) {
  Navigator.of(context).pop();
  showModernLogoutDialog(
    '⚠️ Logout',
    'Apakah Anda Yakin Ingin Keluar?',
    Colors.orange,
    Colors.deepOrange,
    context,
  );
}

void home(BuildContext context) {
  Navigator.of(context).pop();
  showModernHomeDialog(
    '⚠️ Go Home',
    'Apakah Anda Yakin Ingin Kembali ke Halaman Dashboard?',
    Colors.orange,
    Colors.deepOrange,
    context,
  );
}

void action(
  int index,
  BuildContext context,
  List<Map<String, dynamic>> suratData,
  void Function(int) editDokumen,
  void Function(int) viewDetail,
  void Function(int) hapusDokumen,
) {
  final surat = suratData[index];

  String perihal = surat['perihal'] ?? '';
  String perihalPendek = perihal.length > 30
      ? '${perihal.substring(0, 30)}...'
      : perihal;

  showModernActionDialog(
    index,
    '${surat['judul']}',
    'Surat ini berisi $perihalPendek\n\nSurat ini dikirimkan pada tanggal ${surat['tanggal']}',
    Color(0xFF10B981).withValues(alpha: 0.3),
    Colors.orange,
    Colors.deepOrange,
    context,
    suratData,
    editDokumen,
    viewDetail,
    hapusDokumen,
  );
}

void viewDetail(
  BuildContext context,
  int index,
  List<Map<String, dynamic>> suratData,
) {
  final surat = suratData[index];
  print('View Detail - ID: ${surat['id']}, Judul: ${surat['judul']}');

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DetailPage(suratData: surat)),
  );
}

void editDokumen(int index, List<Map<String, dynamic>> suratData) {
  final surat = suratData[index];
  print('Edit Document - ID: ${surat['id']}, Judul: ${surat['judul']}');
}

void hapusDokumen(
  BuildContext context,
  int index,
  List<Map<String, dynamic>> suratData,
  void Function(int) onConfirmDelete, // ⬅️ Tambahin ini
) {
  final surat = suratData[index];
  showModernHapusDialog(
    '⚠️ Konfirmasi Hapus',
    'Apakah Anda yakin ingin menghapus surat "${surat['judul']}"?',
    Colors.orange,
    Colors.deepOrange,
    context,
    index,
    suratData,
    onConfirmDelete, // ⬅️ Callback buat jalanin setState nanti
  );
}

// Function untuk pick image (tambahin package image_picker di pubspec.yaml)
void pickImage(BuildContext context) async {
  // final ImagePicker picker = ImagePicker();
  // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  // if (image != null) {
  //   // Handle uploaded image
  //   print('Image selected: ${image.path}');
  // }

  // Sementara pake snackbar dulu
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Fitur upload gambar akan segera tersedia')),
  );
}

// Function untuk pick document (tambahin package file_picker di pubspec.yaml)
void pickDocument(BuildContext context) async {
  // final FilePickerResult? result = await FilePicker.platform.pickFiles(
  //   type: FileType.custom,
  //   allowedExtensions: ['pdf', 'doc', 'docx'],
  // );
  // if (result != null) {
  //   // Handle uploaded document
  //   print('Document selected: ${result.files.single.path}');
  // }

  // Sementara pake snackbar dulu
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Fitur upload dokumen akan segera tersedia')),
  );
}

// edit Dokumen
void editDocument(
  BuildContext context,
  int index,
  List<Map<String, dynamic>> suratData,

  ) {
  final surat = suratData[index];
  print('Edit Document - ID: ${surat['id']}, Judul: ${surat['judul']}');
  
  // Ambil detail data untuk edit
  final detailData = {
    'nomor': surat['id']?.toString() ?? '001',
    'surat_dari': surat['pengirim'] ?? 'HRD Department',
    'diterima_tgl': '28 Juli 2025',
    'tgl_surat': surat['tanggal'] ?? '28 Juli 2025',
    'kode': 'SR-2025-${surat['id']?.toString().padLeft(3, '0') ?? '001'}',
    'no_urut': '${surat['id']?.toString() ?? '1'}/25',
    'no_agenda': 'AG-${DateTime.now().year}-${surat['id']?.toString().padLeft(4, '0') ?? '0001'}',
    'no_surat': 'ST/${DateTime.now().year}/${surat['id']?.toString().padLeft(3, '0') ?? '001'}',
    'hal': surat['judul'] ?? 'Surat Pemberitahuan',
    'hari_tanggal': 'Senin, ${surat['tanggal'] ?? '28 Juli 2025'}',
    'waktu': '09:00 WIB',
    'tempat': 'Ruang Rapat Utama',
    'disposisi': 'Segera ditindaklanjuti',
    'index': 'IDX-${surat['id']?.toString() ?? '1'}',
    'pengolah': 'Ahmad Santoso',
    'sifat': surat['status'] == 'Proses' ? 'Urgent' : 'Normal',
    'link_scan': 'https://drive.google.com/file/scan-${surat['id'] ?? 1}',
    'disp_1': 'Kepala Bagian - Review dokumen',
    'disp_2': 'Manager Operasional - Persetujuan',
    'disp_3': 'Direktur - Final approval',
    'disp_4': 'Sekretaris - Dokumentasi',
    'disp_lanjutan': 'Kirim ke semua departemen terkait',
    'tindak_lanjut_1': 'Koordinasi dengan team',
    'tindak_lanjut_2': 'Laporan progress mingguan',
    'status': surat['status'] ?? 'Proses',
    'dokumen_final': 'Final_Doc_${surat['id'] ?? 1}.pdf',
    'dokumen_dikirim': surat['status'] == 'Selesai' ? 'Ya' : 'Belum',
    'tanda_terima': surat['status'] == 'Selesai' ? 'Sudah diterima' : 'Pending',
  };
  
  
}