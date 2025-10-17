import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:smart_doku/utils/hover.dart';
import 'dart:ui';

class WhatsappService {
  Future<bool> launchWhatsApp() async {
    final adminNumber = "6281330030369";
    final message =
        "Selamat pagi Admin, saya lupa password akun saya. Mohon bantuannya. Terima kasih.";
    final url =
        "https://wa.me/$adminNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }
}

class SupportServiceLettersData {
  final String adminNumber = "6281330030369";

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return "Selamat pagi";
    } else if (hour >= 11 && hour < 15) {
      return "Selamat siang";
    } else if (hour >= 15 && hour < 18) {
      return "Selamat sore";
    } else {
      return "Selamat malam";
    }
  }

  Future<bool> launchSupport(BuildContext context) async {
    final greeting = getGreeting();

    final issue = await _showIssueDialog(context);
    if (issue == null || issue.isEmpty) return false;

    final message =
        "$greeting Mas Dani, mohon maaf mengganggu waktunya. Saya memiliki masalah sebagai berikut:\n\n$issue\n\nTolong dibantu yak, makasih";
    final url =
        "https://wa.me/$adminNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> _showIssueDialog(BuildContext context) async {
    final issues = [
      'Data tidak muncul setelah di edit',
      'Aplikasi error',
      'Aplikasi terdapat bug',
          'File tidak muncul setelah di upload',
          'lainnya...', 
    ];

    final issueIcons = [
      Icons.person_outline,
      Icons.lock_outline,
      Icons.visibility_off_outlined,
      Icons.error_outline,
      Icons.help_outline,
    ];

    String? selectedIssue;

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon Header
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF7C2D12).withValues(alpha: 0.8),
                                    Color(0xFF9A3412).withValues(alpha: 0.6),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF7C2D12).withValues(alpha: 0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Title
                            Text(
                              'Pilih Masalah Anda',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 15),

                            // Subtitle
                            Text(
                              'Pilih salah satu masalah dari dropdown dibawah',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.4,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 25),

                            // Dropdown Content
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.1),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: DropdownButtonFormField<String>(
                                  value: selectedIssue,
                                  hint: Container(
                                    padding: EdgeInsets.only(left: 16, right: 16, top: 1, bottom: 0),
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: Row(
                                      children: [
                                        SizedBox(height: 10),
                                        Icon(
                                          Icons.help_outline,
                                          color: Color(0xFF00D4FF),
                                          size: 24,
                                        ),
                                        SizedBox(width: 18),
                                        Expanded(
                                          child: Text(
                                            "Pilih masalah Anda",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white.withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  dropdownColor: Colors.white.withValues(alpha: 0.2),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  icon: Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  isExpanded: true,
                                  selectedItemBuilder: (context) {
                                    return issues.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      String issue = entry.value;
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 16, right: 16),
                                        child: Row(
                                          children: [
                                            SizedBox(height: 100),
                                            Icon(
                                              issueIcons[index],
                                              color: Color(0xFF00D4FF),
                                              size: 24,
                                            ),
                                            SizedBox(width: 18),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Text(
                                                  issue,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList();
                                  },
                                  items: issues.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    String issue = entry.value;
                                    return DropdownMenuItem(
                                      value: issue,
                                      child: HoverMenuItemHelper(
                                        label: issue,
                                        icon: issueIcons[index],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => selectedIssue = value);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 15),

                            // Action Buttons
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: selectedIssue != null
                                    ? () => Navigator.pop(context, selectedIssue)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedIssue != null 
                                      ? Color(0xFF059669) 
                                      : Colors.grey.withValues(alpha: 0.3),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: selectedIssue != null ? 8 : 0,
                                  shadowColor: selectedIssue != null 
                                      ? Color(0xFF059669).withValues(alpha: 0.4)
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Kirim',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),

                            Container(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context, null),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SupportServiceAccount {
  final String superAdminNumber = "6281330030369";

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return "Selamat pagi";
    } else if (hour >= 11 && hour < 15) {
      return "Selamat siang";
    } else if (hour >= 15 && hour < 18) {
      return "Selamat sore";
    } else {
      return "Selamat malam";
    }
  }

  Future<bool> launchSupport(BuildContext context) async {
    final greeting = getGreeting();

    final issue = await _showIssueDialog(context);
    if (issue == null || issue.isEmpty) return false;

    final message =
        "$greeting Admin, mohon maaf mengganggu waktunya. Saya memiliki masalah sebagai berikut:\n\n$issue";
    final url =
        "https://wa.me/$superAdminNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> _showIssueDialog(BuildContext context) async {
    final issues = [
      'Data profile saya berbeda dengan aslinya',
      'Tidak bisa mengganti password',
      'Tidak bisa melihat profile',
      'Aplikasi error',
      'Lainnya...',
    ];

    final issueIcons = [
      Icons.person_outline,
      Icons.lock_outline,
      Icons.visibility_off_outlined,
      Icons.error_outline,
      Icons.help_outline,
    ];

    String? selectedIssue;

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon Header
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF7C2D12).withValues(alpha: 0.8),
                                    Color(0xFF9A3412).withValues(alpha: 0.6),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF7C2D12).withValues(alpha: 0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Title
                            Text(
                              'Pilih Masalah Anda',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 15),

                            // Subtitle
                            Text(
                              'Pilih salah satu masalah dari dropdown dibawah',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.4,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 25),

                            // Dropdown Content
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.1),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: DropdownButtonFormField<String>(
                                  value: selectedIssue,
                                  hint: Container(
                                    padding: EdgeInsets.only(left: 16, right: 16, top: 1, bottom: 0),
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: Row(
                                      children: [
                                        SizedBox(height: 10),
                                        Icon(
                                          Icons.help_outline,
                                          color: Color(0xFF00D4FF),
                                          size: 24,
                                        ),
                                        SizedBox(width: 18),
                                        Expanded(
                                          child: Text(
                                            "Pilih masalah Anda",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white.withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  dropdownColor: Colors.white.withValues(alpha: 0.2),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  icon: Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  isExpanded: true,
                                  selectedItemBuilder: (context) {
                                    return issues.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      String issue = entry.value;
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 16, right: 16),
                                        child: Row(
                                          children: [
                                            SizedBox(height: 100),
                                            Icon(
                                              issueIcons[index],
                                              color: Color(0xFF00D4FF),
                                              size: 24,
                                            ),
                                            SizedBox(width: 18),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Text(
                                                  issue,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList();
                                  },
                                  items: issues.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    String issue = entry.value;
                                    return DropdownMenuItem(
                                      value: issue,
                                      child: HoverMenuItemHelper(
                                        label: issue,
                                        icon: issueIcons[index],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => selectedIssue = value);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 25),

                            // Action Buttons
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: selectedIssue != null
                                    ? () => Navigator.pop(context, selectedIssue)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedIssue != null 
                                      ? Color(0xFF059669) 
                                      : Colors.grey.withValues(alpha: 0.3),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: selectedIssue != null ? 8 : 0,
                                  shadowColor: selectedIssue != null 
                                      ? Color(0xFF059669).withValues(alpha: 0.4)
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Kirim',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),

                            Container(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context, null),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}