import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/audio/witcher_audio.dart';

class WitcherPageFlipTransition extends StatefulWidget {
  final int currentIndex;
  final Widget child;
  final Duration singleFlipDuration;
  final Duration riffleDuration;

  const WitcherPageFlipTransition({
    super.key,
    required this.currentIndex,
    required this.child,
    this.singleFlipDuration = const Duration(milliseconds: 720),
    this.riffleDuration = const Duration(milliseconds: 1050),
  });

  @override
  State<WitcherPageFlipTransition> createState() => _WitcherPageFlipTransitionState();
}

class _WitcherPageFlipTransitionState extends State<WitcherPageFlipTransition>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  Widget? _previousChild;
  Widget? _currentChild;
  int _delta = 0;
  bool _isRiffle = false;

  @override
  void initState() {
    super.initState();
    _currentChild = widget.child;

    _flipController = AnimationController(
      vsync: this,
      duration: widget.singleFlipDuration,
    );

    // Ultra-smooth cubic easing for slow, deliberate, natural paper momentum
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutCubic,
    );

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _previousChild = null;
          _delta = 0;
          _isRiffle = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant WitcherPageFlipTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      final delta = widget.currentIndex - oldWidget.currentIndex;
      _previousChild = oldWidget.child;
      _currentChild = widget.child;
      _delta = delta;
      _isRiffle = delta.abs() > 1;

      // Adjust duration: slower and smoother as requested
      _flipController.duration = _isRiffle ? widget.riffleDuration : widget.singleFlipDuration;

      // Play audio effect: authentic parchment page turning sound
      WitcherAudio.pageFlip();

      _flipController.forward(from: 0.0);
    } else if (widget.child != oldWidget.child) {
      setState(() {
        _currentChild = widget.child;
      });
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_delta == 0 || _previousChild == null) {
      return widget.child;
    }

    final isForward = _delta > 0;
    final leafCount = _delta.abs().clamp(2, 4);

    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, _) {
        final t = _flipAnimation.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;
            final halfWidth = constraints.maxWidth / 2;
            final fullHeight = constraints.maxHeight;

            return Stack(
              fit: StackFit.expand,
              children: [
                // 1. Incoming target spread settled underneath
                Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: _currentChild,
                ),

                // 2. Outgoing spread smoothly fading underneath
                Opacity(
                  opacity: (1.0 - t * 1.3).clamp(0.0, 1.0),
                  child: _previousChild,
                ),

                // 3. Dynamic ambient cast shadow on the receiving page
                if (isDesktop)
                  _buildReceivingPageShadow(t, isForward, halfWidth, fullHeight)
                else
                  _buildMobileReceivingPageShadow(t, isForward, constraints),

                // 4. Render turning page leaf (Single Flip vs Multi-Page Riffle)
                if (!_isRiffle)
                  (isDesktop
                      ? _buildSinglePageCurl(t, isForward, isDesktop, constraints)
                      : _buildMobileSingleVerticalCurl(t, isForward, constraints))
                else
                  ...List.generate(leafCount, (index) {
                    return isDesktop
                        ? _buildRiffleLeaf(index, leafCount, t, isForward, isDesktop, constraints)
                        : _buildMobileVerticalRiffleLeaf(index, leafCount, t, isForward, constraints);
                  }),
              ],
            );
          },
        );
      },
    );
  }

  // Soft moving shadow cast onto the stationary receiving page as the turning leaf approaches
  Widget _buildReceivingPageShadow(double t, bool isForward, double halfWidth, double height) {
    final shadowLeft = isForward ? 0.0 : halfWidth;
    final shadowOpacity = (t > 0.4 ? math.sin((t - 0.4) / 0.6 * math.pi) * 0.35 : 0.0).clamp(0.0, 0.35);

    if (shadowOpacity <= 0.01) return const SizedBox.shrink();

    return Positioned(
      left: shadowLeft,
      top: 0,
      width: halfWidth,
      height: height,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: isForward ? Alignment.centerRight : Alignment.centerLeft,
              end: isForward ? Alignment.centerLeft : Alignment.centerRight,
              colors: [
                Color.fromRGBO(16, 8, 3, shadowOpacity),
                Color.fromRGBO(16, 8, 3, shadowOpacity * 0.4),
                Colors.transparent,
              ],
              stops: const [0.0, 0.35, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  // Soft moving shadow cast onto the stationary receiving mobile page
  Widget _buildMobileReceivingPageShadow(double t, bool isForward, BoxConstraints constraints) {
    final shadowOpacity = (t > 0.35 ? math.sin((t - 0.35) / 0.65 * math.pi) * 0.36 : 0.0).clamp(0.0, 0.36);
    if (shadowOpacity <= 0.01) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: constraints.maxHeight * 0.45,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(16, 8, 3, shadowOpacity),
                Color.fromRGBO(16, 8, 3, shadowOpacity * 0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSinglePageCurl(double t, bool isForward, bool isDesktop, BoxConstraints constraints) {
    final angle = isForward ? -t * math.pi : t * math.pi;
    final isHalfway = t > 0.5;

    final leafWidth = isDesktop ? constraints.maxWidth / 2 : constraints.maxWidth;
    final leafHeight = constraints.maxHeight;

    final leftOffset = isDesktop ? (isForward ? leafWidth : 0.0) : 0.0;
    final alignment = isForward ? Alignment.centerLeft : Alignment.centerRight;

    final curlLight = math.sin(t * math.pi);

    return Positioned(
      left: leftOffset,
      top: 0,
      width: leafWidth,
      height: leafHeight,
      child: Transform(
        alignment: alignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0010) // Smooth, natural 3D perspective
          ..rotateY(angle),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: isForward ? Alignment.centerLeft : Alignment.centerRight,
              end: isForward ? Alignment.centerRight : Alignment.centerLeft,
              colors: [
                // Near spine hinge (Dull sepia)
                Color.lerp(
                  const Color(0xFFB59F74),
                  const Color(0xFF755C34),
                  curlLight * 0.42,
                )!,
                // Belly of turning page (Matte vellum)
                Color.lerp(
                  const Color(0xFFDCCEA7),
                  const Color(0xFFA89366),
                  curlLight * 0.55,
                )!,
                // Outer edge of turning page
                Color.lerp(
                  const Color(0xFFC8B58D),
                  const Color(0xFF8F7951),
                  curlLight * 0.38,
                )!,
              ],
              stops: const [0.0, 0.65, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(
                  12,
                  6,
                  2,
                  (curlLight * 0.52).clamp(0.0, 1.0),
                ),
                blurRadius: 16 + (curlLight * 14),
                spreadRadius: 1 + (curlLight * 3),
                offset: Offset(
                  isForward ? -14 * (1 - t) : 14 * (1 - t),
                  4 + curlLight * 6,
                ),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _PageCurlPainter(
              progress: t,
              isForward: isForward,
              isHalfway: isHalfway,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiffleLeaf(
    int leafIndex,
    int totalLeaves,
    double t,
    bool isForward,
    bool isDesktop,
    BoxConstraints constraints,
  ) {
    final staggerDelay = 0.09;
    final leafDuration = 0.55;
    final start = (leafIndex * staggerDelay).clamp(0.0, 1.0 - leafDuration);
    final end = (start + leafDuration).clamp(0.0, 1.0);
    final leafT = ((t - start) / (end - start)).clamp(0.0, 1.0);

    if (leafT <= 0.0 || leafT >= 1.0) {
      return const SizedBox.shrink();
    }

    final curvedLeafT = Curves.easeInOutCubic.transform(leafT);
    final angle = isForward ? -curvedLeafT * math.pi : curvedLeafT * math.pi;

    final leafWidth = isDesktop ? constraints.maxWidth / 2 : constraints.maxWidth;
    final leafHeight = constraints.maxHeight;
    final leftOffset = isDesktop ? (isForward ? leafWidth : 0.0) : 0.0;
    final alignment = isForward ? Alignment.centerLeft : Alignment.centerRight;

    final curlLight = math.sin(curvedLeafT * math.pi);

    return Positioned(
      left: leftOffset,
      top: 0,
      width: leafWidth,
      height: leafHeight,
      child: Transform(
        alignment: alignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0010)
          ..rotateY(angle),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: (leafIndex * 2.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: isForward ? Alignment.centerLeft : Alignment.centerRight,
              end: isForward ? Alignment.centerRight : Alignment.centerLeft,
              colors: [
                Color.lerp(
                  const Color(0xFFB59F74),
                  const Color(0xFF6E562F),
                  curlLight * 0.40,
                )!,
                Color.lerp(
                  const Color(0xFFD4C39C),
                  const Color(0xFF9E875B),
                  curlLight * 0.50,
                )!,
                Color.lerp(
                  const Color(0xFFC2AF87),
                  const Color(0xFF856E44),
                  curlLight * 0.35,
                )!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(
                  12,
                  6,
                  2,
                  (curlLight * 0.42).clamp(0.0, 1.0),
                ),
                blurRadius: 14 + (curlLight * 10),
                offset: Offset(isForward ? -10 : 10, 4),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _RiffleEdgePainter(
              leafIndex: leafIndex,
              isForward: isForward,
            ),
          ),
        ),
      ),
    );
  }

  // 3D Vertical Page Curl for Mobile/Phone (Flipping along top leather binding)
  Widget _buildMobileSingleVerticalCurl(double t, bool isForward, BoxConstraints constraints) {
    // If forward: page lifts from bottom and curls over the top hinge
    // If backward: page curls down from the top hinge into place
    final angle = isForward ? t * math.pi : -(1.0 - t) * math.pi;
    final isHalfway = t > 0.5;
    final leafWidth = constraints.maxWidth;
    final leafHeight = constraints.maxHeight;

    final curlLight = math.sin(t * math.pi);

    return Positioned(
      left: 0,
      top: 0,
      width: leafWidth,
      height: leafHeight,
      child: Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0010) // Smooth, natural 3D vertical perspective
          ..rotateX(angle),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Top hinge area (Dull sepia)
                Color.lerp(
                  const Color(0xFFB59F74),
                  const Color(0xFF755C34),
                  curlLight * 0.45,
                )!,
                // Belly of turning page
                Color.lerp(
                  const Color(0xFFDCCEA7),
                  const Color(0xFFA89366),
                  curlLight * 0.55,
                )!,
                // Bottom edge of turning page
                Color.lerp(
                  const Color(0xFFC8B58D),
                  const Color(0xFF8F7951),
                  curlLight * 0.38,
                )!,
              ],
              stops: const [0.0, 0.65, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(
                  12,
                  6,
                  2,
                  (curlLight * 0.52).clamp(0.0, 1.0),
                ),
                blurRadius: 16 + (curlLight * 14),
                spreadRadius: 1 + (curlLight * 3),
                offset: Offset(
                  0,
                  isForward ? curlLight * 14 : -curlLight * 14,
                ),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _MobileVerticalPageCurlPainter(
              progress: t,
              isForward: isForward,
              isHalfway: isHalfway,
            ),
          ),
        ),
      ),
    );
  }

  // 3D Vertical Multi-Page Riffle for Mobile
  Widget _buildMobileVerticalRiffleLeaf(
    int leafIndex,
    int totalLeaves,
    double t,
    bool isForward,
    BoxConstraints constraints,
  ) {
    const staggerDelay = 0.09;
    const leafDuration = 0.55;
    final start = (leafIndex * staggerDelay).clamp(0.0, 1.0 - leafDuration);
    final end = (start + leafDuration).clamp(0.0, 1.0);
    final leafT = ((t - start) / (end - start)).clamp(0.0, 1.0);

    if (leafT <= 0.0 || leafT >= 1.0) {
      return const SizedBox.shrink();
    }

    final curvedLeafT = Curves.easeInOutCubic.transform(leafT);
    final angle = isForward ? curvedLeafT * math.pi : -(1.0 - curvedLeafT) * math.pi;

    final leafWidth = constraints.maxWidth;
    final leafHeight = constraints.maxHeight;

    final curlLight = math.sin(curvedLeafT * math.pi);

    return Positioned(
      left: 0,
      top: 0,
      width: leafWidth,
      height: leafHeight,
      child: Transform(
        alignment: Alignment.topCenter,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0010)
          ..rotateX(angle),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: (leafIndex * 2.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(
                  const Color(0xFFB59F74),
                  const Color(0xFF6E562F),
                  curlLight * 0.40,
                )!,
                Color.lerp(
                  const Color(0xFFD4C39C),
                  const Color(0xFF9E875B),
                  curlLight * 0.50,
                )!,
                Color.lerp(
                  const Color(0xFFC2AF87),
                  const Color(0xFF856E44),
                  curlLight * 0.35,
                )!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(
                  12,
                  6,
                  2,
                  (curlLight * 0.42).clamp(0.0, 1.0),
                ),
                blurRadius: 14 + (curlLight * 10),
                offset: Offset(0, isForward ? 8 : -8),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _MobileVerticalRiffleEdgePainter(
              leafIndex: leafIndex,
              isForward: isForward,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageCurlPainter extends CustomPainter {
  final double progress;
  final bool isForward;
  final bool isHalfway;

  _PageCurlPainter({
    required this.progress,
    required this.isForward,
    required this.isHalfway,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final edgeX = isForward ? size.width - 2 : 2.0;
    final edgePaint = Paint()
      ..color = const Color(0x55634D29)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(edgeX, 4), Offset(edgeX, size.height - 4), edgePaint);

    final spineShadow = Paint()
      ..shader = LinearGradient(
        begin: isForward ? Alignment.centerLeft : Alignment.centerRight,
        end: isForward ? Alignment.centerRight : Alignment.centerLeft,
        colors: [
          const Color(0x35281608),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      isForward
          ? Rect.fromLTWH(0, 0, 32, size.height)
          : Rect.fromLTWH(size.width - 32, 0, 32, size.height),
      spineShadow,
    );
  }

  @override
  bool shouldRepaint(covariant _PageCurlPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _RiffleEdgePainter extends CustomPainter {
  final int leafIndex;
  final bool isForward;

  _RiffleEdgePainter({required this.leafIndex, required this.isForward});

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = const Color(0x606E5733)
      ..strokeWidth = 1.0;

    final x = isForward ? size.width - 2.0 : 2.0;
    canvas.drawLine(Offset(x, 6), Offset(x, size.height - 6), edgePaint);
  }

  @override
  bool shouldRepaint(covariant _RiffleEdgePainter oldDelegate) => false;
}

class _MobileVerticalPageCurlPainter extends CustomPainter {
  final double progress;
  final bool isForward;
  final bool isHalfway;

  _MobileVerticalPageCurlPainter({
    required this.progress,
    required this.isForward,
    required this.isHalfway,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final edgeY = isForward ? size.height - 2 : 2.0;
    final edgePaint = Paint()
      ..color = const Color(0x55634D29)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(8, edgeY), Offset(size.width - 8, edgeY), edgePaint);

    final hingeShadow = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x35281608),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, 28),
      hingeShadow,
    );
  }

  @override
  bool shouldRepaint(covariant _MobileVerticalPageCurlPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _MobileVerticalRiffleEdgePainter extends CustomPainter {
  final int leafIndex;
  final bool isForward;

  _MobileVerticalRiffleEdgePainter({required this.leafIndex, required this.isForward});

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = const Color(0x606E5733)
      ..strokeWidth = 1.0;

    final y = isForward ? size.height - 2.0 : 2.0;
    canvas.drawLine(Offset(8, y), Offset(size.width - 8, y), edgePaint);
  }

  @override
  bool shouldRepaint(covariant _MobileVerticalRiffleEdgePainter oldDelegate) => false;
}
