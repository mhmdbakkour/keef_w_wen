import 'package:flutter/material.dart';

class FormTextWidget extends StatelessWidget {
  const FormTextWidget({
    super.key,
    required this.title,
    required this.icon,
    this.controller,
  });

  final String title;
  final Icon icon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: title,
          floatingLabelAlignment: FloatingLabelAlignment.center,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
