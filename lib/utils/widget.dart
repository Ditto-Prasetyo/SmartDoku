import 'package:flutter/material.dart';
import 'dart:ui';

// Widget HomePage
Widget buildProfileSection(Animation<double> profileOpacityAnimation) {
  return AnimatedBuilder(
    animation: profileOpacityAnimation,
    builder: (context, child) {
      return Opacity(
        opacity: profileOpacityAnimation.value,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.8, end: 1.0),
                duration: Duration(milliseconds: 600),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4F46E5).withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                      child: Icon(Icons.person, color: Colors.white, size: 60),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              Text(
                'Bintar The Real Sepuh',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Super User',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('Dokumen', '12', Icons.description),
                  _buildStatItem('Proses', '5', Icons.hourglass_empty),
                  _buildStatItem('Selesai', '7', Icons.check_circle),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildStatItem(String label, String value, IconData icon) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    ),
  );
}

// Widget untuk Header Card
Widget buildHeaderCard(Map<String, dynamic> data) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 10),
    child: ClipRRect(
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
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4F46E5).withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.description_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['hal'] ?? 'Judul Surat',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'No: ${data['no_surat']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          getStatusColor(data['status']),
                          getStatusColor(data['status']).withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: getStatusColor(
                            data['status'],
                          ).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      data['status'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  Text(
                    data['tgl_surat'],
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Widget untuk Section Title
Widget buildSectionTitle(String title) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    ),
  );
}

// Widget untuk Info Card
Widget buildInfoCard(List<Widget> children) {
  return Container(
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ),
    ),
  );
}

// Widget untuk Detail Row
Widget buildDetailRow(
  String label,
  String value, {
  bool isStatus = false,
  Color? statusColor,
  bool isLink = false,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.8),
              fontFamily: 'Roboto',
            ),
          ),
        ),
        Text(
          ': ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
            fontFamily: 'Roboto',
          ),
        ),
        Expanded(
          child: isStatus
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor?.withValues(alpha: 0.2),
                    border: Border.all(
                      color:
                          statusColor?.withValues(alpha: 0.5) ??
                          Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: statusColor ?? Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                )
              : isLink
              ? GestureDetector(
                  onTap: () {
                    // Handle link tap
                    print('Opening link: $value');
                  },
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4F46E5),
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
        ),
      ],
    ),
  );
}

// Helper functions untuk warna status
Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'selesai':
      return Color(0xFF10B981);
    case 'proses':
      return Color(0xFF3B82F6);
    default:
      return Color(0xFF6B7280);
  }
}

Color getSifatColor(String sifat) {
  switch (sifat.toLowerCase()) {
    case 'urgent':
      return Color(0xFFEF4444);
    case 'normal':
      return Color(0xFF10B981);
    case 'rahasia':
      return Color(0xFF8B5CF6);
    default:
      return Color(0xFF6B7280);
  }
}

Color getYesNoColor(String value) {
  return value.toLowerCase() == 'ya' ? Color(0xFF10B981) : Color(0xFFEF4444);
}

Color getTandaTerimaColor(String value) {
  return value.toLowerCase().contains('diterima') ||
          value.toLowerCase().contains('sudah')
      ? Color(0xFF10B981)
      : Color(0xFFF59E0B);
}
