import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/audio/witcher_audio.dart';
import '../../core/constants/resume_data.dart';
import '../../core/theme/witcher_colors.dart';
import '../../core/theme/witcher_typography.dart';
import '../../models/portfolio_models.dart';
import '../../widgets/runic_button.dart';
import '../../widgets/tier_badge.dart';
import '../../widgets/witcher_card.dart';
import '../../widgets/witcher_divider.dart';
import '../../widgets/witcher_gold_text.dart';

class NoticeBoardTab extends StatelessWidget {
  const NoticeBoardTab({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  Future<void> _sendEmail() async {
    await _launchUrl(ResumeData.gmailComposeUrl);
  }

  Future<void> _openWhatsApp() async {
    await _launchUrl(ResumeData.whatsAppUrl);
  }

  @override
  Widget build(BuildContext context) {
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
                  // Banner
                  Row(
                    children: [
                      const Icon(
                        Icons.campaign_rounded,
                        color: WitcherColors.goldBright,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      WitcherGoldText(
                        "THE VILLAGE NOTICE BOARD",
                        style: WitcherTypography.titleLarge.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Official contracts, guild alliances, and comms dispatch for Anshul of AI.",
                    style: WitcherTypography.bodyMedium.copyWith(color: WitcherColors.textMuted),
                  ),
                  const SizedBox(height: 24),

                  // Notice Board Grid
                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: _buildBountyNotice(context)),
                            const SizedBox(width: 24),
                            Expanded(flex: 5, child: _buildDispatchColumn(context)),
                          ],
                        )
                      : Column(
                          children: [
                            _buildBountyNotice(context),
                            const SizedBox(height: 24),
                            _buildDispatchColumn(context),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBountyNotice(BuildContext context) {
    return WitcherCard(
      borderColor: WitcherColors.goldBright,
      borderWidth: 1.5,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BOUNTY OFFER & RECRUITMENT",
                style: WitcherTypography.metricLabel.copyWith(
                  color: WitcherColors.goldBright,
                  fontSize: 12,
                ),
              ),
              const TierBadge(tier: ArmorTier.grandmaster, compact: true),
            ],
          ),
          const SizedBox(height: 12),
          WitcherGoldText(
            "LOOKING FOR AN AI/ML WITCHER?",
            style: WitcherTypography.titleLarge.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            "Anshul of AI is actively open for Summer Internships, Machine Learning Engineering contracts, and Full-Stack AI roles.",
            style: WitcherTypography.subtitle.copyWith(
              color: WitcherColors.textParchmentLight,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 16),
          const WitcherDivider(symbol: '📜', height: 22),
          const SizedBox(height: 16),

          Text(
            "TERMS OF EMPLOYMENT & EXPERTISE",
            style: WitcherTypography.metricLabel.copyWith(
              color: WitcherColors.goldMuted,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildBulletItem(
            "Autonomous End-to-End Delivery: From training PyTorch/XGBoost models to containerizing in Docker and deploying on AWS.",
          ),
          _buildBulletItem(
            "Production Backends: Clean, documented, high-throughput APIs using FastAPI & Django REST Framework.",
          ),
          _buildBulletItem(
            "Cross-Platform Frontends: High-speed Flutter client interfaces for mobile and web with real-time analytics.",
          ),
          _buildBulletItem(
            "Location Flexibility: Available for remote, hybrid, or on-site roles worldwide.",
          ),
          const SizedBox(height: 24),

          // Pinned Resume Download Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF14171E),
              border: Border.all(color: WitcherColors.gold, width: 1.2),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: WitcherColors.gold.withValues(alpha: 0.15),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: WitcherColors.crimson.withValues(alpha: 0.2),
                    border: Border.all(color: WitcherColors.crimsonBright, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.history_edu_rounded,
                    color: WitcherColors.goldBright,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ROYAL CHARTER / DOSSIER",
                        style: WitcherTypography.metricLabel.copyWith(
                          color: WitcherColors.goldMuted,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Official Resume & AWS Credential (PDFs)",
                        style: WitcherTypography.titleSmall.copyWith(
                          color: WitcherColors.goldBright,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Downloads both your verified Resume and AWS Certified ML Engineer credential.",
                        style: WitcherTypography.bodySmall.copyWith(
                          color: WitcherColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                RunicButton(
                  text: "Claim Dossier",
                  icon: Icons.download_rounded,
                  style: RunicButtonStyle.gold,
                  isCompact: true,
                  onPressed: WitcherAudio.downloadResume,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDispatchColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Comms Dispatch Card
        WitcherCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DISPATCH COMMS VIA RAVEN",
                style: WitcherTypography.metricLabel.copyWith(
                  color: WitcherColors.goldBright,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              _buildContactRow(
                icon: Icons.alternate_email_rounded,
                title: "Raven Post (Email)",
                value: ResumeData.email,
                actionLabel: "Send Raven",
                onTap: _sendEmail,
              ),
              const SizedBox(height: 14),
              _buildContactRow(
                icon: Icons.chat_rounded,
                title: "Direct Signal (WhatsApp)",
                value: ResumeData.phone,
                actionLabel: "Open WhatsApp",
                onTap: _openWhatsApp,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Guild Alliances (LinkedIn, GitHub, LeetCode)
        WitcherCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "GUILD ALLIANCES & ARCHIVES",
                style: WitcherTypography.metricLabel.copyWith(
                  color: WitcherColors.goldBright,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 16),
              _buildGuildTile(
                icon: Icons.business_center_rounded,
                name: "LinkedIn Guild",
                handle: "/in/anshularohi/",
                url: ResumeData.linkedInUrl,
              ),
              const SizedBox(height: 12),
              _buildGuildTile(
                icon: Icons.terminal_rounded,
                name: "GitHub Repository",
                handle: "@Anshul-3107",
                url: ResumeData.gitHubUrl,
              ),
              const SizedBox(height: 12),
              _buildGuildTile(
                icon: Icons.code_rounded,
                name: "LeetCode Arena",
                handle: "/u/anshularohi",
                url: ResumeData.leetCodeUrl,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String value,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF14171E),
        border: Border.all(color: WitcherColors.borderDark),
      ),
      child: Row(
        children: [
          Icon(icon, color: WitcherColors.goldBright, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: WitcherTypography.metricLabel.copyWith(fontSize: 9.5),
                ),
                Text(
                  value,
                  style: WitcherTypography.bodyMedium.copyWith(
                    color: WitcherColors.textParchmentLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          RunicButton(
            text: actionLabel,
            style: RunicButtonStyle.secondary,
            isCompact: true,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildGuildTile({
    required IconData icon,
    required String name,
    required String handle,
    required String url,
  }) {
    return WitcherCard(
      isInteractive: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: () {
        WitcherAudio.click();
        _launchUrl(url);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: WitcherColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: WitcherColors.goldMuted),
            ),
            child: Icon(icon, color: WitcherColors.goldBright, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: WitcherTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: WitcherColors.textParchmentLight,
                    fontSize: 13.5,
                  ),
                ),
                Text(
                  handle,
                  style: WitcherTypography.bodySmall.copyWith(
                    color: WitcherColors.goldMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            color: WitcherColors.goldMuted,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(
              Icons.diamond_rounded,
              size: 8,
              color: WitcherColors.goldBright,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: WitcherTypography.bodyMedium.copyWith(
                color: WitcherColors.textParchment,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
