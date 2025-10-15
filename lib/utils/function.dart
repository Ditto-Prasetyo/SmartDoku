import 'package:flutter/material.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/models/user.dart';
import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:smart_doku/pages/auth/register_cred_page.dart';
import 'package:smart_doku/pages/forms/admins/desktop/detail_page_userManagement.dart';
import 'package:smart_doku/pages/forms/admins/phones/detail_page_admin_keluar.dart';
import 'package:smart_doku/pages/forms/admins/phones/detail_page_admin_phones.dart';
import 'package:smart_doku/pages/forms/users/detail_keluar_page.dart';
import 'package:smart_doku/pages/forms/users/detail_masuk_page.dart';
import 'package:smart_doku/pages/splashs/splashscreen_after_page.dart';
import 'package:smart_doku/services/auth.dart';
import 'package:smart_doku/utils/dialog.dart';

// Auths Section

// -- Login Page --
void handleLogin(
  BuildContext context,
  TextEditingController usernameController,
  TextEditingController passwordController,
) async {
  final usernameChecker = usernameController.text.trim();
  final passwordChecker = passwordController.text.trim();

  AuthService _auth = AuthService();
  final session = await _auth.login(usernameController.text, passwordController.text);

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
  } else if (!session) {
    showModernErrorDialog(
      context,
      '❌ Auth Error',
      'Username atau password anda salah!',
      Colors.redAccent,
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
    MaterialPageRoute(builder: (context) => RegisterCredPage(username: usernameController.text, password: passwordController.text, email: emailController.text)),
  );
}

void checkLengthEmail(
  BuildContext context,
  String value,
  TextEditingController emailController,
) {
  final int _maxLengthEmail = 191;
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
      'Pastikan Bahwa Anda Mengisi Email Dengan Benar!',
      Colors.deepOrange,
      emailController,
    );
  }
}

// -- Register Cred Page --
void handleRegister(
  BuildContext context,
  String? selectedWorkField,
  String? username,
  String? email,
  String? password,
  TextEditingController _nameController,
  TextEditingController _phoneController,
  TextEditingController _addressController,
) async {
  final NameChecker = _nameController.text.trim();
  final PhoneChecker = _phoneController.text.trim();
  final AddressChecker = _addressController.text.trim();

  AuthService _auth = AuthService();

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

  final session = await _auth.register(_nameController.text, username!, email!, password!, selectedWorkField, _addressController.text, _phoneController.text);

  if (!session) {
    showModernErrorDialog(context, '❌ Register Error', "Ada masalah dalam server, mohon tunggu beberapa saat!", Colors.redAccent);
    
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
  showModernLogoutDialog(
    '⚠️ Logout',
    'Apakah Anda Yakin Ingin Keluar?',
    Colors.orange,
    Colors.deepOrange,
    context,
  );
}

void logoutDesktop(BuildContext context) {
  showModernLogoutDesktopDialog(
    '⚠️ Logout',
    'Apakah Anda Yakin Ingin Keluar?',
    Colors.orange,
    Colors.deepOrange,
    context,
  );
}

void home(BuildContext context) {
  showModernHomeDialog(
    '⚠️ Go Home',
    'Apakah Anda Yakin Ingin Kembali ke Halaman Dashboard?',
    Colors.orange,
    Colors.deepOrange,
    context,
  );
}

void homeAdmin(BuildContext context) {
  showModernHomeAdminDialog(
    '⚠️ Go Home',
    'Apakah Anda Yakin Ingin Kembali ke Halaman Dashboard?',
    Colors.orange,
    Colors.deepOrange,
    context,
  );
}

void actionUserMasuk(
  int index,
  BuildContext context,
  List<SuratMasukModel?> listData,
  void Function(int) editDokumen,
  void Function(int) viewDetail,
  void Function(int) hapusDokumen,
) {
  final tempSurat = listData[index];

  String namaSurat = tempSurat?.nama_surat ?? '';
  String namaSuratPendek = namaSurat.length > 30
      ? '${namaSurat.substring(0, 30)}...'
      : namaSurat;
  print('Anda Menggunakan User');
  showActionSuratMasukForUserDialog(
    index,
    '${tempSurat?.nama_surat}',
    'Surat ini berisi $namaSuratPendek\n\nSurat ini dikirimkan pada tanggal ${tempSurat?.tanggal_diterima}',
    Colors.indigo.withValues(alpha: 0.9),
    Colors.orange,
    Colors.deepOrange,
    Color(0xFF10B981).withValues(alpha: 0.4),
    context,
    listData,
    viewDetail,
  );
}

void actionUserKeluar(
  int index,
  BuildContext context,
  List<SuratKeluarModel?> listSurat,
  void Function(int) viewDetail,
) {
  final tempSurat = listSurat[index];

  String perihalText = tempSurat?.perihal ?? '';
  String perihalPendek = perihalText.length > 30
      ? '${perihalText.substring(0, 30)}...'
      : perihalText;
  showActionSuratKeluarForUserDialog(
    index,
    '${tempSurat?.perihal}',
    'Surat ini berisi $perihalPendek\n\nSurat ini dikirimkan pada tanggal ${tempSurat?.tanggal_surat}',
    Colors.indigo.withValues(alpha: 0.9),
    Colors.orange,
    Colors.deepOrange,
    Color(0xFF10B981).withValues(alpha: 0.4),
    context,
    listSurat,
    viewDetail,
  );
}

void actionAdmin(
  int index,
  BuildContext context,
  List<SuratMasukModel?> suratData,
  void Function(int) editDokumen,
  void Function(int) viewDetailAdmin,
  void Function(int) hapusDokumen,
) {
  final surat = suratData[index];

  String perihal = surat?.hal ?? '';
  String perihalPendek = perihal.length > 30
      ? '${perihal.substring(0, 30)}...'
      : perihal;
  print('Anda Menggunakan Admin \nAnda memilih surat ${surat?.nama_surat}');
  showModernActionAdminMasukDialog(
    index,
    '${surat?.nama_surat}',
    'Surat ini berisi $perihalPendek\n\nSurat ini dikirimkan pada tanggal ${surat?.tanggal_surat.toString()}',
    Colors.indigo.withValues(alpha: 0.9),
    Colors.orange,
    Colors.deepOrange,
    Color(0xFF10B981).withValues(alpha: 0.4),
    context,
    suratData,
    editDokumen,
    viewDetailAdmin,
    hapusDokumen,
    pickDocument,
  );
}

void actionAdminKeluar(
  int index,
  BuildContext context,
  List<SuratKeluarModel?> listSurat,
  void Function(int) editDokumenAdmin,
  void Function(int) viewDetailAdmin,
  void Function(int) hapusDokumen,
) {
  final surat = listSurat[index];

  String newPerihal = surat?.perihal ?? '';
  String perihalPendek = newPerihal.length > 30
      ? '${newPerihal.substring(0, 30)}...'
      : newPerihal;
  print('Anda Menggunakan Admin \nAnda memilih surat ${surat?.perihal}');
  showModernActionAdminKeluarDialog(
    index,
    '${surat?.perihal}',
    'Surat ini berisi $perihalPendek\n\nSurat ini dikirimkan pada tanggal ${surat?.tanggal_surat}',
    Colors.indigo.withValues(alpha: 0.9),
    Colors.orange,
    Colors.deepOrange,
    Color(0xFF10B981).withValues(alpha: 0.4),
    context,
    listSurat,
    editDokumenAdmin,
    viewDetailAdmin,
    hapusDokumen,
    pickDocument,
  );
}

void actionAdminManagementUser(
  int index,
  BuildContext context,
  List<UserModel?> listSurat,
  void Function(int) editUserAccount,
  void Function(int) viewDetailUserAccount,
  void Function(int) hapusUserAccount,
) {
  final userData = listSurat[index];

  String newName = userData?.name ?? '';
  String perihalPendek = newName.length > 30
      ? '${newName.substring(0, 30)}...'
      : newName;
  print('Anda Menggunakan Admin \nAnda memilih user ${userData?.name}');
  showModernActionManagementUserDialog(
    index,
    '${userData?.name}',
    'User $perihalPendek\n\ndari bidang ${userData?.bidang}',
    Colors.indigo.withValues(alpha: 0.9),
    Colors.orange,
    Colors.deepOrange,
    Color(0xFF10B981).withValues(alpha: 0.4),
    context,
    listSurat,
    editUserAccount,
    viewDetailUserAccount,
    hapusUserAccount,
  );
}

void viewDetail(
  BuildContext context,
  int index,
  List<SuratMasukModel?> suratData,
) {
  final surat = suratData[index];
  print('View Detail - ID: ${surat!.nomor_urut}, Judul: ${surat.nama_surat}');

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DetailPage(suratData: surat)),
  );
}

void viewDetailKeluar(
  BuildContext context,
  int index,
  List<SuratKeluarModel?> suratData,
) {
  final surat = suratData[index];
  print('View Detail - ID: ${surat?.id}, Judul: ${surat?.klasifikasi}');

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DetailPageKeluar(suratData: surat)),
  );
}

void viewDetailAdmin(
  BuildContext context,
  int index,
  List<SuratMasukModel?> suratData,
) {
  final surat = suratData[index];
  print('View Detail - ID: ${surat?.id}, Judul: ${surat?.nama_surat}');

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DetailPageAdmin(suratData: surat)),
  );
}

void viewDetailAdminKeluar(
  BuildContext context,
  int index,
  List<SuratKeluarModel?> suratData,
) {
  final surat = suratData[index];
  print('View Detail - ID: ${surat?.nomor_urut}, Judul: ${surat?.klasifikasi}');
  print('Anda memakai Detail Surat Keluar');

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DetailPageAdminKeluar(suratData: surat)),
  );
}

void viewDetailUserManagement(
  BuildContext context,
  int index,
  List<UserModel?> userData,
) {
  final data = userData[index];
  print('View Detail - id: ${data!.id}, Name: ${data.name}, Role: ${data.bidang}');

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => DetailPageUsermanagement(userModel: data)),
  );
}

  void editDokumen(
    BuildContext context,
    int index, 
    List<SuratMasukModel?> suratData,
    void Function() refreshEditState
    ) {
    final surat = suratData[index];
    print('Edit Document - ID: ${surat?.id}, Judul: ${surat?.nama_surat}, \nPengolah : ${surat?.pengolah}');
    showEditSuratDialog(context, index, suratData, refreshEditState);
  }

  void editDokumenAdmin(
    BuildContext context,
    int index, 
    List<SuratMasukModel?> suratData,
    void Function() refreshEditState
    ) {
    final surat = suratData[index];
    print('Edit Document - ID: ${surat?.id}, Judul: ${surat?.nama_surat}, \nPengirim : ${surat?.pengolah}');
    // showEditSuratDialog(context, index, suratData, refreshEditState);
  }

  void editDokumenAdminKeluar(
    BuildContext context,
    int index, 
    List<SuratKeluarModel?> suratData,
    void Function() refreshEditState
    ) {
    final surat = suratData[index];
    print('Edit Document - ID: ${surat?.id}, Judul: ${surat?.klasifikasi}, \nPembuat : ${surat?.pembuat}');
    showEditSuratKeluarDialog(context, index, suratData, refreshEditState);
  }

  void editUserManagement(
    BuildContext context,
    int index, 
    List<UserModel?> userData,
    void Function() refreshEditState
    ) {
    final data = userData[index];
    print('Edit User - ID: ${data?.id}, User: ${data?.name}, \nBidang : ${data?.bidang}');
    showEditUserManagementDialog(context, index, userData, refreshEditState);
  }

  
void tambahSuratMasuk(BuildContext context, Function(SuratMasukModel?) onSuratAdded) {
  showModernTambahSuratDialog(
    'Tambah Surat Masuk',
    'Pilih metode untuk menambahkan surat masuk baru',
    Color(0xFF10B981), // Accent color 1 (hijau)
    Color(0xFF059669), // Accent color 2 (hijau gelap)
    context,
    onSuratAdded
  );
}

void tambahSuratKeluar(BuildContext context, Function(SuratKeluarModel?) onSuratKeluarAdded) {
  showModernTambahSuratKeluarDialog(
    'Tambah Surat Keluar',
    'Pilih metode untuk menambahkan surat keluar baru',
    Color(0xFF10B981), // Accent color 1 (hijau)
    Color(0xFF059669), // Accent color 2 (hijau gelap)
    context,
    onSuratKeluarAdded
  );
}

void tambahSuratMasukDesktop(BuildContext context, Function(SuratMasukModel?) onSuratKeluarAdded) {
  showModernTambahSuratMasukDesktopDialog(
    'Tambah Surat Masuk',
    'Pilih metode untuk menambahkan surat masuk baru',
    Color(0xFF10B981), // Accent color 1 (hijau)
    Color(0xFF059669), // Accent color 2 (hijau gelap)
    context,
    onSuratKeluarAdded,
  );
}

void tambahSuratKeluarDesktop(BuildContext context, Function(SuratKeluarModel?) onSuratKeluarAdded) {
  showModernTambahSuratKeluarDesktopDialog(
    'Tambah Surat Keluar',
    'Pilih metode untuk menambahkan surat keluar baru',
    Color(0xFF10B981), // Accent color 1 (hijau)
    Color(0xFF059669), // Accent color 2 (hijau gelap)
    context,
    onSuratKeluarAdded
  );
}

void tambahUser(BuildContext context, String bidang, Function(UserModel?) onUserAdded) {
  showModernTambahUserDialog(
    'Tambah User (Tidak Disarankan!)',
    bidang,
    'Pilih metode untuk menambahkan user',
    Color(0xFF10B981), // Accent color 1 (hijau)
    Color(0xFF059669), // Accent color 2 (hijau gelap)
    context,
    onUserAdded,
  );
}


void hapusDokumen(
  BuildContext context,
  int index,
  List<SuratMasukModel?> suratData,
  void Function(int) onConfirmDelete, // ⬅️ Tambahin ini
) {
  final surat = suratData[index];
  showModernHapusSuratMasukDialog(
    '⚠️ Konfirmasi Hapus',
    'Apakah Anda yakin ingin menghapus surat "${surat!.nama_surat}"?',
    Colors.orange,
    Colors.deepOrange,
    context,
    index,
    suratData,
    onConfirmDelete, // ⬅️ Callback buat jalanin setState nanti
  );
}

void hapusDokumenDesktop(
  BuildContext context,
  int index,
  List<SuratMasukModel?> suratData,
  void Function(int) onConfirmDelete,
) {
  final surat = suratData[index];
  showModernHapusMasukDialogDesktop(
    '⚠️ Konfirmasi Hapus',
    'Apakah Anda yakin ingin menghapus surat "${surat?.nama_surat}"?',
    Colors.orange,
    Colors.deepOrange,
    context,
    index,
    suratData,
    onConfirmDelete,
  );
}

void hapusDokumenKeluar(
  BuildContext context,
  int index,
  List<SuratKeluarModel?> suratData,
  void Function(int) onConfirmDelete, // ⬅️ Tambahin ini
) {
  final surat = suratData?[index];
  showModernHapusDialog(
    '⚠️ Konfirmasi Hapus',
    'Apakah Anda yakin ingin menghapus surat "${surat?.klasifikasi}"?',
    Colors.orange,
    Colors.deepOrange,
    context,
    index,
    suratData,
    onConfirmDelete,
  );
}

void hapusDokumenKeluarDesktop(
  BuildContext context,
  int index,
  List<SuratKeluarModel?> suratData,
  void Function(int) onConfirmDelete, 
) {
  final surat = suratData[index];
  showModernHapusDialogDesktop(
    '⚠️ Konfirmasi Hapus',
    'Apakah Anda yakin ingin menghapus surat "${surat?.klasifikasi}"?',
    Colors.orange,
    Colors.deepOrange,
    context,
    index,
    suratData,
    onConfirmDelete,
  );
}

void hapusUserDesktop(
  BuildContext context,
  int index,
  List<UserModel?> userData,
  void Function(String) onConfirmDelete, 
) {
  final user = userData[index];
  showModernHapusUserManagementDesktop(
    '⚠️ Konfirmasi Hapus',
    'Apakah Anda yakin ingin menghapus User "${user?.name}"?',
    Colors.orange,
    Colors.deepOrange,
    context,
    index,
    userData,
    onConfirmDelete,
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
    'no_agenda':
        'AG-${DateTime.now().year}-${surat['id']?.toString().padLeft(4, '0') ?? '0001'}',
    'no_surat':
        'ST/${DateTime.now().year}/${surat['id']?.toString().padLeft(3, '0') ?? '001'}',
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
