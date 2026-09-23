import 'package:flutter/material.dart';

/// Basit, sevimli, tamamen kodla çizilmiş vektörel bir kedi ikonu.
/// Dışarıdan görsel/asset gerektirmez — profesyonel bir grafiker olmadan
/// çizgi film tarzı bir görünüm sağlamanın en pratik yolu budur.
class CatIllustration extends StatelessWidget {
  final Color color;
  final double size;
  final bool locked;

  const CatIllustration({
    super.key,
    this.color = const Color(0xFFFFA726),
    this.size = 64,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: locked ? 0.35 : 1,
      child: CustomPaint(
        size: Size(size, size),
        painter: _CatPainter(color: locked ? Colors.grey : color),
      ),
    );
  }
}

class _CatPainter extends CustomPainter {
  final Color color;
  _CatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;

    canvas.drawCircle(Offset(w / 2, h * 0.55), w * 0.35, paint);

    final leftEar = Path()
      ..moveTo(w * 0.22, h * 0.35)
      ..lineTo(w * 0.32, h * 0.05)
      ..lineTo(w * 0.42, h * 0.35)
      ..close();
    final rightEar = Path()
      ..moveTo(w * 0.78, h * 0.35)
      ..lineTo(w * 0.68, h * 0.05)
      ..lineTo(w * 0.58, h * 0.35)
      ..close();
    canvas.drawPath(leftEar, paint);
    canvas.drawPath(rightEar, paint);

    final eyePaint = Paint()..color = Colors.black87;
    canvas.drawCircle(Offset(w * 0.40, h * 0.52), w * 0.035, eyePaint);
    canvas.drawCircle(Offset(w * 0.60, h * 0.52), w * 0.035, eyePaint);

    final nosePaint = Paint()..color = Colors.pink.shade200;
    canvas.drawCircle(Offset(w / 2, h * 0.60), w * 0.03, nosePaint);

    final whiskerPaint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 1.2;
    for (final dy in [-0.02, 0.0, 0.02]) {
      canvas.drawLine(
        Offset(w * 0.15, h * (0.62 + dy)),
        Offset(w * 0.35, h * (0.60 + dy)),
        whiskerPaint,
      );
      canvas.drawLine(
        Offset(w * 0.85, h * (0.62 + dy)),
        Offset(w * 0.65, h * (0.60 + dy)),
        whiskerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CatPainter oldDelegate) => oldDelegate.color != color;
}
