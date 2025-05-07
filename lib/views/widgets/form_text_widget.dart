import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextWidget extends StatelessWidget {
  const FormTextWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.fieldKey,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.maxLines,
    this.validator,
    this.onEditingComplete,
    this.focusNode,
    this.focusNodeNext,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final GlobalKey? fieldKey;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final String? Function(String?)? validator;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final FocusNode? focusNodeNext;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        key: fieldKey,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        keyboardType: keyboardType,
        buildCounter:
            (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) => null,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          floatingLabelAlignment: FloatingLabelAlignment.center,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        ),
        inputFormatters: inputFormatters,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(focusNodeNext);
        },
        onEditingComplete: onEditingComplete,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
