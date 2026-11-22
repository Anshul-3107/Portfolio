import 'package:flutter/material.dart';
import '../core/theme/witcher_colors.dart';

class WitcherMedallion extends StatefulWidget {
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
  State<WitcherMedallion> createState() => _WitcherMedallionState();
}

class _WitcherMedallionState extends State<WitcherMedallion>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    );
    if (widget.glowing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant WitcherMedallion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.glowing && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.glowing && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medallionColor = widget.color ?? WitcherColors.gold;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final glowFactor = widget.glowing ? _pulseAnimation.value : 0.0;
        final auraRadius = widget.size * (0.35 + glowFactor * 0.18);
        final eyeColor = Color.lerp(
          WitcherColors.goldBright,
          WitcherColors.crimsonBright,
          glowFactor,
        )!;

        return Container(
          width: widget.size,
          height: widget.size,
          decoration: widget.glowing
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: medallionColor.withValues(alpha: 0.22 + glowFactor * 0.22),
                      blurRadius: auraRadius,
                      spreadRadius: widget.size * 0.04,
                    ),
                  ],
                )
              : null,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _WitcherWolfPainter(
              color: medallionColor,
              eyeColor: eyeColor,
              glowIntensity: glowFactor,
            ),
          ),
        );
      },
    );
  }
}

class _WitcherWolfPainter extends CustomPainter {
  final Color color;
  final Color eyeColor;
  final double glowIntensity;

  _WitcherWolfPainter({
    required this.color,
    this.eyeColor = WitcherColors.goldBright,
    this.glowIntensity = 0.0,
  });

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

    final eyePaint = Paint()
      ..color = eyeColor
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

    final rightEye = Path();
    rightEye.moveTo(w * 0.62, h * 0.46);
    rightEye.lineTo(w * 0.55, h * 0.47);
    rightEye.lineTo(w * 0.60, h * 0.52);
    rightEye.close();

    // Eye glow halo if pulsating
    if (glowIntensity > 0) {
      final glowPaint = Paint()
        ..color = eyeColor.withValues(alpha: 0.4 + glowIntensity * 0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.08);
      canvas.drawPath(leftEye, glowPaint);
      canvas.drawPath(rightEye, glowPaint);
    }

    canvas.drawPath(leftEye, eyePaint);
    canvas.drawPath(rightEye, eyePaint);

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
      oldDelegate.color != color ||
      oldDelegate.eyeColor != eyeColor ||
      oldDelegate.glowIntensity != glowIntensity;
}
