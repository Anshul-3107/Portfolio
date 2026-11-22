import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/audio/witcher_audio.dart';
import '../core/theme/witcher_colors.dart';
import '../core/theme/witcher_typography.dart';
import '../models/leetcode_stats.dart';
import '../services/leetcode_service.dart';
import 'book/witcher_book_theme.dart';

class LeetCodeTelemetryCard extends StatefulWidget {
  const LeetCodeTelemetryCard({super.key});

  @override
  State<LeetCodeTelemetryCard> createState() => _LeetCodeTelemetryCardState();
}

class _LeetCodeTelemetryCardState extends State<LeetCodeTelemetryCard> {
  LeetCodeStats _stats = LeetCodeStats.fallback();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final liveStats = await LeetCodeFrontendService.fetchStats();
    if (mounted) {
      setState(() {
        _stats = liveStats;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: WitcherBookTheme.manuscriptPlateDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          _buildHeader(),
          const SizedBox(height: 12),
          WitcherBookTheme.buildOrnamentalDivider(height: 14),
          const SizedBox(height: 12),

          // Main Stats Content
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: Big Conquered Count
                        Expanded(flex: 4, child: _buildHeroCounter()),
                        const SizedBox(width: 20),
                        // Right: Progress bars
                        Expanded(flex: 6, child: _buildProgressBars()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildHeroCounter(),
                        const SizedBox(height: 16),
                        _buildProgressBars(),
                      ],
                    );
            },
          ),
          const SizedBox(height: 16),
          WitcherBookTheme.buildOrnamentalDivider(height: 14),
          const SizedBox(height: 12),

          // Bottom Telemetry Readout Grid
          _buildTelemetryGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFB4A17A),
            border: Border.all(color: const Color(0xFF7A5812), width: 1.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Icon(
            Icons.psychology_rounded,
            color: Color(0xFF6B1914),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "TRIAL OF ALGORITHMS",
                      style: WitcherTypography.parchmentHeading.copyWith(
                        fontSize: 15,
                        letterSpacing: 1.8,
                        color: const Color(0xFF6B1914),
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Live sync rubrication badge (muted sage)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC6D8C2),
                      border: Border.all(color: const Color(0xFF205228), width: 1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFF205228),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isLoading
                              ? "SYNCING..."
                              : (_stats.isLive ? "LIVE SYNC" : "OFFLINE VAULT"),
                          style: const TextStyle(
                            fontFamily: 'Cinzel',
                            color: Color(0xFF1B4722),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                "Combat telemetry and algorithmic problem solving from @${_stats.username}",
                style: WitcherTypography.parchmentBody.copyWith(
                  color: const Color(0xFF5E4D3C),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              WitcherAudio.click();
              _launchUrl(_stats.profileUrl);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFB4A17A),
                border: Border.all(color: const Color(0xFF7A5812), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "View Profile",
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      color: WitcherColors.inkPrimary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.open_in_new_rounded,
                    size: 11,
                    color: Color(0xFF6B1914),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB4A17A),
        border: Border.all(color: const Color(0xFFA89168), width: 1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6B1914).withValues(alpha: 0.12),
                  border: Border.all(color: const Color(0xFF6B1914), width: 1),
                ),
                child: const Icon(
                  Icons.code_rounded,
                  size: 14,
                  color: Color(0xFF6B1914),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Anshul Arohi",
                style: WitcherTypography.parchmentHeading.copyWith(
                  color: WitcherColors.inkPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "@${_stats.username}",
                style: WitcherTypography.parchmentFolio.copyWith(
                  color: const Color(0xFF5E4D3C),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "${_stats.totalSolved}",
                style: const TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: Color(0xFF6B1914),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SOLVED",
                      style: WitcherTypography.parchmentFolio.copyWith(
                        color: const Color(0xFF7A5812),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      "out of ${_formatNumber(_stats.totalQuestions)} on LeetCode",
                      style: WitcherTypography.parchmentBody.copyWith(
                        color: const Color(0xFF5E4D3C),
                        fontSize: 10.5,
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
  }

  Widget _buildProgressBars() {
    return Column(
      children: [
        _buildDifficultyBar(
          label: "Easy",
          solved: _stats.easySolved,
          total: _stats.totalEasy,
          color: const Color(0xFF185E2C), // Muted forest green
        ),
        const SizedBox(height: 10),
        _buildDifficultyBar(
          label: "Medium",
          solved: _stats.mediumSolved,
          total: _stats.totalMedium,
          color: const Color(0xFF915408), // Muted antique amber
        ),
        const SizedBox(height: 10),
        _buildDifficultyBar(
          label: "Hard",
          solved: _stats.hardSolved,
          total: _stats.totalHard,
          color: const Color(0xFF751510), // Muted iron-gall crimson
        ),
      ],
    );
  }

  Widget _buildDifficultyBar({
    required String label,
    required int solved,
    required int total,
    required Color color,
  }) {
    final progress = total > 0 ? (solved / total).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: WitcherTypography.parchmentFolio.copyWith(
                    color: color,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "$solved",
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    color: color,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  " / ${_formatNumber(total)} ($percentage%)",
                  style: WitcherTypography.parchmentBody.copyWith(
                    color: const Color(0xFF5E4D3C),
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 7,
          decoration: BoxDecoration(
            color: const Color(0xFFAFA076),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFFA6936C), width: 0.8),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress < 0.02 && solved > 0 ? 0.02 : progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTelemetryGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 500;

        final items = [
          _buildTelemetryItem(
            label: "GLOBAL RANK",
            value: "#${_formatNumber(_stats.ranking)}",
            subtext: "Competitive Standing",
            icon: Icons.emoji_events_rounded,
          ),
          _buildTelemetryItem(
            label: "ACCEPTANCE",
            value: _stats.acceptanceRate,
            subtext: "First-Pass Precision",
            icon: Icons.done_all_rounded,
          ),
          _buildTelemetryItem(
            label: "SUBMISSIONS",
            value: "${_stats.totalSubmissions}",
            subtext: "Algorithm Trials",
            icon: Icons.code_rounded,
          ),
          _buildTelemetryItem(
            label: "ACTIVE SESSIONS",
            value: "${_stats.activeDays} Days",
            subtext: "Practice Consistency",
            icon: Icons.calendar_month_rounded,
          ),
        ];

        if (isCompact) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: item,
              );
            }).toList(),
          );
        }

        return Row(
          children: items.map((item) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: item,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTelemetryItem({
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFB4A17A),
        border: Border.all(color: const Color(0xFFA89168), width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: const Color(0xFF7A5812)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: WitcherTypography.parchmentFolio.copyWith(
                    fontSize: 8.5,
                    color: const Color(0xFF5E4D3C),
                    letterSpacing: 0.8,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 13.5,
              color: WitcherColors.inkPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            subtext,
            style: WitcherTypography.parchmentBody.copyWith(
              fontSize: 9.5,
              color: const Color(0xFF5E4D3C),
            ),
          ),
        ],
      ),
    );
  }
}
