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
import '../../widgets/witcher_gold_text.dart';

class ContractsTab extends StatefulWidget {
  const ContractsTab({super.key});

  @override
  State<ContractsTab> createState() => _ContractsTabState();
}

class _ContractsTabState extends State<ContractsTab> {
  int _selectedContractIndex = 0;
  int? _lastClickedIndex;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  void _handleContractTap(int index, ContractModel contract) {
    final isAlreadySelected = _selectedContractIndex == index;
    final isSecondClick = _lastClickedIndex == index;

    if (isAlreadySelected && isSecondClick) {
      // Clicked two times -> redirect to GitHub
      WitcherAudio.seal();
      if (contract.githubUrl != null) {
        _launchUrl(contract.githubUrl!);
      }
      _lastClickedIndex = null;
    } else {
      // Clicked one time -> only select that particular card and show details
      WitcherAudio.click();
      setState(() {
        _selectedContractIndex = index;
      });
      _lastClickedIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contracts = ResumeData.contracts;
    final selectedContract = contracts[_selectedContractIndex];

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
                  // Header Banner
                  Row(
                    children: [
                      const Icon(
                        Icons.military_tech_rounded,
                        color: WitcherColors.goldBright,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      WitcherGoldText(
                        "WITCHER CONTRACT LOG",
                        style: WitcherTypography.titleLarge.copyWith(fontSize: 22),
                      ),
                      const SizedBox(width: 12),
                      const TierBadge(tier: ArmorTier.grandmaster, compact: true),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "High-priority operational contracts executed by Anshul of AI. Verified telemetry and production deployments.",
                    style: WitcherTypography.bodyMedium.copyWith(color: WitcherColors.textMuted),
                  ),
                  const SizedBox(height: 24),

                  // Main Master-Detail Layout
                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Master Contract List
                            SizedBox(
                              width: 380,
                              child: _buildContractList(contracts),
                            ),
                            const SizedBox(width: 24),
                            // Right: Detail Contract Parchment
                            Expanded(
                              child: _buildContractDetail(selectedContract),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildContractList(contracts, isHorizontal: true),
                            const SizedBox(height: 20),
                            _buildContractDetail(selectedContract),
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

  Widget _buildStatusBadge(ContractStatus status, {bool compact = false}) {
    final isCompleted = status == ContractStatus.completed;
    final color = status.color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle_outline_rounded : Icons.hourglass_top_rounded,
            size: compact ? 10 : 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: WitcherTypography.tagText.copyWith(
              color: color,
              fontSize: compact ? 9 : 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractList(List<ContractModel> contracts, {bool isHorizontal = false}) {
    if (isHorizontal) {
      return Column(
        children: List.generate(contracts.length, (index) {
          final contract = contracts[index];
          final isSelected = _selectedContractIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildContractListItem(contract, isSelected, index),
          );
        }),
      );
    }

    return Column(
      children: List.generate(contracts.length, (index) {
        final contract = contracts[index];
        final isSelected = _selectedContractIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildContractListItem(contract, isSelected, index),
        );
      }),
    );
  }

  Widget _buildContractListItem(ContractModel contract, bool isSelected, int index) {
    return WitcherCard(
      isInteractive: true,
      isSelected: isSelected,
      borderWidth: isSelected ? 1.5 : 1.0,
      padding: const EdgeInsets.all(16),
      onTap: () => _handleContractTap(index, contract),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? WitcherColors.gold.withValues(alpha: 0.2)
                  : const Color(0xFF14171E),
              border: Border.all(
                color: isSelected ? WitcherColors.goldBright : WitcherColors.borderDark,
                width: 1,
              ),
            ),
            child: Icon(
              isSelected ? Icons.gps_fixed_rounded : Icons.assignment_late_outlined,
              color: isSelected ? WitcherColors.goldBright : WitcherColors.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        contract.threatLevel.toUpperCase(),
                        style: WitcherTypography.metricLabel.copyWith(
                          color: isSelected
                              ? WitcherColors.crimsonBright
                              : WitcherColors.textMuted,
                          fontSize: 9.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _buildStatusBadge(contract.status, compact: true),
                    const SizedBox(width: 6),
                    TierBadge(tier: contract.tier, compact: true),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  contract.title,
                  style: WitcherTypography.titleSmall.copyWith(
                    color: isSelected
                        ? WitcherColors.goldBright
                        : WitcherColors.textParchmentLight,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        contract.domain,
                        style: WitcherTypography.bodySmall.copyWith(
                          color: WitcherColors.textMuted,
                          fontSize: 11.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    isSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.touch_app_rounded,
                                size: 11,
                                color: WitcherColors.goldBright,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                "Click again for GitHub",
                                style: WitcherTypography.tagText.copyWith(
                                  color: WitcherColors.goldBright,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.open_in_new_rounded,
                                size: 10,
                                color: WitcherColors.goldBright,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "1x: Select",
                                style: WitcherTypography.tagText.copyWith(
                                  color: WitcherColors.textMuted,
                                  fontSize: 9.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "• 2x: GitHub",
                                style: WitcherTypography.tagText.copyWith(
                                  color: WitcherColors.goldBright.withValues(alpha: 0.75),
                                  fontSize: 9.5,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.open_in_new_rounded,
                                size: 9,
                                color: WitcherColors.goldBright.withValues(alpha: 0.75),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractDetail(ContractModel contract) {
    return WitcherCard(
      borderColor: WitcherColors.goldBright,
      borderWidth: 1.5,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TierBadge(tier: contract.tier),
                        const SizedBox(width: 10),
                        _buildStatusBadge(contract.status),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: WitcherColors.crimson.withValues(alpha: 0.15),
                            border: Border.all(color: WitcherColors.crimsonBright.withValues(alpha: 0.6)),
                          ),
                          child: Text(
                            "THREAT: ${contract.threatLevel.toUpperCase()}",
                            style: WitcherTypography.tagText.copyWith(
                              color: WitcherColors.crimsonBright,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (contract.githubUrl != null) {
                            WitcherAudio.click();
                            _launchUrl(contract.githubUrl!);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            WitcherGoldText(
                              contract.title,
                              style: WitcherTypography.titleLarge.copyWith(fontSize: 24),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.open_in_new_rounded,
                              size: 18,
                              color: WitcherColors.goldBright,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contract.subtitle,
                      style: WitcherTypography.subtitle.copyWith(
                        color: WitcherColors.textParchmentLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: WitcherColors.borderDark, height: 1),
          const SizedBox(height: 20),

          // Objective / Description
          Text(
            "CONTRACT OBJECTIVE & BRIEF",
            style: WitcherTypography.metricLabel.copyWith(
              fontSize: 11,
              color: WitcherColors.goldMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contract.description,
            style: WitcherTypography.bodyLarge.copyWith(
              color: WitcherColors.textParchment,
              fontSize: 14.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Combat Metrics Readout Grid
          Text(
            "TACTICAL TELEMETRY & RESULTS",
            style: WitcherTypography.metricLabel.copyWith(
              fontSize: 11,
              color: WitcherColors.goldMuted,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: contract.combatMetrics.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF14171E),
                  border: Border.all(color: WitcherColors.goldMuted, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key.toUpperCase(),
                      style: WitcherTypography.metricLabel.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.value,
                      style: WitcherTypography.metricValue.copyWith(
                        fontSize: 16,
                        color: WitcherColors.goldBright,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Execution Bullets
          Text(
            "FIELD EXECUTION & ARCHITECTURE",
            style: WitcherTypography.metricLabel.copyWith(
              fontSize: 11,
              color: WitcherColors.goldMuted,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: contract.highlights.map((bullet) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.diamond_rounded,
                        size: 9,
                        color: WitcherColors.goldBright,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        bullet,
                        style: WitcherTypography.bodyMedium.copyWith(
                          color: WitcherColors.textParchment,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Runes & Arsenal (Tech Stack Badges)
          Text(
            "RUNES & ARSENAL UTILISED",
            style: WitcherTypography.metricLabel.copyWith(
              fontSize: 11,
              color: WitcherColors.goldMuted,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: contract.techStack.map((tech) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF161922),
                  border: Border.all(color: WitcherColors.borderDark),
                ),
                child: Text(
                  tech,
                  style: WitcherTypography.tagText.copyWith(
                    color: WitcherColors.goldBright,
                    fontSize: 11.5,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Action Buttons
          Row(
            children: [
              if (contract.githubUrl != null)
                RunicButton(
                  text: "Inspect Weaponry (GitHub ↗)",
                  icon: Icons.code_rounded,
                  style: RunicButtonStyle.gold,
                  onPressed: () => _launchUrl(contract.githubUrl!),
                ),
              const SizedBox(width: 14),
              RunicButton(
                text: contract.status == ContractStatus.completed
                    ? "Telemetry Verified"
                    : "Development Active",
                icon: contract.status == ContractStatus.completed
                    ? Icons.verified_rounded
                    : Icons.build_circle_rounded,
                style: RunicButtonStyle.secondary,
                onPressed: () {
                  WitcherAudio.seal();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF1B1F2A),
                      content: Text(
                        contract.status == ContractStatus.completed
                            ? "Telemetry verified by Grandmaster Witcher Anshul of AI."
                            : "Contract InfraIntel is currently under active neural development by Anshul of AI.",
                        style: WitcherTypography.bodyMedium.copyWith(
                          color: WitcherColors.goldBright,
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
