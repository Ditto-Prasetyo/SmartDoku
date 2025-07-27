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