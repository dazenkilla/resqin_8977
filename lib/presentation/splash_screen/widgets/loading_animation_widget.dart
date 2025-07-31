import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoadingAnimationWidget extends StatelessWidget {
  final AnimationController loadingController;

  const LoadingAnimationWidget({
    Key? key,
    required this.loadingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8.w,
      height: 8.w,
      child: AnimatedBuilder(
        animation: loadingController,
        builder: (context, child) {
          return CustomPaint(
            painter: _HeartbeatLoadingPainter(
              progress: loadingController.value,
            ),
          );
        },
      ),
    );
  }
}

class _HeartbeatLoadingPainter extends CustomPainter {
  final double progress;

  _HeartbeatLoadingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Medical cross animation
    final crossSize = radius * (0.8 + 0.2 * progress);

    // Vertical line of cross
    canvas.drawLine(
      Offset(center.dx, center.dy - crossSize),
      Offset(center.dx, center.dy + crossSize),
      paint,
    );

    // Horizontal line of cross
    canvas.drawLine(
      Offset(center.dx - crossSize, center.dy),
      Offset(center.dx + crossSize, center.dy),
      paint,
    );

    // Pulsing circle
    final circleRadius = radius * (1.0 + 0.1 * progress);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;
    paint.color = Colors.white.withAlpha(153);

    canvas.drawCircle(center, circleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
