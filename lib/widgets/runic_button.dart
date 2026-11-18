import 'package:flutter/material.dart';
import '../core/audio/witcher_audio.dart';
import '../core/theme/witcher_colors.dart';
import '../core/theme/witcher_typography.dart';

enum RunicButtonStyle {
  gold,
  crimson,
  secondary,
}

class RunicButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final RunicButtonStyle style;
  final bool isCompact;

  const RunicButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.style = RunicButtonStyle.gold,
    this.isCompact = false,
  });

  @override
  State<RunicButton> createState() => _RunicButtonState();
}

class _RunicButtonState extends State<RunicButton> {
  bool _isHovered = false;

  Color get _primaryColor {
    switch (widget.style) {
      case RunicButtonStyle.gold:
        return WitcherColors.goldBright;
      case RunicButtonStyle.crimson:
        return WitcherColors.crimsonBright;
      case RunicButtonStyle.secondary:
        return WitcherColors.textParchmentLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _primaryColor;

    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _isHovered = true);
        WitcherAudio.hover();
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          if (widget.onPressed != null) {
            WitcherAudio.click();
            widget.onPressed!();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCompact ? 14 : 20,
            vertical: widget.isCompact ? 8 : 12,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? activeColor.withValues(alpha: 0.16)
                : const Color(0xFF161920),
            border: Border.all(
              color: _isHovered ? activeColor : activeColor.withValues(alpha: 0.6),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.35),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: widget.isCompact ? 14 : 16,
                  color: _isHovered ? activeColor : activeColor.withValues(alpha: 0.85),
                ),
                SizedBox(width: widget.isCompact ? 6 : 8),
              ],
              Text(
                widget.text.toUpperCase(),
                style: WitcherTypography.tagText.copyWith(
                  color: _isHovered ? activeColor : WitcherColors.textParchmentLight,
                  fontSize: widget.isCompact ? 11 : 12.5,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
