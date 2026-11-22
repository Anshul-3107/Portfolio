import 'package:flutter/material.dart';

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
    final medallionColor = widget.color ?? const Color(0xFFC59B3C);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final glowFactor = widget.glowing ? _pulseAnimation.value : 0.0;
        final auraRadius = widget.size * (0.35 + glowFactor * 0.18);
        final eyeColor = Color.lerp(
          const Color(0xFFE5251A),
          const Color(0xFFFF4D4D),
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
                      color: const Color(0xFFFF2211).withValues(alpha: 0.16 + glowFactor * 0.20),
                      blurRadius: auraRadius,
                      spreadRadius: widget.size * 0.02,
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
    this.eyeColor = const Color(0xFFE5251A),
    this.glowIntensity = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Subtle drop shadow behind the metal wolf head
    final shadowPaint = Paint()
      ..color = const Color(0x66000000)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.06);

    // 2. Solid dark antique steel/iron body fill
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          Color(0xFF2E2117), // Dark forged iron
          Color(0xFF1E140D), // Shadowed steel
          Color(0xFF150D07), // Deep abyss
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    // 3. Crisp metallic edge stroke (Dark bronze & antique gold)
    final strokePaint = Paint()
      ..color = color // Rich antique gold
      ..strokeWidth = w * 0.045
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final outerTrimStroke = Paint()
      ..color = const Color(0xFF382310) // Dark walnut contour base
      ..strokeWidth = w * 0.075
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

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

    // Draw shadow first
    canvas.drawPath(outerPath, shadowPaint);

    // Draw outer dark contour trim (ensures crisp separation from parchment)
    canvas.drawPath(outerPath, outerTrimStroke);

    // Draw solid metal body
    canvas.drawPath(outerPath, bodyPaint);

    // Draw crisp gold border
    canvas.drawPath(outerPath, strokePaint);

    // 4. Inner facial facets (sculpted 3D angular snout and brow planes)
    final leftCheekFacet = Path();
    leftCheekFacet.moveTo(w * 0.35, h * 0.28);
    leftCheekFacet.lineTo(w * 0.40, h * 0.38);
    leftCheekFacet.lineTo(w * 0.28, h * 0.46);
    leftCheekFacet.lineTo(w * 0.26, h * 0.48);
    leftCheekFacet.close();

    final rightCheekFacet = Path();
    rightCheekFacet.moveTo(w * 0.65, h * 0.28);
    rightCheekFacet.lineTo(w * 0.60, h * 0.38);
    rightCheekFacet.lineTo(w * 0.72, h * 0.46);
    rightCheekFacet.lineTo(w * 0.74, h * 0.48);
    rightCheekFacet.close();

    final facetPaint = Paint()
      ..color = const Color(0xFF3D2C1E)
      ..style = PaintingStyle.fill;
    canvas.drawPath(leftCheekFacet, facetPaint);
    canvas.drawPath(rightCheekFacet, facetPaint);

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

    final innerFill = Paint()
      ..color = const Color(0xFF261A11)
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerPath, innerFill);

    final innerStroke = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..strokeWidth = w * 0.028
      ..style = PaintingStyle.stroke;
    canvas.drawPath(innerPath, innerStroke);

    // 5. Angular Glowing Eyes (Fierce Witcher Wolf Ruby Gaze)
    final leftEye = Path();
    leftEye.moveTo(w * 0.38, h * 0.45);
    leftEye.lineTo(w * 0.46, h * 0.46);
    leftEye.lineTo(w * 0.40, h * 0.52);
    leftEye.close();

    final rightEye = Path();
    rightEye.moveTo(w * 0.62, h * 0.45);
    rightEye.lineTo(w * 0.54, h * 0.46);
    rightEye.lineTo(w * 0.60, h * 0.52);
    rightEye.close();

    // Eye glow halo if pulsating
    if (glowIntensity > 0) {
      final glowPaint = Paint()
        ..color = const Color(0xFFFF2211).withValues(alpha: 0.5 + glowIntensity * 0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.10);
      canvas.drawPath(leftEye, glowPaint);
      canvas.drawPath(rightEye, glowPaint);
    }

    final eyePaint = Paint()
      ..color = eyeColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(leftEye, eyePaint);
    canvas.drawPath(rightEye, eyePaint);

    // 6. Central Nose Rune & Snout Fangs
    final noseRune = Path();
    noseRune.moveTo(w * 0.50, h * 0.54);
    noseRune.lineTo(w * 0.45, h * 0.67);
    noseRune.lineTo(w * 0.55, h * 0.67);
    noseRune.close();

    final accentPaint = Paint()
      ..color = const Color(0xFFE5B869)
      ..style = PaintingStyle.fill;
    canvas.drawPath(noseRune, accentPaint);

    // Menacing fangs at the muzzle
    final leftFang = Path();
    leftFang.moveTo(w * 0.45, h * 0.72);
    leftFang.lineTo(w * 0.48, h * 0.72);
    leftFang.lineTo(w * 0.465, h * 0.82);
    leftFang.close();

    final rightFang = Path();
    rightFang.moveTo(w * 0.52, h * 0.72);
    rightFang.lineTo(w * 0.55, h * 0.72);
    rightFang.lineTo(w * 0.535, h * 0.82);
    rightFang.close();

    final fangPaint = Paint()
      ..color = const Color(0xFFE8DAC2) // Ivory fangs
      ..style = PaintingStyle.fill;
    canvas.drawPath(leftFang, fangPaint);
    canvas.drawPath(rightFang, fangPaint);
  }

  @override
  bool shouldRepaint(covariant _WitcherWolfPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.eyeColor != eyeColor ||
      oldDelegate.glowIntensity != glowIntensity;
}
