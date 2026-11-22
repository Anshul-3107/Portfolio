import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/audio/witcher_audio.dart';
import '../../core/theme/witcher_colors.dart';
import '../../core/theme/witcher_typography.dart';
import 'witcher_book_theme.dart';

class WitcherParchmentPage extends StatelessWidget {
  final Widget child;
  final bool isLeftPage;
  final bool isRightPage;
  final String? chapterHeader;
  final String? folioNumber;
  final VoidCallback? onTurnPage;
  final String? turnPageLabel;
  final bool isTurnBackwards;

  const WitcherParchmentPage({
    super.key,
    required this.child,
    this.isLeftPage = false,
    this.isRightPage = false,
    this.chapterHeader,
    this.folioNumber,
    this.onTurnPage,
    this.turnPageLabel,
    this.isTurnBackwards = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: WitcherBookTheme.parchmentDecoration(
        isLeftPage: isLeftPage,
        isRightPage: isRightPage,
      ),
      child: Stack(
        children: [
          // Weathered paper background details: Deckled edges, foxing, oxidation
          Positioned.fill(
            child: CustomPaint(
              painter: _WeatheredParchmentPainter(
                isLeftPage: isLeftPage,
                isRightPage: isRightPage,
              ),
            ),
          ),

          // Main page contents with header & footer
          Padding(
            padding: EdgeInsets.only(
              left: isLeftPage ? 26 : (isRightPage ? 44 : 20),
              right: isRightPage ? 26 : (isLeftPage ? 44 : 20),
              top: 12,
              bottom: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Page Header with Chapter Title
                if (chapterHeader != null) ...[
                  Row(
                    mainAxisAlignment: isLeftPage
                        ? MainAxisAlignment.start
                        : (isRightPage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.center),
                    children: [
                      Text(
                        chapterHeader!.toUpperCase(),
                        style: WitcherTypography.parchmentFolio.copyWith(
                          color: const Color(0xFF5E4D3C),
                          fontSize: 10,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  WitcherBookTheme.buildOrnamentalDivider(height: 12),
                  const SizedBox(height: 6),
                ],

                // Scrollable Content Leaf
                Expanded(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      scrollbarTheme: ScrollbarThemeData(
                        thumbColor: WidgetStateProperty.all(
                          const Color(0xFF7A5812).withValues(alpha: 0.4),
                        ),
                        radius: const Radius.circular(2),
                        thickness: WidgetStateProperty.all(4),
                      ),
                    ),
                    child: child,
                  ),
                ),

                // Page Footer (Folio & Navigation Page Curl Trigger)
                const SizedBox(height: 6),
                WitcherBookTheme.buildOrnamentalDivider(height: 12),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isLeftPage && onTurnPage != null)
                      _buildPageTurnTrigger(
                        label: turnPageLabel ?? '⮜ PREV CHAPTER',
                        onTap: onTurnPage!,
                        isBackwards: true,
                      )
                    else if (isLeftPage && folioNumber != null)
                      Text(
                        folioNumber!.toUpperCase(),
                        style: WitcherTypography.parchmentFolio.copyWith(
                          color: const Color(0xFF5E4D3C),
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    if (folioNumber != null && (!isLeftPage || onTurnPage != null))
                      Text(
                        folioNumber!.toUpperCase(),
                        style: WitcherTypography.parchmentFolio.copyWith(
                          color: const Color(0xFF5E4D3C),
                        ),
                      ),

                    if (isRightPage && onTurnPage != null)
                      _buildPageTurnTrigger(
                        label: turnPageLabel ?? 'NEXT CHAPTER ⮞',
                        onTap: onTurnPage!,
                        isBackwards: false,
                      )
                    else if (!isLeftPage && !isRightPage && onTurnPage != null)
                      _buildPageTurnTrigger(
                        label: turnPageLabel ?? (isTurnBackwards ? '⮜ PREV' : 'NEXT ⮞'),
                        onTap: onTurnPage!,
                        isBackwards: isTurnBackwards,
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTurnTrigger({
    required String label,
    required VoidCallback onTap,
    required bool isBackwards,
  }) {
    return _PageTurnButton(
      label: label,
      onTap: onTap,
      isBackwards: isBackwards,
    );
  }
}

class _PageTurnButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isBackwards;

  const _PageTurnButton({
    required this.label,
    required this.onTap,
    required this.isBackwards,
  });

  @override
  State<_PageTurnButton> createState() => _PageTurnButtonState();
}

class _PageTurnButtonState extends State<_PageTurnButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        WitcherAudio.hover();
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          WitcherAudio.pageFlip();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF7A5812).withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: _isHovered ? const Color(0xFF7A5812) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: WitcherTypography.parchmentFolio.copyWith(
                  color: _isHovered
                      ? const Color(0xFF6B1914)
                      : WitcherColors.inkPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Dull Aged Weathering, Stains, Foxing & Deckled Edges
class _WeatheredParchmentPainter extends CustomPainter {
  final bool isLeftPage;
  final bool isRightPage;

  _WeatheredParchmentPainter({
    required this.isLeftPage,
    required this.isRightPage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // 1. Organic Deckled Torn Border along outer margin (Dull sepia)
    final decklePaint = Paint()
      ..color = const Color(0x45553E1F)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final deckleFill = Paint()
      ..color = const Color(0x224D351A)
      ..style = PaintingStyle.fill;

    if (isLeftPage) {
      _drawDeckledEdge(
        canvas: canvas,
        startX: 4,
        startY: 6,
        endX: 4,
        endY: size.height - 6,
        isVertical: true,
        paint: decklePaint,
        fillPaint: deckleFill,
        inwardOffset: 3,
      );
    } else if (isRightPage) {
      _drawDeckledEdge(
        canvas: canvas,
        startX: size.width - 4,
        startY: 6,
        endX: size.width - 4,
        endY: size.height - 6,
        isVertical: true,
        paint: decklePaint,
        fillPaint: deckleFill,
        inwardOffset: -3,
      );
    }

    // Top & Bottom deckled hairlines
    _drawDeckledEdge(
      canvas: canvas,
      startX: 8,
      startY: 3,
      endX: size.width - 8,
      endY: 3,
      isVertical: false,
      paint: decklePaint,
      fillPaint: deckleFill,
      inwardOffset: 2,
    );
    _drawDeckledEdge(
      canvas: canvas,
      startX: 8,
      startY: size.height - 3,
      endX: size.width - 8,
      endY: size.height - 3,
      isVertical: false,
      paint: decklePaint,
      fillPaint: deckleFill,
      inwardOffset: -2,
    );

    // 2. Antique Foxing Spots (Aged Oxidation Specks & Spots)
    final foxingPaint = Paint()
      ..color = const Color(0x263D2612)
      ..style = PaintingStyle.fill;

    final foxingRing = Paint()
      ..color = const Color(0x2E321E0E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Deterministic spots
    final spots = isLeftPage
        ? const [
            Offset(0.12, 0.18),
            Offset(0.08, 0.45),
            Offset(0.15, 0.72),
            Offset(0.22, 0.88),
            Offset(0.35, 0.08),
            Offset(0.28, 0.32),
            Offset(0.09, 0.62),
          ]
        : const [
            Offset(0.88, 0.14),
            Offset(0.92, 0.38),
            Offset(0.84, 0.68),
            Offset(0.78, 0.82),
            Offset(0.65, 0.12),
            Offset(0.72, 0.42),
            Offset(0.90, 0.58),
          ];

    for (int i = 0; i < spots.length; i++) {
      final center = Offset(spots[i].dx * size.width, spots[i].dy * size.height);
      final radius = 2.0 + (i % 3) * 1.8;
      canvas.drawCircle(center, radius, foxingPaint);
      if (i % 2 == 0) {
        canvas.drawCircle(center, radius + 1.2, foxingRing);
      }
    }

    // 3. Subtle Candle-Smoke / Library Dust Stain Organic Wash in corners
    final stainPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0x2435210F),
          const Color(0x1235210F),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: isLeftPage
              ? Offset(size.width * 0.08, size.height * 0.15)
              : Offset(size.width * 0.92, size.height * 0.85),
          radius: 90,
        ),
      );

    canvas.drawCircle(
      isLeftPage
          ? Offset(size.width * 0.08, size.height * 0.15)
          : Offset(size.width * 0.92, size.height * 0.85),
      90,
      stainPaint,
    );
  }

  void _drawDeckledEdge({
    required Canvas canvas,
    required double startX,
    required double startY,
    required double endX,
    required double endY,
    required bool isVertical,
    required Paint paint,
    required Paint fillPaint,
    required double inwardOffset,
  }) {
    final path = Path();
    path.moveTo(startX, startY);

    if (isVertical) {
      final length = endY - startY;
      const step = 8.0;
      final count = (length / step).floor();

      for (int i = 1; i <= count; i++) {
        final y = startY + i * step;
        final jag = math.sin(i * 1.7) * 1.4 + math.cos(i * 2.9) * 0.8;
        path.lineTo(startX + jag, y);
      }
      path.lineTo(endX, endY);
    } else {
      final length = endX - startX;
      const step = 8.0;
      final count = (length / step).floor();

      for (int i = 1; i <= count; i++) {
        final x = startX + i * step;
        final jag = math.sin(i * 1.7) * 1.2 + math.cos(i * 2.9) * 0.6;
        path.lineTo(x, startY + jag);
      }
      path.lineTo(endX, endY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WeatheredParchmentPainter oldDelegate) => false;
}
