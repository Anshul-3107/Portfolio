import 'package:flutter/material.dart';
import '../../../core/audio/witcher_audio.dart';
import '../../../core/constants/resume_data.dart';
import '../../../core/theme/witcher_colors.dart';
import '../../../core/theme/witcher_typography.dart';
import '../../../models/portfolio_models.dart';
import '../../tier_badge.dart';
import '../witcher_book_theme.dart';
import '../witcher_parchment_page.dart';

class SignsSpread extends StatefulWidget {
  final bool isDesktop;
  final VoidCallback onTurnPrevious;
  final VoidCallback onTurnNext;

  const SignsSpread({
    super.key,
    required this.isDesktop,
    required this.onTurnPrevious,
    required this.onTurnNext,
  });

  @override
  State<SignsSpread> createState() => _SignsSpreadState();
}

class _SignsSpreadState extends State<SignsSpread> {
  int _selectedSignIndex = 0;

  void _selectSign(int index) {
    WitcherAudio.sign();
    setState(() => _selectedSignIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final signs = ResumeData.skillSigns;
    final selectedSign = signs[_selectedSignIndex];

    if (widget.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Page: Interactive Sigils Registry (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isLeftPage: true,
              chapterHeader: "CHAPTER III • SIGNS & ARSENAL",
              folioNumber: "FOLIO V • THE SIX SIGILS",
              onTurnPage: widget.onTurnPrevious,
              turnPageLabel: "⮜ CONTRACTS",
              isTurnBackwards: true,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildSignsListLeaf(signs),
              ),
            ),
          ),

          // Right Page: In-depth Combat Showcase & Hierarchy Legend (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isRightPage: true,
              chapterHeader: "CHAPTER III • COMBAT CODEX",
              folioNumber: "FOLIO VI • WEAPONS OF THE NEURAL SCHOOL",
              onTurnPage: widget.onTurnNext,
              turnPageLabel: "NOTICE BOARD ⮞",
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildSignShowcaseLeaf(selectedSign),
              ),
            ),
          ),
        ],
      );
    } else {
      // Mobile Single Page Spread
      return WitcherParchmentPage(
        chapterHeader: "CHAPTER III • SIGNS & ARSENAL",
        folioNumber: "FOLIO V • COMBAT CODEX",
        onTurnPage: widget.onTurnNext,
        turnPageLabel: "NOTICE BOARD ⮞",
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              _buildSignsListLeaf(signs),
              const SizedBox(height: 18),
              WitcherBookTheme.buildOrnamentalDivider(symbol: '⚔', height: 20),
              const SizedBox(height: 18),
              _buildSignShowcaseLeaf(selectedSign),
            ],
          ),
        ),
      );
    }
  }

  // Left Page: The 6 Witcher Signs (Aard, Quen, Igni, Axii, Yrden, Alchemy)
  Widget _buildSignsListLeaf(List<SkillSignModel> signs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WitcherBookTheme.buildDropCap("S", "igils of the Neural Grandmaster"),
        const SizedBox(height: 8),
        Text(
          "Select a Witcher sign to unveil its technical mastery, combat proficiencies, and armor tier hierarchy.",
          style: WitcherTypography.parchmentBody.copyWith(
            fontSize: 12.5,
            color: WitcherColors.inkMuted,
          ),
        ),
        const SizedBox(height: 14),

        // Grid / List of Signs
        ...List.generate(signs.length, (index) {
          final sign = signs[index];
          final isSelected = _selectedSignIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SignCard(
              sign: sign,
              isSelected: isSelected,
              onTap: () => _selectSign(index),
            ),
          );
        }),
      ],
    );
  }

  // Right Page: Detailed Weaponry & Tier Hierarchy
  Widget _buildSignShowcaseLeaf(SkillSignModel sign) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sign Header with Rune
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFCFBE9B),
                shape: BoxShape.circle,
                border: Border.all(color: sign.signColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: sign.signColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  sign.icon,
                  size: 20,
                  color: sign.signColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SIGN OF ${sign.signName.toUpperCase()}",
                    style: WitcherTypography.parchmentHeading.copyWith(
                      fontSize: 17,
                      color: WitcherColors.inkCrimson,
                    ),
                  ),
                  Text(
                    sign.domainName.toUpperCase(),
                    style: WitcherTypography.parchmentSubheading.copyWith(
                      fontSize: 11.5,
                      color: WitcherColors.inkGold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        WitcherBookTheme.buildOrnamentalDivider(symbol: '❖', height: 14),
        const SizedBox(height: 8),

        // Lore Description
        Text(
          sign.signDescription,
          style: WitcherTypography.parchmentBody.copyWith(height: 1.55),
        ),
        const SizedBox(height: 16),

        // Inscribed Weapons & Proficiencies
        Text(
          "ARSENAL & PROFICIENCY CODEX",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),

        ...sign.skills.map((skill) {
          final double proficiency = skill.tier == ArmorTier.grandmaster
              ? 0.96
              : (skill.tier == ArmorTier.mastercrafted ? 0.88 : 0.78);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: WitcherBookTheme.cardInsetDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      skill.name,
                      style: WitcherTypography.parchmentBody.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                        color: WitcherColors.inkPrimary,
                      ),
                    ),
                    TierBadge(tier: skill.tier, compact: true),
                  ],
                ),
                if (skill.note != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    skill.note!,
                    style: WitcherTypography.parchmentBody.copyWith(
                      fontSize: 10.5,
                      color: WitcherColors.inkMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC4B28B),
                    borderRadius: BorderRadius.circular(1.5),
                    border: Border.all(color: const Color(0xFFA6936C), width: 0.8),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: proficiency,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.5),
                        color: sign.signColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),

        // Armor Tier Hierarchy Legend
        Text(
          "ARMOR MASTERY HIERARCHY",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: WitcherBookTheme.cardInsetDecoration(),
          child: Column(
            children: const [
              _LegendRow("Grandmaster", "Peak battle-tested production proficiency (95%+)", WitcherColors.tierGrandmaster),
              SizedBox(height: 5),
              _LegendRow("Mastercrafted", "High advanced enterprise & architectural mastery (85%+)", WitcherColors.tierMastercrafted),
              SizedBox(height: 5),
              _LegendRow("Superior", "Strong production competence & deep hands-on expertise (75%+)", WitcherColors.tierSuperior),
            ],
          ),
        ),
      ],
    );
  }
}

class _SignCard extends StatefulWidget {
  final SkillSignModel sign;
  final bool isSelected;
  final VoidCallback onTap;

  const _SignCard({
    required this.sign,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SignCard> createState() => _SignCardState();
}

class _SignCardState extends State<_SignCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final sign = widget.sign;
    final isSelected = widget.isSelected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        WitcherAudio.hover();
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: WitcherBookTheme.cardInsetDecoration(
            isInteractive: true,
            isHovered: _isHovered,
            isSelected: isSelected,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFCFBE9B),
                  border: Border.all(color: sign.signColor, width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    sign.icon,
                    size: 16,
                    color: sign.signColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sign.signName.toUpperCase(),
                      style: WitcherTypography.parchmentHeading.copyWith(
                        fontSize: 13,
                        color: isSelected ? WitcherColors.inkCrimson : WitcherColors.inkPrimary,
                      ),
                    ),
                    Text(
                      sign.domainName,
                      style: WitcherTypography.parchmentBody.copyWith(
                        fontSize: 11,
                        color: WitcherColors.inkMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: WitcherColors.inkCrimson,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String tier;
  final String desc;
  final Color color;

  const _LegendRow(this.tier, this.desc, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          tier.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: WitcherColors.inkPrimary,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            desc,
            style: TextStyle(
              fontFamily: 'Marcellus',
              fontSize: 10.5,
              color: WitcherColors.inkMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
