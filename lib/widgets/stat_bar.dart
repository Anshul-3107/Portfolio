import 'package:flutter/material.dart';
import '../core/theme/witcher_colors.dart';
import '../core/theme/witcher_typography.dart';

class StatBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final Color barColor;
  final String? displayValue;
  final IconData? icon;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    this.barColor = WitcherColors.crimsonBright,
    this.displayValue,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);
    final percentage = (clampedValue * 100).toInt();
    final textValue = displayValue ?? '$percentage%';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 14, color: barColor),
                    const SizedBox(width: 7),
                  ],
                  Text(
                    label,
                    style: WitcherTypography.bodyMedium.copyWith(
                      color: WitcherColors.textParchmentLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: barColor.withValues(alpha: 0.12),
                  border: Border.all(color: barColor.withValues(alpha: 0.4), width: 0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  textValue,
                  style: WitcherTypography.metricLabel.copyWith(
                    color: barColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            height: 11,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1117),
              border: Border.all(color: WitcherColors.borderDark, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: clampedValue,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          barColor.withValues(alpha: 0.75),
                          barColor,
                          Color.lerp(barColor, Colors.white, 0.25)!,
                        ],
                        stops: const [0.0, 0.85, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: barColor.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
                // Metallic specular line
                Positioned(
                  top: 1,
                  left: 0,
                  right: 0,
                  height: 1.5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.3),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
