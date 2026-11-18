import 'package:flutter/material.dart';
import '../core/theme/witcher_typography.dart';
import '../models/portfolio_models.dart';

class TierBadge extends StatelessWidget {
  final ArmorTier tier;
  final bool compact;

  const TierBadge({
    super.key,
    required this.tier,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = tier.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 12,
        vertical: compact ? 2.5 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.8), width: 1.0),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            tier == ArmorTier.grandmaster
                ? Icons.shield_rounded
                : (tier == ArmorTier.mastercrafted
                    ? Icons.military_tech_rounded
                    : Icons.workspace_premium_rounded),
            size: compact ? 11 : 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            tier.displayName.toUpperCase(),
            style: WitcherTypography.tagText.copyWith(
              color: color,
              fontSize: compact ? 9.5 : 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: compact ? 0.8 : 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
