import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/audio/witcher_audio.dart';
import '../core/constants/resume_data.dart';
import '../core/theme/witcher_colors.dart';
import '../core/theme/witcher_typography.dart';
import '../widgets/dandelion_chat_dialog.dart';
import '../widgets/ember_particles.dart';
import '../widgets/runic_button.dart';
import '../widgets/witcher_medallion.dart';
import '../widgets/witcher_tab_bar.dart';
import 'tabs/character_tab.dart';
import 'tabs/contracts_tab.dart';
import 'tabs/glossary_tab.dart';
import 'tabs/notice_board_tab.dart';
import 'tabs/signs_tab.dart';

class WitcherHudScaffold extends StatefulWidget {
  const WitcherHudScaffold({super.key});

  @override
  State<WitcherHudScaffold> createState() => _WitcherHudScaffoldState();
}

class _WitcherHudScaffoldState extends State<WitcherHudScaffold> {
  int _currentTabIndex = 0;
  bool _isFullscreen = false;
  final FocusNode _keyboardFocusNode = FocusNode();

  final List<String> _tabTitles = [
    "Character",
    "Contracts",
    "Signs & Arsenal",
    "Notice Board",
    "Glossary",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WitcherAudio.hideLoader();
      _keyboardFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentTabIndex != index) {
      setState(() => _currentTabIndex = index);
    }
  }

  void _nextTab() {
    final next = (_currentTabIndex + 1) % _tabTitles.length;
    WitcherAudio.tab();
    setState(() => _currentTabIndex = next);
  }

  void _prevTab() {
    final prev = (_currentTabIndex - 1 + _tabTitles.length) % _tabTitles.length;
    WitcherAudio.tab();
    setState(() => _currentTabIndex = prev);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  Widget _buildActiveTab() {
    switch (_currentTabIndex) {
      case 0:
        return CharacterTab(
          onNavigateToContracts: () => _onTabSelected(1),
          onNavigateToNoticeBoard: () => _onTabSelected(3),
        );
      case 1:
        return const ContractsTab();
      case 2:
        return const SignsTab();
      case 3:
        return const NoticeBoardTab();
      case 4:
        return const GlossaryTab();
      default:
        return CharacterTab(
          onNavigateToContracts: () => _onTabSelected(1),
          onNavigateToNoticeBoard: () => _onTabSelected(3),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.keyE ||
              event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _nextTab();
          } else if (event.logicalKey == LogicalKeyboardKey.keyQ ||
              event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _prevTab();
          }
        }
      },
      child: Scaffold(
        backgroundColor: WitcherColors.background,
        body: EmberParticles(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildTopHeader(),
                  const Divider(color: WitcherColors.borderDark, height: 1),
                  _buildNavigationBar(),
                  const Divider(color: WitcherColors.borderDark, height: 1),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.015),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<int>(_currentTabIndex),
                        child: _buildActiveTab(),
                      ),
                    ),
                  ),
                  const Divider(color: WitcherColors.borderDark, height: 1),
                  _buildFooter(),
                ],
              ),
              const DandelionChatWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 850;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 24,
            vertical: 12,
          ),
          color: const Color(0xFF101217),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wolf Medallion & Title
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          WitcherAudio.click();
                          _onTabSelected(0);
                        },
                        child: const WitcherMedallion(size: 38, glowing: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ResumeData.witcherTitle.toUpperCase(),
                            style: WitcherTypography.titleSmall.copyWith(
                              fontSize: isCompact ? 14 : 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                              color: WitcherColors.goldBright,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "GRANDMASTER OF THE NEURAL SCHOOL",
                            style: WitcherTypography.metricLabel.copyWith(
                              fontSize: isCompact ? 8.5 : 9.5,
                              letterSpacing: 1.5,
                              color: WitcherColors.textMuted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Header Controls (Fullscreen, Audio & Resume)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fullscreen Toggle
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFullscreen = WitcherAudio.toggleFullscreen();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF181B22),
                          border: Border.all(
                            color: _isFullscreen
                                ? WitcherColors.goldBright
                                : WitcherColors.borderDark,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isFullscreen
                                  ? Icons.fullscreen_exit_rounded
                                  : Icons.fullscreen_rounded,
                              size: 16,
                              color: _isFullscreen
                                  ? WitcherColors.goldBright
                                  : WitcherColors.textParchmentLight,
                            ),
                            if (!isCompact) ...[
                              const SizedBox(width: 6),
                              Text(
                                _isFullscreen ? "WINDOW" : "FULLSCREEN",
                                style: WitcherTypography.tagText.copyWith(
                                  fontSize: 10.5,
                                  color: _isFullscreen
                                      ? WitcherColors.goldBright
                                      : WitcherColors.textParchmentLight,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Audio Toggle
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          WitcherAudio.toggleAudio();
                        });
                        WitcherAudio.click();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF181B22),
                          border: Border.all(
                            color: WitcherAudio.isEnabled
                                ? WitcherColors.goldMuted
                                : WitcherColors.borderDark,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              WitcherAudio.isEnabled
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_off_rounded,
                              size: 16,
                              color: WitcherAudio.isEnabled
                                  ? WitcherColors.goldBright
                                  : WitcherColors.textMuted,
                            ),
                            if (!isCompact) ...[
                              const SizedBox(width: 6),
                              Text(
                                WitcherAudio.isEnabled ? "AUDIO ON" : "MUTED",
                                style: WitcherTypography.tagText.copyWith(
                                  fontSize: 10.5,
                                  color: WitcherAudio.isEnabled
                                      ? WitcherColors.goldBright
                                      : WitcherColors.textMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Claim Resume Button
                  RunicButton(
                    text: isCompact ? "Resume" : "Claim Dossier",
                    icon: Icons.history_edu_rounded,
                    style: RunicButtonStyle.gold,
                    isCompact: true,
                    onPressed: WitcherAudio.downloadResume,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF14171E),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: WitcherTabBar(
          selectedIndex: _currentTabIndex,
          onTabSelected: _onTabSelected,
          tabTitles: _tabTitles,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 800;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 32,
            vertical: 10,
          ),
          color: const Color(0xFF0F1015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Keyboard shortcut hint
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2029),
                      border: Border.all(color: WitcherColors.borderDark),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      "Q / E",
                      style: WitcherTypography.tagText.copyWith(
                        color: WitcherColors.goldBright,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Cycle Tabs",
                    style: WitcherTypography.bodySmall.copyWith(
                      color: WitcherColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              // Witcher Motto / Quote
              if (!isCompact)
                Expanded(
                  child: Center(
                    child: Text(
                      "\"Witchers hunt beasts. Anshul of AI hunts anomalies and solves complex systems.\"",
                      style: WitcherTypography.quoteText.copyWith(
                        fontSize: 12,
                        color: WitcherColors.goldMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

              // Guild Seals Quick Icons
              Row(
                children: [
                  _buildFooterLink(
                    icon: Icons.code_rounded,
                    tooltip: "GitHub",
                    onTap: () => _launchUrl(ResumeData.gitHubUrl),
                  ),
                  const SizedBox(width: 8),
                  _buildFooterLink(
                    icon: Icons.business_center_rounded,
                    tooltip: "LinkedIn",
                    onTap: () => _launchUrl(ResumeData.linkedInUrl),
                  ),
                  const SizedBox(width: 8),
                  _buildFooterLink(
                    icon: Icons.alternate_email_rounded,
                    tooltip: "Send Raven (Gmail)",
                    onTap: () => _launchUrl(ResumeData.gmailComposeUrl),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooterLink({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            WitcherAudio.click();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF181B22),
              border: Border.all(color: WitcherColors.borderDark),
            ),
            child: Icon(icon, size: 14, color: WitcherColors.textMuted),
          ),
        ),
      ),
    );
  }
}
