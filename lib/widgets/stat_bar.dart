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
    final percentage = (value.clamp(0.0, 1.0) * 100).toInt();
    final textValue = displayValue ?? '$percentage%';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: WitcherTypography.bodyMedium.copyWith(
                      color: WitcherColors.textParchmentLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                textValue,
                style: WitcherTypography.metricLabel.copyWith(
                  color: barColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF101217),
              border: Border.all(color: WitcherColors.borderDark, width: 1),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          barColor.withValues(alpha: 0.7),
                          barColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: barColor.withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                // Subtle metallic reflection line
                Positioned(
                  top: 1,
                  left: 0,
                  right: 0,
                  height: 1.5,
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.15),
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
