import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/audio/witcher_audio.dart';
import '../../core/theme/witcher_colors.dart';

class WitcherWaxSeal extends StatefulWidget {
  final double size;
  final String? symbol;
  final IconData? icon;
  final String? label;
  final VoidCallback? onTap;
  final String? tooltip;

  const WitcherWaxSeal({
    super.key,
    this.size = 52,
    this.symbol = '🐺',
    this.icon,
    this.label,
    this.onTap,
    this.tooltip,
  });

  @override
  State<WitcherWaxSeal> createState() => _WitcherWaxSealState();
}

class _WitcherWaxSealState extends State<WitcherWaxSeal>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTap() {
    WitcherAudio.seal();
    _pressController.reverse().then((_) => _pressController.forward());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    Widget seal = MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _isHovered = true);
        WitcherAudio.hover();
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap != null ? _handleTap : null,
        child: ScaleTransition(
          scale: _pressController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _WaxSealPainter(isHovered: _isHovered),
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: Center(
                    child: widget.icon != null
                        ? Icon(
                            widget.icon,
                            size: widget.size * 0.44,
                            color: const Color(0xFFF7D5C5),
                            shadows: const [
                              Shadow(
                                color: Color(0xFF4A0804),
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          )
                        : Text(
                            widget.symbol ?? '🐺',
                            style: TextStyle(
                              fontSize: widget.size * 0.42,
                              color: const Color(0xFFF7D5C5),
                              shadows: const [
                                Shadow(
                                  color: Color(0xFF4A0804),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              if (widget.label != null) ...[
                const SizedBox(height: 6),
                Text(
                  widget.label!.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: _isHovered
                        ? WitcherColors.inkCrimsonBright
                        : WitcherColors.inkCrimson,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      seal = Tooltip(message: widget.tooltip!, child: seal);
    }

    return seal;
  }
}

class _WaxSealPainter extends CustomPainter {
  final bool isHovered;

  _WaxSealPainter({required this.isHovered});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer drop shadow
    final shadowPaint = Paint()
      ..color = const Color(0x66330502)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center + const Offset(0, 3), radius * 0.94, shadowPaint);

    // Organic wavy melted wax edge path
    final waxPath = Path();
    const numPoints = 28;
    for (int i = 0; i <= numPoints; i++) {
      final angle = (i * 2 * math.pi) / numPoints;
      // Slight organic irregularity for melted wax
      final irregularity = 1.0 +
          0.045 * math.sin(angle * 5) +
          0.025 * math.cos(angle * 7);
      final r = radius * 0.92 * irregularity;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        waxPath.moveTo(x, y);
      } else {
        waxPath.lineTo(x, y);
      }
    }
    waxPath.close();

    // Wax radial gradient fill
    final waxShader = RadialGradient(
      center: const Alignment(-0.25, -0.3),
      radius: 0.9,
      colors: isHovered
          ? const [
              Color(0xFFD63B30),
              Color(0xFFA81C14),
              Color(0xFF75110B),
              Color(0xFF4A0804),
            ]
          : const [
              Color(0xFFC7281E),
              Color(0xFF9E1810),
              Color(0xFF6B0E08),
              Color(0xFF420603),
            ],
      stops: const [0.0, 0.45, 0.85, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(waxPath, Paint()..shader = waxShader);

    // Embossed inner ring
    final innerRingRadius = radius * 0.68;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = const Color(0x40FFFFFF);
    canvas.drawCircle(center, innerRingRadius, ringPaint);

    final ringShadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = const Color(0x60330000);
    canvas.drawCircle(center + const Offset(1, 1), innerRingRadius, ringShadowPaint);

    // Specular gloss arc on top-left edge
    final glossPath = Path();
    glossPath.addArc(
      Rect.fromCircle(center: center, radius: radius * 0.82),
      -math.pi * 0.75,
      math.pi * 0.6,
    );
    final glossPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..color = const Color(0x55FFFFFF);
    canvas.drawPath(glossPath, glossPaint);
  }

  @override
  bool shouldRepaint(covariant _WaxSealPainter oldDelegate) {
    return oldDelegate.isHovered != isHovered;
  }
}
