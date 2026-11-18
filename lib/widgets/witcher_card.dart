import 'package:flutter/material.dart';
import '../core/theme/witcher_colors.dart';

class WitcherCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderWidth;
  final bool isInteractive;
  final bool isSelected;
  final VoidCallback? onTap;

  const WitcherCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.borderColor,
    this.backgroundColor,
    this.borderWidth = 1.2,
    this.isInteractive = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<WitcherCard> createState() => _WitcherCardState();
}

class _WitcherCardState extends State<WitcherCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeBorderColor = widget.borderColor ??
        (widget.isSelected
            ? WitcherColors.goldBright
            : (_isHovered ? WitcherColors.gold : WitcherColors.borderDark));

    final activeBgColor = widget.backgroundColor ??
        (widget.isSelected
            ? const Color(0xFF222631)
            : (_isHovered ? const Color(0xFF1E212A) : WitcherColors.surface));

    Widget content = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: activeBgColor,
        boxShadow: widget.isSelected || _isHovered
            ? [
                BoxShadow(
                  color: (widget.borderColor ?? WitcherColors.gold)
                      .withValues(alpha: widget.isSelected ? 0.35 : 0.18),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : [
                const BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: CustomPaint(
        foregroundPainter: _WitcherBorderPainter(
          borderColor: activeBorderColor,
          borderWidth: widget.borderWidth,
          highlightCorners: widget.isSelected || _isHovered,
        ),
        child: Padding(
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );

    if (widget.isInteractive) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}

class _WitcherBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final bool highlightCorners;

  _WitcherBorderPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.highlightCorners,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    // Outer hairline rect
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // Inner subtle hairline rect (Witcher signature double-border)
    final innerPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.35)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(4, 4, w - 8, h - 8), innerPaint);

    // Ornate gold corner brackets
    final cornerPaint = Paint()
      ..color = highlightCorners ? WitcherColors.goldBright : borderColor
      ..strokeWidth = borderWidth * 1.8
      ..style = PaintingStyle.stroke;

    const cornerLen = 12.0;

    // Top-Left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLen, 0), cornerPaint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLen), cornerPaint);

    // Top-Right
    canvas.drawLine(Offset(w, 0), Offset(w - cornerLen, 0), cornerPaint);
    canvas.drawLine(Offset(w, 0), Offset(w, cornerLen), cornerPaint);

    // Bottom-Left
    canvas.drawLine(Offset(0, h), Offset(cornerLen, h), cornerPaint);
    canvas.drawLine(Offset(0, h), Offset(0, h - cornerLen), cornerPaint);

    // Bottom-Right
    canvas.drawLine(Offset(w, h), Offset(w - cornerLen, h), cornerPaint);
    canvas.drawLine(Offset(w, h), Offset(w, h - cornerLen), cornerPaint);

    // Diamond rivet in corners when highlighted
    if (highlightCorners) {
      final rivetPaint = Paint()
        ..color = WitcherColors.goldBright
        ..style = PaintingStyle.fill;

      _drawRivet(canvas, 7, 7, rivetPaint);
      _drawRivet(canvas, w - 7, 7, rivetPaint);
      _drawRivet(canvas, 7, h - 7, rivetPaint);
      _drawRivet(canvas, w - 7, h - 7, rivetPaint);
    }
  }

  void _drawRivet(Canvas canvas, double cx, double cy, Paint paint) {
    final path = Path();
    path.moveTo(cx, cy - 2.5);
    path.lineTo(cx + 2.5, cy);
    path.lineTo(cx, cy + 2.5);
    path.lineTo(cx - 2.5, cy);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WitcherBorderPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.highlightCorners != highlightCorners;
}
