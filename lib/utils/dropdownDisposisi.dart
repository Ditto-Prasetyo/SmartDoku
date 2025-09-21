import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:smart_doku/utils/map.dart';
import 'package:smart_doku/models/surat.dart';
import 'package:smart_doku/services/surat.dart';
import 'package:smart_doku/services/service.dart';
import 'package:smart_doku/services/auth.dart';


class DisposisiDropdown extends StatefulWidget {
  final List<String> initialValues;
  final Map<String, String> workFields;
  final Function(List<String>) onChanged;

  const DisposisiDropdown({
    super.key,
    this.initialValues = const [],
    required this.workFields,
    required this.onChanged,
  });

  @override
  State<DisposisiDropdown> createState() => _DisposisiDropdownState();
}

class _DisposisiDropdownState extends State<DisposisiDropdown> {
  late List<String> selectedDisposisi;

  @override
  void initState() {
    super.initState();
    selectedDisposisi = List.from(widget.initialValues); // buat edit / tambah
  }

  void _showMultiSelectDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text("Pilih Disposisi", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              children: widget.workFields.entries.map((entry) {
                final isSelected = selectedDisposisi.contains(entry.value);
                return CheckboxListTile(
                  value: isSelected,
                  activeColor: Colors.deepPurple,
                  checkColor: Colors.white,
                  title: Text(entry.key, style: TextStyle(color: Colors.white)),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedDisposisi.add(entry.value);
                      } else {
                        selectedDisposisi.remove(entry.value);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Batal", style: TextStyle(color: Colors.redAccent)),
              onPressed: () => Navigator.pop(ctx, null),
            ),
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.greenAccent)),
              onPressed: () => Navigator.pop(ctx, selectedDisposisi),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() => selectedDisposisi = result);
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Disposisi',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kalau ada pilihan, tampilkan chip
              if (selectedDisposisi.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedDisposisi.map((disp) {
                    String displayName = widget.workFields.entries
                        .firstWhere(
                          (entry) => entry.value == disp || entry.key == disp,
                          orElse: () => MapEntry(disp, disp),
                        )
                        .key;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF4F46E5).withValues(alpha: 0.3),
                            Color(0xFF7C3AED).withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDisposisi.remove(disp);
                                widget.onChanged(selectedDisposisi);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),
              ],

              // Tombol buka dialog
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showMultiSelectDialog,
                icon: Icon(Icons.assignment_turned_in_rounded),
                label: Text("Pilih Disposisi"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
