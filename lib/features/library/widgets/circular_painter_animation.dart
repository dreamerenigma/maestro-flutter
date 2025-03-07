import 'dart:math';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/constants/app_colors.dart';

class CircularFillPainter extends CustomPainter {
  final double progress;

  CircularFillPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint fillPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    // Draw the outline circle
    canvas.drawCircle(center, radius, paint);

    // Number of segments (risk)
    int segments = 12;
    double segmentAngle = (2 * pi) / segments;

    // Draw each segment
    for (int i = 0; i < segments; i++) {
      double startAngle = segmentAngle * i - pi / 2;
      double endAngle = startAngle + segmentAngle * min(progress, 1.0);

      Path path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          endAngle - startAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, fillPaint);
    }

    // Draw the icon in the center
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Remix.loader_2_fill.codePoint),
        style: TextStyle(
          fontSize: size.width * 0.4,
          fontFamily: Remix.loader_2_fill.fontFamily,
          color: AppColors.blue,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}