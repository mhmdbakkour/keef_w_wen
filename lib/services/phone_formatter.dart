import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted = '';
    if (digits.length >= 2) {
      formatted += digits.substring(0, 2);
      if (digits.length > 2) {
        formatted += ' ' + digits.substring(2, digits.length.clamp(3, 5));
        if (digits.length > 5) {
          formatted += ' ' + digits.substring(5, digits.length.clamp(6, 8));
        }
      }
    } else {
      formatted = digits;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
