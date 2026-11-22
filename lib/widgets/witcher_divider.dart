import 'package:flutter/material.dart';
import '../core/theme/witcher_colors.dart';

class WitcherDivider extends StatelessWidget {
  final double height;
  final String? symbol;
  final double symbolSize;
  final Color? color;

  const WitcherDivider({
    super.key,
    this.height = 24,
    this.symbol = '❖',
    this.symbolSize = 10,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final goldColor = color ?? WitcherColors.gold;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    goldColor.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
          if (symbol != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                symbol!,
                style: TextStyle(
                  color: goldColor,
                  fontSize: symbolSize,
                  shadows: [
                    Shadow(
                      color: goldColor.withValues(alpha: 0.8),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    goldColor.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
