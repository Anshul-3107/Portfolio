import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/resume_data.dart';
import '../../core/theme/witcher_colors.dart';
import '../../core/theme/witcher_typography.dart';
import '../../models/portfolio_models.dart';
import '../../widgets/tier_badge.dart';
import '../../widgets/witcher_card.dart';

class GlossaryTab extends StatelessWidget {
  const GlossaryTab({super.key});

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
                  // Title banner
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        color: WitcherColors.goldBright,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "GLOSSARY & CHRONICLES",
                        style: WitcherTypography.titleLarge.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Academic lineages, trial chronicles, and official accreditations of Anshul of AI.",
                    style: WitcherTypography.bodyMedium.copyWith(color: WitcherColors.textMuted),
                  ),
                  const SizedBox(height: 24),

                  // Education and Certifications split
                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildEducationSection(context)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildCertificationsSection(context)),
                          ],
                        )
                      : Column(
                          children: [
                            _buildEducationSection(context),
                            const SizedBox(height: 24),
                            _buildCertificationsSection(context),
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

  Widget _buildEducationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.school_rounded, color: WitcherColors.gold, size: 20),
            const SizedBox(width: 10),
            Text(
              "ACADEMIC BASTIONS",
              style: WitcherTypography.titleMedium.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...ResumeData.education.map((edu) {
          final isVit = edu.institution.contains("Vellore");

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: WitcherCard(
              borderColor: isVit ? WitcherColors.goldBright : WitcherColors.borderDark,
              borderWidth: isVit ? 1.5 : 1.0,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: WitcherColors.gold.withValues(alpha: 0.1),
                          border: Border.all(color: WitcherColors.goldMuted),
                        ),
                        child: Text(
                          edu.period,
                          style: WitcherTypography.tagText.copyWith(
                            color: WitcherColors.goldBright,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14171E),
                          border: Border.all(color: WitcherColors.borderDark),
                        ),
                        child: Text(
                          edu.score,
                          style: WitcherTypography.metricValue.copyWith(
                            fontSize: 13,
                            color: isVit ? WitcherColors.goldBright : WitcherColors.textParchmentLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    edu.institution,
                    style: WitcherTypography.titleSmall.copyWith(
                      color: isVit ? WitcherColors.goldBright : WitcherColors.textParchmentLight,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    edu.degree,
                    style: WitcherTypography.bodyMedium.copyWith(
                      color: WitcherColors.textParchmentLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    edu.details,
                    style: WitcherTypography.bodySmall.copyWith(
                      color: WitcherColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCertificationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.workspace_premium_rounded, color: WitcherColors.gold, size: 20),
            const SizedBox(width: 10),
            Text(
              "OFFICIAL ACCREDITATIONS & TROPHIES",
              style: WitcherTypography.titleMedium.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...ResumeData.certifications.map((cert) {
          final isAws = cert.tier == ArmorTier.grandmaster;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: WitcherCard(
              borderColor: isAws ? WitcherColors.goldBright : WitcherColors.borderDark,
              borderWidth: isAws ? 1.5 : 1.0,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TierBadge(tier: cert.tier),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14171E),
                          border: Border.all(color: WitcherColors.borderDark),
                        ),
                        child: Text(
                          cert.date,
                          style: WitcherTypography.tagText.copyWith(
                            color: WitcherColors.textMuted,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cert.name,
                    style: WitcherTypography.titleSmall.copyWith(
                      color: isAws ? WitcherColors.goldBright : WitcherColors.textParchmentLight,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cert.issuer.toUpperCase(),
                    style: WitcherTypography.metricLabel.copyWith(
                      color: WitcherColors.goldMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cert.description,
                    style: WitcherTypography.bodySmall.copyWith(
                      color: WitcherColors.textParchment,
                      height: 1.5,
                    ),
                  ),
                  if (cert.credentialId != null) ...[
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final uri = Uri.parse("https://aws.amazon.com/verification");
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14171E),
                          border: Border.all(color: WitcherColors.goldBright.withValues(alpha: 0.6)),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_user_rounded, size: 14, color: WitcherColors.goldBright),
                            const SizedBox(width: 8),
                            Text(
                              "VALIDATION: ${cert.credentialId}",
                              style: WitcherTypography.tagText.copyWith(
                                color: WitcherColors.goldBright,
                                fontSize: 11,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.open_in_new_rounded, size: 12, color: WitcherColors.goldMuted),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
