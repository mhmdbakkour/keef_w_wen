import 'package:flutter/material.dart';

class FormTextWidget extends StatelessWidget {
  const FormTextWidget({
    super.key,
    required this.title,
    required this.icon,
    this.hidden,
    this.focusNode,
    this.controller,
    this.onEditingComplete,
    this.onSubmitted,
    this.errorText,
  });

  final String title;
  final Icon icon;
  final TextEditingController? controller;
  final bool? hidden;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final Function(String)? onSubmitted;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 8),
      child: TextField(
        focusNode: focusNode,
        obscureText: hidden ?? false,
        obscuringCharacter: '•',
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: title,
          floatingLabelAlignment: FloatingLabelAlignment.center,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
