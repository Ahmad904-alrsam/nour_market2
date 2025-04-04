
import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.teal.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final Path topPath = Path();
    topPath.moveTo(0, 0);
    topPath.lineTo(0, size.height * 0.25);
    topPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.35,
      size.width,
      size.height * 0.25,
    );
    topPath.lineTo(size.width, 0);
    topPath.close();

    final Path bottomPath = Path();
    bottomPath.moveTo(0, size.height);
    bottomPath.lineTo(0, size.height * 0.83);
    bottomPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.73,
      size.width,
      size.height * 0.83,
    );
    bottomPath.lineTo(size.width, size.height);
    bottomPath.close();

    canvas.drawPath(topPath, paint);
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}