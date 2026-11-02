import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RectPainter extends CustomPainter {
  final double width;
  final double height;
  final Color color;

  const RectPainter({
    this.width = 12,
    this.height = 12,
    this.color = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    canvas.drawRect(
      Rect.fromLTRB(0, 0, width, height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
