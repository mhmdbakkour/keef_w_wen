import 'package:flutter/material.dart';

class MiniTagWidget extends StatelessWidget {
  final String label;
  final bool selected;

  const MiniTagWidget({required this.label, required this.selected, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.surface,
          ),
          textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ),
    );
  }
}
