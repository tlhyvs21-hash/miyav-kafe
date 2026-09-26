import 'package:flutter/material.dart';
import '../models/cat.dart';

/// Sevimli, tamamen kodla çizilmiş vektörel bir kedi ikonu. Her kedi kendi
/// rengiyle ve küçük bir görsel özellikle (çizgili desen, göğüs lekesi,
/// patili leke, taç) çiziliyor, böylece koleksiyon tek tip görünmüyor.
/// Dışarıdan görsel/asset gerektirmez.
class CatIllustration extends StatelessWidget {
  final Color color;
  final double size;
  final bool locked;
  final CatFeature feature;

  const CatIllustration({
    super.key,
    this.color = const Color(0xFFFFA726),
    this.size = 64,
    this.locked = false,
    this.feature = CatFeature.none,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: locked ? 0.35 : 1,
      child: CustomPaint(
        size: Size(size, size),
        painter: _CatPainter(
          color: locked ? Colors.grey : color,
          feature: locked ? CatFeature.none : feature,
        ),
      ),
    );
  }
}

class _CatPainter extends CustomPainter {
  final Color color;
  final CatFeature feature;
  _CatPainter({required this.color, required this.feature});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;
    final headCenter = Offset(w / 2, h * 0.56);

    // Hafif gölge (derinlik hissi için)
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.08);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2, h * 0.92), width: w * 0.5, height: h * 0.08),
      shadowPaint,
    );

    // Kafa
    canvas.drawCircle(headCenter, w * 0.36, paint);

    // Kulaklar
    final leftEar = Path()
      ..moveTo(w * 0.20, h * 0.36)
      ..lineTo(w * 0.30, h * 0.04)
      ..lineTo(w * 0.42, h * 0.34)
      ..close();
    final rightEar = Path()
      ..moveTo(w * 0.80, h * 0.36)
      ..lineTo(w * 0.70, h * 0.04)
      ..lineTo(w * 0.58, h * 0.34)
      ..close();
    canvas.drawPath(leftEar, paint);
    canvas.drawPath(rightEar, paint);

    // Kulak içi (kontrast rengi)
    final innerEarColor = Paint()..color = Colors.pink.shade100.withOpacity(0.9);
    final leftInner = Path()
      ..moveTo(w * 0.26, h * 0.28)
      ..lineTo(w * 0.31, h * 0.13)
      ..lineTo(w * 0.37, h * 0.28)
      ..close();
    final rightInner = Path()
      ..moveTo(w * 0.74, h * 0.28)
      ..lineTo(w * 0.69, h * 0.13)
      ..lineTo(w * 0.63, h * 0.28)
      ..close();
    canvas.drawPath(leftInner, innerEarColor);
    canvas.drawPath(rightInner, innerEarColor);

    // Desen (özelliğe göre) — kafa çizildikten, göz/burun çizilmeden önce
    _drawFeature(canvas, w, h, headCenter);

    // Gözler
    final eyePaint = Paint()..color = Colors.black87;
    canvas.drawCircle(Offset(w * 0.40, h * 0.53), w * 0.035, eyePaint);
    canvas.drawCircle(Offset(w * 0.60, h * 0.53), w * 0.035, eyePaint);
    // Göz parıltısı
    final glintPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.408, h * 0.522), w * 0.010, glintPaint);
    canvas.drawCircle(Offset(w * 0.608, h * 0.522), w * 0.010, glintPaint);

    // Burun
    final nosePaint = Paint()..color = Colors.pink.shade200;
    final nose = Path()
      ..moveTo(w * 0.485, h * 0.605)
      ..lineTo(w * 0.515, h * 0.605)
      ..lineTo(w / 2, h * 0.625)
      ..close();
    canvas.drawPath(nose, nosePaint);

    // Ağız
    final mouthPaint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final mouth = Path()
      ..moveTo(w / 2, h * 0.625)
      ..quadraticBezierTo(w * 0.46, h * 0.66, w * 0.43, h * 0.63)
      ..moveTo(w / 2, h * 0.625)
      ..quadraticBezierTo(w * 0.54, h * 0.66, w * 0.57, h * 0.63);
    canvas.drawPath(mouth, mouthPaint);

    // Bıyıklar
    final whiskerPaint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1.2;
    for (final dy in [-0.02, 0.0, 0.02]) {
      canvas.drawLine(
        Offset(w * 0.14, h * (0.61 + dy)),
        Offset(w * 0.34, h * (0.59 + dy)),
        whiskerPaint,
      );
      canvas.drawLine(
        Offset(w * 0.86, h * (0.61 + dy)),
        Offset(w * 0.66, h * (0.59 + dy)),
        whiskerPaint,
      );
    }
  }

  void _drawFeature(Canvas canvas, double w, double h, Offset headCenter) {
    switch (feature) {
      case CatFeature.stripes:
        final stripePaint = Paint()
          ..color = Colors.black.withOpacity(0.22)
          ..strokeWidth = w * 0.03
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(w * 0.38, h * 0.24), Offset(w * 0.34, h * 0.36), stripePaint);
        canvas.drawLine(Offset(w * 0.50, h * 0.20), Offset(w * 0.50, h * 0.34), stripePaint);
        canvas.drawLine(Offset(w * 0.62, h * 0.24), Offset(w * 0.66, h * 0.36), stripePaint);
        break;
      case CatFeature.chestPatch:
        final patchPaint = Paint()..color = Colors.white.withOpacity(0.9);
        canvas.drawOval(
          Rect.fromCenter(center: Offset(w / 2, h * 0.72), width: w * 0.22, height: h * 0.16),
          patchPaint,
        );
        break;
      case CatFeature.pawMark:
        final markPaint = Paint()..color = Colors.pink.shade200.withOpacity(0.8);
        canvas.drawCircle(Offset(w * 0.72, h * 0.46), w * 0.045, markPaint);
        canvas.drawCircle(Offset(w * 0.66, h * 0.40), w * 0.022, markPaint);
        canvas.drawCircle(Offset(w * 0.76, h * 0.38), w * 0.022, markPaint);
        break;
      case CatFeature.crown:
        final crownPaint = Paint()..color = const Color(0xFFFFD54F);
        final crown = Path()
          ..moveTo(w * 0.38, h * 0.04)
          ..lineTo(w * 0.44, h * -0.03)
          ..lineTo(w * 0.50, h * 0.02)
          ..lineTo(w * 0.56, h * -0.03)
          ..lineTo(w * 0.62, h * 0.04)
          ..close();
        canvas.drawPath(crown, crownPaint);
        break;
      case CatFeature.none:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _CatPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.feature != feature;
}
