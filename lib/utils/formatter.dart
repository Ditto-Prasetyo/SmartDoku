import 'package:flutter/services.dart';

class DigitOnlyWithErrorFormatter extends TextInputFormatter {
  final Function(String) onInvalidInput;

  DigitOnlyWithErrorFormatter({required this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = RegExp(r'^\d*$');
    if (!digitsOnly.hasMatch(newValue.text)) {
      onInvalidInput("Nomor HP hanya boleh berisi angka!");
      return oldValue;
    }
    return newValue;
  }
}

class NoDigitsFormatter extends TextInputFormatter {
  final Function(String) onInvalidInput;

  NoDigitsFormatter({required this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final containsDigits = RegExp(r'\d');

    if (containsDigits.hasMatch(newValue.text)) {
      onInvalidInput("Nama tidak boleh mengandung angka!");
      return oldValue;
    }

    return newValue;
  }
}

class NormalAddressFormatter extends TextInputFormatter {
  final Function(String) onInvalidInput;

  NormalAddressFormatter({required this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final allowedRegex = RegExp(r'^[a-zA-Z0-9\s.,\-\/]*$');

    if (!allowedRegex.hasMatch(newValue.text)) {
      onInvalidInput(
        "Alamat hanya boleh mengandung huruf, angka, spasi, dan tanda baca umum (, . - /)",
      );
      return oldValue;
    }

    return newValue;
  }
}

class NormalUsernameFormatter extends TextInputFormatter {
  final Function(String) onInvalidInput;

  NormalUsernameFormatter({required this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final allowedRegex = RegExp(r'^[a-zA-Z0-9\s.,\-\/]*$');

    if (!allowedRegex.hasMatch(newValue.text)) {
      onInvalidInput(
        "Username hanya boleh mengandung huruf, angka, spasi, dan tanda baca umum (, . - /)",
      );
      return oldValue;
    }

    return newValue;
  }
}

class NormalEmailFormatter extends TextInputFormatter {
  final Function(String) onInvalidInput;

  NormalEmailFormatter({required this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final allowedRegex = RegExp(r'^[a-zA-Z0-9\s.,@\-\/]*$');

    if (!allowedRegex.hasMatch(newValue.text)) {
      onInvalidInput(
        "Email hanya boleh mengandung huruf, angka, spasi, dan tanda baca umum (, . - / @)",
      );
      return oldValue;
    }

    return newValue;
  }
}

class FullNameFormatter extends TextInputFormatter {
  final void Function(String message)? onInvalidInput;
  bool _hasShownDialog = false;

  FullNameFormatter({this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;

    // Regex: hanya huruf dan spasi
    final isValid = RegExp(r'^[a-zA-Z\s]*$').hasMatch(newText);

    if (!isValid && !_hasShownDialog) {
      _hasShownDialog = true;

      // Delay biar dialog muncul setelah TextField selesai proses
      Future.microtask(() {
        onInvalidInput?.call(
          'Nama hanya boleh berisi huruf dan spasi!',
        );
        _hasShownDialog = false; // Biar bisa muncul lagi nanti kalo diulangin
      });

      return oldValue; // Balikin value lama biar input ditolak
    }

    return newValue; // Valid → input jalan
  }
}