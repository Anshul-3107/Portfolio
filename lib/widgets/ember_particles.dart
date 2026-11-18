import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/witcher_colors.dart';

class EmberParticles extends StatefulWidget {
  final Widget child;
  final int particleCount;

  const EmberParticles({
    super.key,
    required this.child,
    this.particleCount = 45,
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
      duration: const Duration(seconds: 12),
    )..repeat();

    for (int i = 0; i < widget.particleCount; i++) {
      _embers.add(_createEmber(initial: true));
    }
  }

  _Ember _createEmber({bool initial = false}) {
    return _Ember(
      x: _random.nextDouble(),
      y: initial ? _random.nextDouble() : 1.05 + _random.nextDouble() * 0.1,
      size: 1.2 + _random.nextDouble() * 2.8,
      speed: 0.05 + _random.nextDouble() * 0.09,
      drift: (_random.nextDouble() - 0.5) * 0.03,
      alpha: 0.2 + _random.nextDouble() * 0.7,
      color: _random.nextBool()
          ? WitcherColors.goldBright
          : WitcherColors.crimsonBright,
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
        for (var ember in _embers) {
          ember.y -= ember.speed * 0.012;
          ember.x += ember.drift * 0.012;
          if (ember.y < -0.05) {
            ember.y = 1.05;
            ember.x = _random.nextDouble();
          }
        }
        return CustomPaint(
          painter: _EmberPainter(_embers),
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
  Color color;

  _Ember({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.drift,
    required this.alpha,
    required this.color,
  });
}

class _EmberPainter extends CustomPainter {
  final List<_Ember> embers;

  _EmberPainter(this.embers);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var ember in embers) {
      final dx = ember.x * size.width;
      final dy = ember.y * size.height;

      paint.color = ember.color.withValues(alpha: ember.alpha);
      canvas.drawCircle(Offset(dx, dy), ember.size, paint);

      // Soft glow aura
      paint.color = ember.color.withValues(alpha: ember.alpha * 0.3);
      canvas.drawCircle(Offset(dx, dy), ember.size * 2.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EmberPainter oldDelegate) => true;
}
