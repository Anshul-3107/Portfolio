import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/witcher_colors.dart';

class EmberParticles extends StatefulWidget {
  final Widget child;
  final int particleCount;

  const EmberParticles({
    super.key,
    required this.child,
    this.particleCount = 50,
  });

  @override
  State<EmberParticles> createState() => _EmberParticlesState();
}

class _EmberParticlesState extends State<EmberParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Ember> _embers = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();

    for (int i = 0; i < widget.particleCount; i++) {
      _embers.add(_createEmber(initial: true));
    }
  }

  _Ember _createEmber({bool initial = false}) {
    final isSpark = _random.nextDouble() < 0.25;
    return _Ember(
      x: _random.nextDouble(),
      y: initial ? _random.nextDouble() : 1.05 + _random.nextDouble() * 0.1,
      size: isSpark ? 1.0 + _random.nextDouble() * 1.5 : 2.0 + _random.nextDouble() * 2.8,
      speed: isSpark ? 0.07 + _random.nextDouble() * 0.11 : 0.035 + _random.nextDouble() * 0.065,
      drift: (_random.nextDouble() - 0.5) * 0.04,
      alpha: 0.3 + _random.nextDouble() * 0.6,
      flickerPhase: _random.nextDouble() * 2 * pi,
      color: _random.nextBool()
          ? WitcherColors.goldBright
          : (_random.nextDouble() < 0.3 ? const Color(0xFFFF7043) : WitcherColors.crimsonBright),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animValue = _controller.value * 2 * pi;

        for (int i = 0; i < _embers.length; i++) {
          final ember = _embers[i];
          ember.y -= ember.speed * 0.012;
          ember.x += (ember.drift + sin(animValue + ember.flickerPhase) * 0.01) * 0.012;

          if (ember.y < -0.05) {
            ember.y = 1.05;
            ember.x = _random.nextDouble();
          }
        }
        return CustomPaint(
          painter: _EmberPainter(_embers, _controller.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _Ember {
  double x;
  double y;
  double size;
  double speed;
  double drift;
  double alpha;
  double flickerPhase;
  Color color;

  _Ember({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.drift,
    required this.alpha,
    required this.flickerPhase,
    required this.color,
  });
}

class _EmberPainter extends CustomPainter {
  final List<_Ember> embers;
  final double progress;

  _EmberPainter(this.embers, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Layer 1: Atmospheric Vignette & Hearth Backdrop
    final bgRect = Rect.fromLTWH(0, 0, w, h);

    // Warm bottom hearth glow
    final hearthPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, 1.05),
        radius: 0.9,
        colors: [
          WitcherColors.gold.withValues(alpha: 0.12),
          WitcherColors.crimson.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, hearthPaint);

    // Top subtle moonlit indigo ambiance
    final moonPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.7, -0.9),
        radius: 0.8,
        colors: [
          const Color(0xFF324865).withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, moonPaint);

    // Layer 2: Embers with realistic flicker & specular halo
    final corePaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < embers.length; i++) {
      final ember = embers[i];
      final dx = ember.x * w;
      final dy = ember.y * h;

      final flicker = (sin(progress * 14 + ember.flickerPhase) * 0.25 + 0.75).clamp(0.2, 1.0);
      final currentAlpha = (ember.alpha * flicker).clamp(0.0, 1.0);

      // Soft ambient bloom halo
      glowPaint.color = ember.color.withValues(alpha: currentAlpha * 0.22);
      canvas.drawCircle(Offset(dx, dy), ember.size * 2.8, glowPaint);

      // Core ember point
      corePaint.color = Color.lerp(
        ember.color,
        Colors.white,
        0.35,
      )!.withValues(alpha: currentAlpha);
      canvas.drawCircle(Offset(dx, dy), ember.size, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EmberPainter oldDelegate) => true;
}
