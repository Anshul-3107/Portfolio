import 'package:flutter/material.dart';
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
    final ink = tier.inkColor;
    final bg = tier.badgeBgColor;
    final border = tier.badgeBorderColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 1.2),
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 3,
            offset: Offset(0, 1),
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
            size: compact ? 12 : 14,
            color: ink,
          ),
          const SizedBox(width: 5),
          Text(
            tier.displayName.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Cinzel',
              color: ink,
              fontSize: compact ? 9.5 : 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
