import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/audio/witcher_audio.dart';
import '../../../core/constants/resume_data.dart';
import '../../../core/theme/witcher_colors.dart';
import '../../../core/theme/witcher_typography.dart';
import '../../../models/portfolio_models.dart';
import '../../tier_badge.dart';
import '../witcher_book_theme.dart';
import '../witcher_parchment_page.dart';
import '../witcher_wax_seal.dart';

class ContractsSpread extends StatefulWidget {
  final bool isDesktop;
  final VoidCallback onTurnPrevious;
  final VoidCallback onTurnNext;

  const ContractsSpread({
    super.key,
    required this.isDesktop,
    required this.onTurnPrevious,
    required this.onTurnNext,
  });

  @override
  State<ContractsSpread> createState() => _ContractsSpreadState();
}

class _ContractsSpreadState extends State<ContractsSpread> {
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
      // Clicked one time -> select that contract and reveal details
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

    if (widget.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Page: Master Contracts Registry List (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isLeftPage: true,
              chapterHeader: "CHAPTER II • WITCHER CONTRACT LOG",
              folioNumber: "FOLIO III • THE MASTER'S LOGBOOK",
              onTurnPage: widget.onTurnPrevious,
              turnPageLabel: "⮜ CHARACTER",
              isTurnBackwards: true,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildContractsListLeaf(contracts),
              ),
            ),
          ),

          // Right Page: Tactical Contract Telemetry (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isRightPage: true,
              chapterHeader: "CHAPTER II • TACTICAL TELEMETRY",
              folioNumber: "FOLIO IV • CODEX DEPLOYMENTS",
              onTurnPage: widget.onTurnNext,
              turnPageLabel: "SIGNS & ARSENAL ⮞",
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildTelemetryLeaf(selectedContract),
              ),
            ),
          ),
        ],
      );
    } else {
      // Mobile Single Page Spread
      return WitcherParchmentPage(
        chapterHeader: "CHAPTER II • CONTRACTS & TELEMETRY",
        folioNumber: "FOLIO III • BOUNTY LOG",
        onTurnPage: widget.onTurnNext,
        turnPageLabel: "SIGNS & ARSENAL ⮞",
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              _buildContractsListLeaf(contracts),
              const SizedBox(height: 18),
              WitcherBookTheme.buildOrnamentalDivider(symbol: '⚔', height: 20),
              const SizedBox(height: 18),
              _buildTelemetryLeaf(selectedContract),
            ],
          ),
        ),
      );
    }
  }

  // Left Page: List of All Witcher Contracts
  Widget _buildContractsListLeaf(List<ContractModel> contracts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WitcherBookTheme.buildDropCap("O", "fficial Guild Registry"),
        const SizedBox(height: 8),
        Text(
          "Select a parchment to study tactical telemetry. Tap twice or press the red wax seal to inspect the source codex on GitHub.",
          style: WitcherTypography.parchmentBody.copyWith(
            fontSize: 12.5,
            color: WitcherColors.inkMuted,
          ),
        ),
        const SizedBox(height: 14),

        // Contracts Cards
        ...List.generate(contracts.length, (index) {
          final contract = contracts[index];
          final isSelected = _selectedContractIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildContractCard(contract, isSelected, index),
          );
        }),
      ],
    );
  }

  Widget _buildContractCard(ContractModel contract, bool isSelected, int index) {
    return _InteractiveContractCard(
      contract: contract,
      isSelected: isSelected,
      onTap: () => _handleContractTap(index, contract),
    );
  }

  // Right Page: Tactical Dossier of the Selected Contract
  Widget _buildTelemetryLeaf(ContractModel contract) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Tier
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contract.title.toUpperCase(),
                    style: WitcherTypography.parchmentHeading.copyWith(
                      fontSize: 18,
                      color: WitcherColors.inkCrimson,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    contract.subtitle,
                    style: WitcherTypography.parchmentSubheading.copyWith(
                      fontSize: 12.5,
                      color: WitcherColors.inkGold,
                    ),
                  ),
                ],
              ),
            ),
            TierBadge(tier: contract.tier, compact: true),
          ],
        ),
        const SizedBox(height: 10),
        WitcherBookTheme.buildOrnamentalDivider(symbol: '❖', height: 14),
        const SizedBox(height: 8),

        // Combat Brief Description
        Text(
          contract.description,
          style: WitcherTypography.parchmentBody.copyWith(height: 1.55),
        ),
        const SizedBox(height: 14),

        // Tactical Verified Combat Metrics Grid
        if (contract.combatMetrics.isNotEmpty) ...[
          Text(
            "VERIFIED COMBAT METRICS",
            style: WitcherTypography.parchmentFolio.copyWith(
              color: WitcherColors.inkGold,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: WitcherBookTheme.cardInsetDecoration(),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: contract.combatMetrics.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key.toUpperCase(),
                      style: WitcherTypography.parchmentFolio.copyWith(
                        fontSize: 9.5,
                        color: WitcherColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.value,
                      style: WitcherTypography.parchmentHeading.copyWith(
                        fontSize: 14,
                        color: WitcherColors.inkCrimson,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Operational Execution Highlights
        Text(
          "OPERATIONAL HIGHLIGHTS",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        ...contract.highlights.map((highlight) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("❖ ", style: TextStyle(color: WitcherColors.inkCrimson, fontSize: 10)),
                Expanded(
                  child: Text(
                    highlight,
                    style: WitcherTypography.parchmentBody.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 14),

        // Tech Runes (Tech Stack)
        Text(
          "RUNIC ARSENAL (TECH STACK)",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: contract.techStack.map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFBAA982),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: const Color(0xFFA6936C), width: 1),
              ),
              child: Text(
                tech,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: WitcherColors.inkPrimary,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // GitHub Wax Seal Dispatch Button
        if (contract.githubUrl != null)
          Center(
            child: WitcherWaxSeal(
              size: 56,
              icon: Icons.code_rounded,
              label: "INSPECT GITHUB REPOSITORY",
              tooltip: "Open ${contract.title} on GitHub",
              onTap: () {
                _launchUrl(contract.githubUrl!);
              },
            ),
          ),
      ],
    );
  }
}

class _InteractiveContractCard extends StatefulWidget {
  final ContractModel contract;
  final bool isSelected;
  final VoidCallback onTap;

  const _InteractiveContractCard({
    required this.contract,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_InteractiveContractCard> createState() => _InteractiveContractCardState();
}

class _InteractiveContractCardState extends State<_InteractiveContractCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final contract = widget.contract;
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
          padding: const EdgeInsets.all(12),
          decoration: WitcherBookTheme.cardInsetDecoration(
            isInteractive: true,
            isHovered: _isHovered,
            isSelected: isSelected,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      contract.title.toUpperCase(),
                      style: WitcherTypography.parchmentHeading.copyWith(
                        fontSize: 13.5,
                        color: isSelected
                            ? WitcherColors.inkCrimson
                            : (_isHovered
                                ? WitcherColors.inkCrimsonBright
                                : WitcherColors.inkPrimary),
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: WitcherColors.inkCrimson,
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                contract.subtitle,
                style: WitcherTypography.parchmentBody.copyWith(
                  fontSize: 11,
                  color: WitcherColors.inkMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    contract.domain.toUpperCase(),
                    style: WitcherTypography.parchmentFolio.copyWith(
                      fontSize: 9,
                      color: WitcherColors.inkGold,
                    ),
                  ),
                  Text(
                    "COMPLETED",
                    style: WitcherTypography.parchmentFolio.copyWith(
                      fontSize: 9,
                      color: WitcherColors.inkCrimson,
                      fontWeight: FontWeight.w800,
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
}
