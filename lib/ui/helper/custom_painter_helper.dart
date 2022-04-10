
import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {

  final bool top;
  final bool left;
  final bool right;

  final Color color;

  TrianglePainter({
    this.top = true,
    this.left = true,
    this.right = true,
    this.color = const Color(0xFF3C3B67),
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill //填充
      ..color = color;

    var topPoint = Offset(size.width / 2, 0);
    var leftPoint = Offset(0, size.height);
    var rightPoint = Offset(size.width, size.height);

    if (!top) {
      topPoint = Offset(size.width / 2, size.height / 4);
    }

    if (!left) {
      topPoint = Offset(size.width / 4, size.height / 4 * 3);
    }

    if (!right) {
      topPoint = Offset(size.width / 4 * 3, size.height / 4 * 3);
    }

    var path = Path();
    path.moveTo(topPoint.dx, topPoint.dy);
    path.lineTo(leftPoint.dx, leftPoint.dy);
    path.lineTo(rightPoint.dx, rightPoint.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}