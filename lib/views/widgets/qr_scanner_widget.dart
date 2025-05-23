import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerWidget extends StatelessWidget {
  final Function(String) onDetect;

  const QRScannerWidget({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: MobileScanner(
        fit: BoxFit.cover,
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          if (barcode.rawValue != null) {
            onDetect(barcode.rawValue!);
          }
        },
      ),
    );
  }
}
