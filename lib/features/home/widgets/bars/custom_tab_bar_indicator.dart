import 'package:flutter/material.dart';

class CustomTabBarIndicator extends Decoration {
  final Color color;

  const CustomTabBarIndicator({required this.color});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabBarPainter(color, onChanged);
  }
}

class _CustomTabBarPainter extends BoxPainter {
  final Color color;

  _CustomTabBarPainter(this.color, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()..color = color..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(
      offset.dx,
      configuration.size!.height - 5,
      configuration.size!.width,
      3,
    );

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(2)), paint);
  }
}
