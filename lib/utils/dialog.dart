import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:line_icons/line_icons.dart';
import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:smart_doku/pages/views/users/home_page.dart';
import 'package:smart_doku/utils/function.dart';
import 'package:smart_doku/pages/views/users/surat_permohonan_page.dart';
import 'package:smart_doku/pages/forms/users/detail_page.dart';
import 'package:smart_doku/utils/widget.dart';

void showModernLogoutDialog(
  String title,
  String message,
  Color accentColor,
  Color accentColor2,
  BuildContext context,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Modern Error Dialog",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
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
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.8),
                              accentColor.withValues(alpha: 0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        title,
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
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor2,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor2.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Yes',
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
}

void showModernHomeDialog(
  String title,
  String message,
  Color accentColor,
  Color accentColor2,
  BuildContext context,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Modern Error Dialog",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
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
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.8),
                              accentColor.withValues(alpha: 0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        title,
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
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor2,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor2.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Yes',
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
}

void showModernActionDialog(
  int selectedIndex,
  String title,
  String message,
  Color accentColor,
  Color accentColor2,
  Color accentColor3,
  BuildContext context,
  List<Map<String, dynamic>> suratData,
  void Function(int) editDokumen,
  void Function(int) viewDetail,
  void Function(int) hapusDokumen,
) {
  final selectedSurat = suratData[selectedIndex];
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Modern Error Dialog",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
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
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF10B981).withValues(alpha: 0.3),
                              Color(0xFF059669).withValues(alpha: 0.2),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF10B981).withValues(alpha: 0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          LineIcons.envelopeOpen,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        title,
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
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            viewDetail(selectedIndex);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Lihat Detail',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            editDokumen(selectedIndex);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor2,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor2.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Edit Dokumen',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            hapusDokumen(selectedIndex);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor3,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor3.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Hapus Dokumen',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
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
}

void showModernHapusDialog(
  String title,
  String message,
  Color accentColor,
  Color accentColor2,
  BuildContext context,
  int index,
  List<Map<String, dynamic>> suratData,
  void Function(int) onConfirmDelete,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Modern Error Dialog",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
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
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.8),
                              accentColor.withValues(alpha: 0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        title,
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
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onConfirmDelete(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor2,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: accentColor2.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Yes',
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
}

// Action menu detailPage
void showDetailActionMenu(
  BuildContext context,
  VoidCallback onDelete,
) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      Text(
                        'Menu Aksi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Edit Button
                      buildActionMenuItem(
                        icon: Icons.edit_rounded,
                        title: 'Edit Dokumen',
                        subtitle: 'Ubah informasi dokumen',
                        color: Color(0xFF3B82F6),
                        onTap: () {
                          Navigator.pop(context);
                          // Handle edit action
                        },
                      ),
                      
                      SizedBox(height: 15),
                      
                      // Download Button
                      buildActionMenuItem(
                        icon: Icons.download_rounded,
                        title: 'Download PDF',
                        subtitle: 'Unduh dokumen dalam format PDF',
                        color: Color(0xFF10B981),
                        onTap: () {
                          Navigator.pop(context);
                          // Handle download action
                        },
                      ),
                      
                      SizedBox(height: 15),
                      
                      // Share Button
                      buildActionMenuItem(
                        icon: Icons.share_rounded,
                        title: 'Bagikan',
                        subtitle: 'Bagikan dokumen ke orang lain',
                        color: Color(0xFF8B5CF6),
                        onTap: () {
                          Navigator.pop(context);
                          // Handle share action
                        },
                      ),
                      
                      SizedBox(height: 15),
                      
                      // Delete Button
                      buildActionMenuItem(
                        icon: Icons.delete_rounded,
                        title: 'Hapus Dokumen',
                        subtitle: 'Hapus dokumen secara permanen',
                        color: Color(0xFFEF4444),
                        onTap: () {
                          Navigator.pop(context);
                          // Handle delete action
                          onDelete();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Confirmation dialog untuk delete
  void showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
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
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFEF4444).withValues(alpha: 0.8),
                          Color(0xFFDC2626).withValues(alpha: 0.6),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Hapus Dokumen?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Dokumen yang dihapus tidak dapat dikembalikan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Back to list
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Dokumen berhasil dihapus'),
                                backgroundColor: Color(0xFFEF4444),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEF4444),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Hapus',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// HomePage
void showUploadDialog(
  BuildContext context,
  void Function(BuildContext) pickDocument,
  void Function(BuildContext) pickImage,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Upload Dialog",
    barrierColor: Colors.black.withValues(alpha: 0.6),
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
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
                          Icons.upload_file,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Upload File',
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
                      Text(
                        'Pilih jenis file yang ingin diupload',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.4,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            pickImage(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF059669),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: Color(
                              0xFF059669,
                            ).withValues(alpha: 0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Upload Gambar',
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
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            pickDocument(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            shadowColor: Color(
                              0xFF4F46E5,
                            ).withValues(alpha: 0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Upload Dokumen',
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
                          onPressed: () => Navigator.pop(context),
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
}
