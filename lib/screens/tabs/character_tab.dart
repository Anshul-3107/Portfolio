import 'package:flutter/material.dart';
import '../../core/audio/witcher_audio.dart';
import '../../core/constants/resume_data.dart';
import '../../core/theme/witcher_colors.dart';
import '../../core/theme/witcher_typography.dart';
import '../../models/portfolio_models.dart';
import '../../widgets/runic_button.dart';
import '../../widgets/stat_bar.dart';
import '../../widgets/tier_badge.dart';
import '../../widgets/witcher_card.dart';
import '../../widgets/witcher_medallion.dart';

class CharacterTab extends StatelessWidget {
  final VoidCallback onNavigateToContracts;
  final VoidCallback onNavigateToNoticeBoard;

  const CharacterTab({
    super.key,
    required this.onNavigateToContracts,
    required this.onNavigateToNoticeBoard,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 16,
            vertical: 24,
          ),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _buildDossierColumn(context)),
                        const SizedBox(width: 24),
                        Expanded(flex: 6, child: _buildLoreColumn(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildDossierColumn(context),
                        const SizedBox(height: 24),
                        _buildLoreColumn(context),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDossierColumn(BuildContext context) {
    return WitcherCard(
      borderColor: WitcherColors.goldBright,
      borderWidth: 1.5,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Medallion & Crest Avatar
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: WitcherColors.goldBright, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: WitcherColors.gold.withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF262C38),
                      WitcherColors.background,
                    ],
                  ),
                ),
              ),
              const WitcherMedallion(size: 85, glowing: true),
            ],
          ),
          const SizedBox(height: 16),

          // Name and Moniker
          Text(
            ResumeData.witcherTitle.toUpperCase(),
            style: WitcherTypography.titleLarge.copyWith(
              fontSize: 24,
              letterSpacing: 2.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "ANSHUL AROHI",
            style: WitcherTypography.titleSmall.copyWith(
              color: WitcherColors.textParchmentLight,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 12),

          // Armor Tier Badge
          const TierBadge(tier: ArmorTier.grandmaster),
          const SizedBox(height: 8),

          Text(
            ResumeData.rank.toUpperCase(),
            style: WitcherTypography.tagText.copyWith(
              color: WitcherColors.gold,
              fontSize: 11.5,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 20),

          const Divider(color: WitcherColors.borderDark, height: 1),
          const SizedBox(height: 20),

          // Equipped Greater Mutagen Slot (AWS ML Engineer)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF14171E),
              border: Border.all(color: WitcherColors.gold, width: 1),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: WitcherColors.gold.withValues(alpha: 0.15),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: WitcherColors.gold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: WitcherColors.goldBright, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.military_tech_rounded,
                    color: WitcherColors.goldBright,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EQUIPPED GREATER MUTAGEN",
                        style: WitcherTypography.metricLabel.copyWith(
                          color: WitcherColors.goldMuted,
                          fontSize: 9.5,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "AWS Certified Machine Learning Engineer",
                        style: WitcherTypography.bodyMedium.copyWith(
                          color: WitcherColors.goldBright,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      Text(
                        "Associate Credential",
                        style: WitcherTypography.bodySmall.copyWith(
                          color: WitcherColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Witcher Combat Telemetry / Attribute Meters
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "COMBAT & COMPUTATION ATTRIBUTES",
              style: WitcherTypography.titleSmall.copyWith(
                fontSize: 13,
                letterSpacing: 1.8,
                color: WitcherColors.textParchmentLight,
              ),
            ),
          ),
          const SizedBox(height: 12),

          const StatBar(
            label: "Model Precision & Recall",
            value: 0.96,
            barColor: WitcherColors.crimsonBright,
            icon: Icons.track_changes_rounded,
          ),
          const StatBar(
            label: "Neural Architecture & Vision",
            value: 0.92,
            barColor: WitcherColors.goldBright,
            icon: Icons.remove_red_eye_rounded,
          ),
          const StatBar(
            label: "Backend & REST Scalability",
            value: 0.88,
            barColor: WitcherColors.signAxii,
            icon: Icons.dns_rounded,
          ),
          const StatBar(
            label: "Cross-Platform Interface (Flutter)",
            value: 0.90,
            barColor: WitcherColors.signAard,
            icon: Icons.phone_android_rounded,
          ),
          const StatBar(
            label: "Cloud & Container Warfare",
            value: 0.85,
            barColor: WitcherColors.signQuen,
            icon: Icons.cloud_done_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildLoreColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Lore Parchment
        WitcherCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_stories_rounded,
                    color: WitcherColors.gold,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "CHRONICLES OF THE NEURAL WOLF",
                    style: WitcherTypography.titleMedium.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                ResumeData.witcherMotto,
                style: WitcherTypography.quoteText.copyWith(fontSize: 14.5),
              ),
              const SizedBox(height: 16),
              Text(
                ResumeData.bio,
                style: WitcherTypography.bodyLarge,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  _buildTag("B.Tech CSE (AI & ML)"),
                  _buildTag("VIT Vellore 2023–2027"),
                  _buildTag("AWS Certified ML"),
                  _buildTag("End-to-End Architect"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Core Disciplines Grid
        WitcherCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.military_tech_rounded,
                    color: WitcherColors.gold,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "MASTERED COMBAT DISCIPLINES",
                    style: WitcherTypography.titleMedium.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildDisciplineTile(
                icon: Icons.biotech_rounded,
                color: WitcherColors.signIgni,
                title: "Deep Learning & Pattern Recognition",
                desc:
                    "Custom CNNs, YOLO object detection, isolation forests, gradient boosted ensembles (XGBoost), and transformer architectures.",
              ),
              const SizedBox(height: 14),
              _buildDisciplineTile(
                icon: Icons.alt_route_rounded,
                color: WitcherColors.signAxii,
                title: "Resilient API & Microservice Engineering",
                desc:
                    "Production-ready Django REST Framework and high-throughput asynchronous FastAPI backends with PostgreSQL persistence.",
              ),
              const SizedBox(height: 14),
              _buildDisciplineTile(
                icon: Icons.developer_mode_rounded,
                color: WitcherColors.signAard,
                title: "Cross-Platform Client Engineering (Flutter)",
                desc:
                    "Responsive, state-managed applications delivering instant real-time data insights and responsive user interactions on Mobile and Web.",
              ),
              const SizedBox(height: 14),
              _buildDisciplineTile(
                icon: Icons.cloud_sync_rounded,
                color: WitcherColors.signQuen,
                title: "Production Deployment & Cloud Mastery",
                desc:
                    "AWS cloud infrastructure, multi-stage Docker containerization, Git team collaboration, and Hugging Face pipelines.",
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Quick Navigation Actions
        Row(
          children: [
            Expanded(
              child: RunicButton(
                text: "Inspect Contracts",
                icon: Icons.assignment_rounded,
                style: RunicButtonStyle.gold,
                onPressed: () {
                  WitcherAudio.click();
                  onNavigateToContracts();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: RunicButton(
                text: "Consult Notice Board",
                icon: Icons.campaign_rounded,
                style: RunicButtonStyle.secondary,
                onPressed: () {
                  WitcherAudio.click();
                  onNavigateToNoticeBoard();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDisciplineTile({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: WitcherTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: WitcherColors.textParchmentLight,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: WitcherTypography.bodySmall.copyWith(
                  color: WitcherColors.textParchment,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: WitcherColors.surfaceCard,
        border: Border.all(color: WitcherColors.borderDark),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: WitcherTypography.tagText.copyWith(
          color: WitcherColors.goldBright,
          fontSize: 11,
        ),
      ),
    );
  }
}
