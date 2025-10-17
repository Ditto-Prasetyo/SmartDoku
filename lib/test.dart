import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiDisposisiForm extends StatefulWidget {
  const MultiDisposisiForm({super.key});

  @override
  State<MultiDisposisiForm> createState() => _MultiDisposisiFormState();
}

class _MultiDisposisiFormState extends State<MultiDisposisiForm> {
  final Map<String, String> workFields = {
    'Penataan Ruang dan PB': 'PRPB',
    'Perumahan': 'Perumahan',
    'Permukiman': 'Permukiman',
    'Sekretariat': 'Sekretariat',
    'UPT Pengelolaan Air Limbah Domestik': 'UPT_PALD',
    'UPT Pertamanan': 'UPT_Taman',
  };

  // untuk nyimpen key yang dipilih user
  final List<String> selectedKeys = [];

  // fungsi buat format ke API
  List<Map<String, String>> getDisposisiForAPI() {
    return selectedKeys.map((key) {
      return {"tujuan": workFields[key]!};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Disposisi")),
      body: ListView(
        children: workFields.keys.map((key) {
          return CheckboxListTile(
            title: Text(key),
            value: selectedKeys.contains(key),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedKeys.add(key);
                } else {
                  selectedKeys.remove(key);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final disposisiData = getDisposisiForAPI();
          print(disposisiData);
          // contoh hasil:
          // [
          //   {"tujuan": "PRPB"},
          //   {"tujuan": "UPT_Taman"}
          // ]
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}


class MultiSelectDropdownExample extends StatefulWidget {
  const MultiSelectDropdownExample({super.key});

  @override
  State<MultiSelectDropdownExample> createState() => _MultiSelectDropdownExampleState();
}

class _MultiSelectDropdownExampleState extends State<MultiSelectDropdownExample> {
  final Map<String, String> workFields = {
    'Penataan Ruang dan PB': 'PRPB',
    'Perumahan': 'Perumahan',
    'Permukiman': 'Permukiman',
    'Sekretariat': 'Sekretariat',
    'UPT Pengelolaan Air Limbah Domestik': 'UPT_PALD',
    'UPT Pertamanan': 'UPT_Taman',
  };

  List<String> selectedKeys = [];

  @override
  Widget build(BuildContext context) {
    final items = workFields.keys.map((key) => MultiSelectItem<String>(key, key)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Disposisi")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MultiSelectDialogField<String>(
              items: items,
              title: const Text("Pilih Disposisi"),
              buttonText: const Text("Pilih Tujuan"),
              searchable: true,
              listType: MultiSelectListType.LIST,
              onConfirm: (values) {
                setState(() {
                  selectedKeys = values;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final disposisiData = selectedKeys.map((key) {
                  return {"tujuan": workFields[key]!};
                }).toList();

                print(disposisiData);
                // [
                //   {"tujuan": "PRPB"},
                //   {"tujuan": "UPT_Taman"}
                // ]
              },
              child: const Text("Kirim"),
            ),
          ],
        ),
      ),
    );
  }
}