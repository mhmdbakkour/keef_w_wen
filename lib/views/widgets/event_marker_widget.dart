import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui' as ui;

class EventMarker extends Marker {
  EventMarker({
    required LatLng coordinates,
    required VoidCallback onTap,
    required String title,
    required String thumbnail,
    required Color color,
    Color? iconErrorColor,
    Color? errorColor,
  }) : super(
         point: coordinates,
         rotate: true,
         alignment: Alignment.topCenter,
         width: 100,
         height: 95,
         child: GestureDetector(
           onTap: onTap,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               // Title text
               Container(
                 constraints: BoxConstraints(minHeight: 30, minWidth: 100),
                 padding: const EdgeInsets.symmetric(
                   horizontal: 6,
                   vertical: 2,
                 ),
                 decoration: BoxDecoration(
                   color: color,
                   borderRadius: BorderRadius.circular(6),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black26,
                       blurRadius: 4,
                       offset: Offset(0, 2),
                     ),
                   ],
                 ),
                 child: Center(
                   child: Text(
                     title,
                     style: const TextStyle(
                       fontSize: 10,
                       fontWeight: FontWeight.w600,
                       color: Colors.white,
                     ),
                     maxLines: 2,
                     textAlign: TextAlign.center,
                     overflow: TextOverflow.ellipsis,
                   ),
                 ),
               ),
               Stack(
                 alignment: Alignment.center,
                 children: [
                   CustomPaint(
                     size: const Size(50, 60),
                     painter: PinPainter(color: color),
                   ),
                   Positioned(
                     top: 6,
                     child: CircleAvatar(
                       radius: 20,
                       backgroundImage:
                           thumbnail.isNotEmpty
                               ? NetworkImage(thumbnail)
                               : null,
                       backgroundColor:
                           thumbnail.isNotEmpty
                               ? color
                               : errorColor ?? Colors.white,
                       child:
                           thumbnail.isNotEmpty
                               ? null
                               : Icon(
                                 Icons.broken_image,
                                 color: iconErrorColor ?? Colors.red,
                               ),
                     ),
                   ),
                 ],
               ),
             ],
           ),
         ),
       );
}

class PinPainter extends CustomPainter {
  final Color color;

  PinPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = ui.Path();

    path.moveTo(size.width / 2, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height * 0.6,
      size.width / 2,
      size.height * 0.2,
    );
    path.quadraticBezierTo(0, size.height * 0.6, size.width / 2, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
