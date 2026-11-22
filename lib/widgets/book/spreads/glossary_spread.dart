import 'package:flutter/material.dart';
import '../../../core/audio/witcher_audio.dart';
import '../../../core/constants/resume_data.dart';
import '../../../core/theme/witcher_colors.dart';
import '../../../core/theme/witcher_typography.dart';
import '../../tier_badge.dart';
import '../witcher_book_theme.dart';
import '../witcher_parchment_page.dart';
import '../witcher_wax_seal.dart';

class GlossarySpread extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onTurnPrevious;
  final VoidCallback onTurnToBeginning;

  const GlossarySpread({
    super.key,
    required this.isDesktop,
    required this.onTurnPrevious,
    required this.onTurnToBeginning,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Page: Academic Bastions (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isLeftPage: true,
              chapterHeader: "CHAPTER V • ACADEMIC BASTIONS",
              folioNumber: "FOLIO IX • LINEAGES OF LEARNING",
              onTurnPage: onTurnPrevious,
              turnPageLabel: "⮜ NOTICES",
              isTurnBackwards: true,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildAcademicLeaf(context),
              ),
            ),
          ),

          // Right Page: Official Accreditations & Trophies (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isRightPage: true,
              chapterHeader: "CHAPTER V • ACCREDITATIONS & HONORS",
              folioNumber: "FOLIO X • SEALS OF RECOGNITION",
              onTurnPage: onTurnToBeginning,
              turnPageLabel: "CHAPTER I ⮞",
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildAccreditationsLeaf(context),
              ),
            ),
          ),
        ],
      );
    } else {
      // Mobile Single Page Spread
      return WitcherParchmentPage(
        chapterHeader: "CHAPTER V • GLOSSARY & CHRONICLES",
        folioNumber: "FOLIO IX • CHRONICLES",
        onTurnPage: onTurnToBeginning,
        turnPageLabel: "CHAPTER I ⮞",
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              _buildAcademicLeaf(context),
              const SizedBox(height: 18),
              WitcherBookTheme.buildOrnamentalDivider(symbol: '📜', height: 20),
              const SizedBox(height: 18),
              _buildAccreditationsLeaf(context),
            ],
          ),
        ),
      );
    }
  }

  // Left Page: Education Lineage
  Widget _buildAcademicLeaf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WitcherBookTheme.buildDropCap("A", "cademic Lineages & Bastions"),
        const SizedBox(height: 8),
        Text(
          "Rigorous foundational training and computational alchemy forged across premier institutions of higher learning.",
          style: WitcherTypography.parchmentBody.copyWith(
            fontSize: 12.5,
            color: WitcherColors.inkMuted,
          ),
        ),
        const SizedBox(height: 14),

        // VIT Vellore Bastion
        ...ResumeData.education.map((edu) {
          final isVit = edu.institution.contains("Vellore");

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: WitcherBookTheme.cardInsetDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        edu.institution.toUpperCase(),
                        style: WitcherTypography.parchmentHeading.copyWith(
                          fontSize: 13.5,
                          color: isVit ? WitcherColors.inkCrimson : WitcherColors.inkPrimary,
                        ),
                      ),
                    ),
                    Text(
                      edu.period,
                      style: WitcherTypography.parchmentFolio.copyWith(
                        fontSize: 10,
                        color: WitcherColors.inkGold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  edu.degree,
                  style: WitcherTypography.parchmentSubheading.copyWith(
                    fontSize: 12,
                    color: WitcherColors.inkPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  edu.details,
                  style: WitcherTypography.parchmentBody.copyWith(
                    fontSize: 11.5,
                    height: 1.5,
                  ),
                ),
                if (isVit) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: const [
                      _EducationPill("Neural Networks"),
                      _EducationPill("Deep Learning"),
                      _EducationPill("Distributed Systems"),
                      _EducationPill("Data Structures"),
                    ],
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  // Right Page: Certifications & Honors
  Widget _buildAccreditationsLeaf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "OFFICIAL GUILD ACCREDITATIONS",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),

        // AWS Certified ML Engineer Card
        ...ResumeData.certifications.map((cert) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFCFBE9B),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: const Color(0xFF7A5812), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x20000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cert.name.toUpperCase(),
                        style: WitcherTypography.parchmentHeading.copyWith(
                          fontSize: 13.5,
                          color: WitcherColors.inkCrimson,
                        ),
                      ),
                    ),
                    TierBadge(tier: cert.tier, compact: true),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  cert.issuer,
                  style: WitcherTypography.parchmentSubheading.copyWith(
                    fontSize: 11.5,
                    color: WitcherColors.inkGold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cert.description,
                  style: WitcherTypography.parchmentBody.copyWith(
                    fontSize: 11.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    WitcherWaxSeal(
                      size: 40,
                      icon: Icons.verified_rounded,
                      tooltip: "Download Verified AWS Certificate",
                      onTap: () {
                        WitcherAudio.downloadResume();
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STATUS: VERIFIED ON THE PATH",
                            style: WitcherTypography.parchmentFolio.copyWith(
                              fontSize: 9.5,
                              color: const Color(0xFF1E6B38),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (cert.credentialId != null)
                            Text(
                              "CREDENTIAL: ${cert.credentialId}",
                              style: WitcherTypography.parchmentBody.copyWith(
                                fontSize: 10,
                                color: WitcherColors.inkMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 14),

        // Trophies & Milestones
        Text(
          "TROPHIES & BATTLE HONORS",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: WitcherBookTheme.cardInsetDecoration(),
          child: Column(
            children: const [
              _TrophyRow(
                icon: Icons.military_tech_rounded,
                title: "Grandmaster Machine Learning Engineer",
                desc: "Official Associate certification from Amazon Web Services (AWS)",
              ),
              SizedBox(height: 8),
              _TrophyRow(
                icon: Icons.code_rounded,
                title: "LeetCode 122+ Problems Mastered",
                desc: "Active algorithmic practitioner: Easy 52, Medium 68, Hard 2",
              ),
              SizedBox(height: 8),
              _TrophyRow(
                icon: Icons.hub_rounded,
                title: "Full-Stack AI Architecture Master",
                desc: "FraudLens & Leaf Compass production deployments",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EducationPill extends StatelessWidget {
  final String label;

  const _EducationPill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFC7B58E),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFC7B188), width: 0.8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: WitcherColors.inkPrimary,
        ),
      ),
    );
  }
}

class _TrophyRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _TrophyRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: WitcherColors.inkGold),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: WitcherTypography.parchmentHeading.copyWith(
                  fontSize: 12.5,
                  color: WitcherColors.inkPrimary,
                ),
              ),
              Text(
                desc,
                style: WitcherTypography.parchmentBody.copyWith(
                  fontSize: 11,
                  color: WitcherColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
