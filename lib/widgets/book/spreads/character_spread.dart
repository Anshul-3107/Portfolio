import 'package:flutter/material.dart';
import '../../../core/audio/witcher_audio.dart';
import '../../../core/constants/resume_data.dart';
import '../../../core/theme/witcher_colors.dart';
import '../../../core/theme/witcher_typography.dart';
import '../../../models/portfolio_models.dart';
import '../../leetcode_telemetry_card.dart';
import '../../tier_badge.dart';
import '../../witcher_medallion.dart';
import '../witcher_book_theme.dart';
import '../witcher_parchment_page.dart';
import '../witcher_wax_seal.dart';

class CharacterSpread extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onNavigateToContracts;
  final VoidCallback onNavigateToNoticeBoard;

  const CharacterSpread({
    super.key,
    required this.isDesktop,
    required this.onNavigateToContracts,
    required this.onNavigateToNoticeBoard,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Page: Witcher Dossier & Vitals (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isLeftPage: true,
              chapterHeader: "CHAPTER I • DOSSIER & ATTRIBUTES",
              folioNumber: "FOLIO I • THE PATH OF THE WOLF",
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildDossierLeaf(context),
              ),
            ),
          ),

          // Right Page: Lore, Disciplines & LeetCode Telemetry (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isRightPage: true,
              chapterHeader: "CHAPTER I • LORE & TELEMETRY",
              folioNumber: "FOLIO II • CODE OF THE NEURAL GRANDMASTER",
              onTurnPage: onNavigateToContracts,
              turnPageLabel: "CONTRACTS ⮞",
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildLoreLeaf(context),
              ),
            ),
          ),
        ],
      );
    } else {
      // Mobile Single Page Spread
      return WitcherParchmentPage(
        chapterHeader: "CHAPTER I • CHARACTER DOSSIER",
        folioNumber: "FOLIO I • ANSHUL OF AI",
        onTurnPage: onNavigateToContracts,
        turnPageLabel: "CONTRACTS ⮞",
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              _buildDossierLeaf(context),
              const SizedBox(height: 18),
              WitcherBookTheme.buildOrnamentalDivider(symbol: '⚔', height: 20),
              const SizedBox(height: 18),
              _buildLoreLeaf(context),
            ],
          ),
        ),
      );
    }
  }

  // Left Page Content: Avatar Crest, Medallion & Witcher Attributes
  Widget _buildDossierLeaf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Witcher Crest Avatar with glowing Wolf Medallion
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 136,
              height: 136,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: WitcherColors.inkGold.withValues(alpha: 0.45),
                  width: 1.5,
                ),
              ),
            ),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E150E), // Obsidian / cast-iron circular coin plate
                border: Border.all(color: const Color(0xFF8F7026), width: 2.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x35000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 106,
                    height: 106,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x55C59B3C), width: 1.0),
                    ),
                  ),
                  const Center(
                    child: WitcherMedallion(size: 82, glowing: true),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Character Name & Title
        Text(
          ResumeData.name.toUpperCase(),
          style: WitcherTypography.parchmentHeading.copyWith(
            fontSize: 20,
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          ResumeData.witcherTitle.toUpperCase(),
          style: WitcherTypography.parchmentSubheading.copyWith(
            fontSize: 12.5,
            color: WitcherColors.inkCrimson,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "${ResumeData.rank} • ${ResumeData.witcherSchool}",
          textAlign: TextAlign.center,
          style: WitcherTypography.parchmentBody.copyWith(
            fontSize: 11,
            color: WitcherColors.inkMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),

        // Mutagen & Armor Tier Badges
        const Wrap(
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            TierBadge(tier: ArmorTier.grandmaster, compact: true),
            _ParchmentSealBadge(
              label: "AWS ML ENGINEER",
              icon: Icons.verified_rounded,
              color: WitcherColors.inkGold,
            ),
            _ParchmentSealBadge(
              label: "VIT VELLORE",
              icon: Icons.school_rounded,
              color: WitcherColors.inkCrimson,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Vitae & Witcher Attributes
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: WitcherBookTheme.cardInsetDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_rounded, size: 14, color: WitcherColors.inkCrimson),
                  const SizedBox(width: 8),
                  Text(
                    "WITCHER ATTRIBUTES & VITALITY",
                    style: WitcherTypography.parchmentFolio.copyWith(
                      color: WitcherColors.inkCrimson,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildManuscriptStatBar("Vigor (Python & Model Architectures)", 0.96, "96%"),
              _buildManuscriptStatBar("Quen Shield (Cloud Security & AWS)", 0.92, "92%"),
              _buildManuscriptStatBar("Reflexes (Django REST & Scalable APIs)", 0.88, "88%"),
              _buildManuscriptStatBar("Sign Mastery (Flutter Cross-Platform)", 0.90, "90%"),
              _buildManuscriptStatBar("Toxic Tolerance (Deep Learning Warfare)", 0.85, "85%"),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Action Wax Seals
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WitcherWaxSeal(
              size: 46,
              icon: Icons.assignment_rounded,
              label: "Contracts",
              tooltip: "Turn to Chapter II: Contracts Log",
              onTap: onNavigateToContracts,
            ),
            WitcherWaxSeal(
              size: 46,
              icon: Icons.campaign_rounded,
              label: "Notices",
              tooltip: "Turn to Chapter IV: Village Notice Board",
              onTap: onNavigateToNoticeBoard,
            ),
            WitcherWaxSeal(
              size: 46,
              icon: Icons.download_rounded,
              label: "Dossier",
              tooltip: "Download Dual Resume & AWS Certification Dossier",
              onTap: () {
                WitcherAudio.downloadResume();
              },
            ),
          ],
        ),
      ],
    );
  }

  // Right Page Content: Lore Biography, Disciplines & Live LeetCode Card
  Widget _buildLoreLeaf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drop Cap Lore Narrative
        WitcherBookTheme.buildDropCap("A", "nshul of the Neural School"),
        const SizedBox(height: 10),
        Text(
          ResumeData.bio,
          style: WitcherTypography.parchmentBody.copyWith(
            height: 1.6,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),

        // Witcher Motto Inscribed Quote Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFBAA982),
            borderRadius: BorderRadius.circular(3),
            border: Border(
              left: BorderSide(color: const Color(0xFF6B1914), width: 3.5),
            ),
          ),
          child: Text(
            ResumeData.witcherMotto,
            style: TextStyle(
              fontFamily: 'Marcellus',
              fontStyle: FontStyle.italic,
              fontSize: 12.5,
              height: 1.5,
              color: WitcherColors.inkPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Primary Combat Disciplines
        Text(
          "CORE COMBAT DISCIPLINES",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: const [
            _ManuscriptTag("Machine Learning", WitcherColors.signIgni),
            _ManuscriptTag("Computer Vision (CNN)", WitcherColors.signIgni),
            _ManuscriptTag("Anomaly Detection", WitcherColors.signIgni),
            _ManuscriptTag("AWS Cloud (S3, EC2)", WitcherColors.signQuen),
            _ManuscriptTag("Docker Containers", WitcherColors.signQuen),
            _ManuscriptTag("Django REST APIs", WitcherColors.signAxii),
            _ManuscriptTag("FastAPI Services", WitcherColors.signAxii),
            _ManuscriptTag("Flutter UI", WitcherColors.signAard),
            _ManuscriptTag("PostgreSQL", WitcherColors.signYrden),
          ],
        ),
        const SizedBox(height: 18),

        // Live LeetCode Telemetry Card
        const LeetCodeTelemetryCard(),
      ],
    );
  }

  Widget _buildManuscriptStatBar(String label, double progress, String valueText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: WitcherTypography.parchmentBody.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: WitcherColors.inkPrimary,
                ),
              ),
              Text(
                valueText,
                style: WitcherTypography.parchmentFolio.copyWith(
                  fontSize: 10.5,
                  color: WitcherColors.inkCrimson,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Container(
            height: 7,
            decoration: BoxDecoration(
              color: const Color(0xFFB4A179),
              borderRadius: BorderRadius.circular(1.5),
              border: Border.all(color: const Color(0xFFA6936C), width: 0.8),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B1812), // Deep crimson
                      Color(0xFFC7281E), // Bright crimson
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParchmentSealBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _ParchmentSealBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFBAA982),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ManuscriptTag extends StatelessWidget {
  final String label;
  final Color signColor;

  const _ManuscriptTag(this.label, this.signColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFBAA982),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: signColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: signColor,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: WitcherColors.inkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
