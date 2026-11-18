import 'package:flutter/material.dart';
import '../../core/audio/witcher_audio.dart';
import '../../core/constants/resume_data.dart';
import '../../core/theme/witcher_colors.dart';
import '../../core/theme/witcher_typography.dart';
import '../../models/portfolio_models.dart';
import '../../widgets/tier_badge.dart';
import '../../widgets/witcher_card.dart';

class SignsTab extends StatefulWidget {
  const SignsTab({super.key});

  @override
  State<SignsTab> createState() => _SignsTabState();
}

class _SignsTabState extends State<SignsTab> {
  int _selectedSignIndex = 0;

  @override
  Widget build(BuildContext context) {
    final signs = ResumeData.skillSigns;
    final selectedSign = signs[_selectedSignIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 920;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 16,
            vertical: 24,
          ),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title banner
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_fix_high_rounded,
                        color: WitcherColors.goldBright,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "SIGNS, ARSENAL & ALCHEMY",
                        style: WitcherTypography.titleLarge.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Combat disciplines and technological signs mastered by Anshul of AI. Categorized by ancient Witcher schools and armor mastery tiers.",
                    style: WitcherTypography.bodyMedium.copyWith(color: WitcherColors.textMuted),
                  ),
                  const SizedBox(height: 24),

                  // Horizontal Sign Selector Pills / Cards
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(signs.length, (index) {
                        final sign = signs[index];
                        final isSelected = _selectedSignIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: _buildSignSelectorPill(sign, isSelected, index),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Selected Sign Active Showcase
                  _buildSignShowcase(selectedSign),
                  const SizedBox(height: 24),

                  // Armor Tier Hierarchy Legend
                  _buildHierarchyLegend(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignSelectorPill(SkillSignModel sign, bool isSelected, int index) {
    final color = sign.signColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => WitcherAudio.hover(),
      child: GestureDetector(
        onTap: () {
          if (_selectedSignIndex != index) {
            WitcherAudio.sign();
            setState(() => _selectedSignIndex = index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.18) : const Color(0xFF14171E),
            border: Border.all(
              color: isSelected ? color : WitcherColors.borderDark,
              width: isSelected ? 1.8 : 1.0,
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                sign.icon,
                color: isSelected ? color : WitcherColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sign.signName.toUpperCase(),
                    style: WitcherTypography.tagText.copyWith(
                      color: isSelected ? color : WitcherColors.textParchmentLight,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    sign.domainName,
                    style: WitcherTypography.bodySmall.copyWith(
                      color: isSelected
                          ? WitcherColors.textParchment
                          : WitcherColors.textMuted,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignShowcase(SkillSignModel sign) {
    final color = sign.signColor;

    return WitcherCard(
      borderColor: color,
      borderWidth: 1.5,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(sign.icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SIGN OF ${sign.signName.toUpperCase()}",
                      style: WitcherTypography.titleLarge.copyWith(
                        color: color,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sign.domainName.toUpperCase(),
                      style: WitcherTypography.subtitle.copyWith(
                        color: WitcherColors.textParchmentLight,
                        fontSize: 12,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            sign.signDescription,
            style: WitcherTypography.bodyLarge.copyWith(
              color: WitcherColors.textParchment,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: WitcherColors.borderDark, height: 1),
          const SizedBox(height: 24),

          // Skill Cards Grid
          Text(
            "ARMAMENT & PROFICIENCIES",
            style: WitcherTypography.metricLabel.copyWith(
              color: WitcherColors.goldMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 800
                  ? 3
                  : (constraints.maxWidth > 500 ? 2 : 1);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 95,
                ),
                itemCount: sign.skills.length,
                itemBuilder: (context, index) {
                  final skill = sign.skills[index];
                  return _buildSkillCard(skill, color);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(SkillItem skill, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        border: Border.all(color: WitcherColors.borderDark, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: WitcherTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: WitcherColors.textParchmentLight,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TierBadge(tier: skill.tier, compact: true),
            ],
          ),
          if (skill.note != null)
            Text(
              skill.note!,
              style: WitcherTypography.bodySmall.copyWith(
                color: WitcherColors.textMuted,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildHierarchyLegend() {
    return WitcherCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: WitcherColors.gold, size: 18),
              const SizedBox(width: 10),
              Text(
                "WITCHER ARMOR TIER HIERARCHY",
                style: WitcherTypography.titleSmall.copyWith(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildTierLegendItem(ArmorTier.grandmaster, "Highest peak proficiency & flagship systems"),
              _buildTierLegendItem(ArmorTier.mastercrafted, "Core production frameworks & backends"),
              _buildTierLegendItem(ArmorTier.superior, "Cloud, container & ecosystem support"),
              _buildTierLegendItem(ArmorTier.enhanced, "Core algorithms & foundational logic"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierLegendItem(ArmorTier tier, String description) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TierBadge(tier: tier, compact: true),
        const SizedBox(width: 8),
        Text(
          description,
          style: WitcherTypography.bodySmall.copyWith(
            color: WitcherColors.textParchment,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
