import 'package:flutter/material.dart';
import '../../../utils/constants/app_colors.dart';

class CircularFillAnimation extends StatefulWidget {
  const CircularFillAnimation({super.key});

  @override
  CircularFillAnimationState createState() => CircularFillAnimationState();
}

class CircularFillAnimationState extends State<CircularFillAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: CircularFillPainter(_animation.value),
          size: const Size(20, 20),
        );
      },
    );
  }
}

class CircularFillPainter extends CustomPainter {
  final double progress;

  CircularFillPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, paint..color = AppColors.grey.withAlpha((0.3 * 255).toInt()));

    paint.color = AppColors.primary;
    final sweepAngle = 2 * 3.1416 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1416 / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(const MaterialApp(home: Scaffold(body: Center(child: CircularFillAnimation()))));
}
