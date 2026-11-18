import 'package:flutter/material.dart';
import '../core/theme/witcher_colors.dart';

class WitcherMedallion extends StatelessWidget {
  final double size;
  final Color? color;
  final bool glowing;

  const WitcherMedallion({
    super.key,
    this.size = 40,
    this.color,
    this.glowing = true,
  });

  @override
  Widget build(BuildContext context) {
    final medallionColor = color ?? WitcherColors.gold;

    return Container(
      width: size,
      height: size,
      decoration: glowing
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: medallionColor.withValues(alpha: 0.35),
                  blurRadius: size * 0.4,
                  spreadRadius: size * 0.05,
                ),
              ],
            )
          : null,
      child: CustomPaint(
        size: Size(size, size),
        painter: _WitcherWolfPainter(color: medallionColor),
      ),
    );
  }
}

class _WitcherWolfPainter extends CustomPainter {
  final Color color;

  _WitcherWolfPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = w * 0.04
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = WitcherColors.goldBright
      ..style = PaintingStyle.fill;

    // Outer silhouette of Wolf Head
    final outerPath = Path();
    outerPath.moveTo(w * 0.50, h * 0.05); // top crest
    outerPath.lineTo(w * 0.65, h * 0.28); // right ear peak
    outerPath.lineTo(w * 0.85, h * 0.25); // right outer spike
    outerPath.lineTo(w * 0.74, h * 0.48); // right cheekbone
    outerPath.lineTo(w * 0.90, h * 0.64); // right jaw flare
    outerPath.lineTo(w * 0.68, h * 0.75); // right chin upper
    outerPath.lineTo(w * 0.50, h * 0.95); // muzzle tip
    outerPath.lineTo(w * 0.32, h * 0.75); // left chin upper
    outerPath.lineTo(w * 0.10, h * 0.64); // left jaw flare
    outerPath.lineTo(w * 0.26, h * 0.48); // left cheekbone
    outerPath.lineTo(w * 0.15, h * 0.25); // left outer spike
    outerPath.lineTo(w * 0.35, h * 0.28); // left ear peak
    outerPath.close();

    canvas.drawPath(outerPath, fillPaint);
    canvas.drawPath(outerPath, strokePaint);

    // Inner facial planes (angular snout and brow)
    final innerPath = Path();
    innerPath.moveTo(w * 0.50, h * 0.22);
    innerPath.lineTo(w * 0.60, h * 0.38);
    innerPath.lineTo(w * 0.72, h * 0.46);
    innerPath.lineTo(w * 0.62, h * 0.60);
    innerPath.lineTo(w * 0.50, h * 0.78);
    innerPath.lineTo(w * 0.38, h * 0.60);
    innerPath.lineTo(w * 0.28, h * 0.46);
    innerPath.lineTo(w * 0.40, h * 0.38);
    innerPath.close();

    final innerStroke = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = w * 0.03
      ..style = PaintingStyle.stroke;
    canvas.drawPath(innerPath, innerStroke);

    // Angular Glowing Eyes
    final leftEye = Path();
    leftEye.moveTo(w * 0.38, h * 0.46);
    leftEye.lineTo(w * 0.45, h * 0.47);
    leftEye.lineTo(w * 0.40, h * 0.52);
    leftEye.close();
    canvas.drawPath(leftEye, accentPaint);

    final rightEye = Path();
    rightEye.moveTo(w * 0.62, h * 0.46);
    rightEye.lineTo(w * 0.55, h * 0.47);
    rightEye.lineTo(w * 0.60, h * 0.52);
    rightEye.close();
    canvas.drawPath(rightEye, accentPaint);

    // Central Nose Rune
    final noseRune = Path();
    noseRune.moveTo(w * 0.50, h * 0.56);
    noseRune.lineTo(w * 0.46, h * 0.68);
    noseRune.lineTo(w * 0.54, h * 0.68);
    noseRune.close();
    canvas.drawPath(noseRune, accentPaint);
  }

  @override
  bool shouldRepaint(covariant _WitcherWolfPainter oldDelegate) =>
      oldDelegate.color != color;
}
