import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/audio/witcher_audio.dart';
import '../widgets/book/spreads/character_spread.dart';
import '../widgets/book/spreads/contracts_spread.dart';
import '../widgets/book/spreads/glossary_spread.dart';
import '../widgets/book/spreads/notice_board_spread.dart';
import '../widgets/book/spreads/signs_spread.dart';
import '../widgets/book/witcher_book_frame.dart';
import '../widgets/book/witcher_page_flip_transition.dart';
import '../widgets/dandelion_chat_dialog.dart';
import '../widgets/ember_particles.dart';
import '../widgets/witcher_title_screen.dart';

class WitcherHudScaffold extends StatefulWidget {
  const WitcherHudScaffold({super.key});

  @override
  State<WitcherHudScaffold> createState() => _WitcherHudScaffoldState();
}

class _WitcherHudScaffoldState extends State<WitcherHudScaffold> {
  int _currentTabIndex = 0;
  bool _isFullscreen = false;
  bool _hasEntered = false;
  final FocusNode _keyboardFocusNode = FocusNode();
  final GlobalKey<DandelionChatWidgetState> _dandelionKey = GlobalKey<DandelionChatWidgetState>();

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
    setState(() => _currentTabIndex = next);
  }

  void _prevTab() {
    final prev = (_currentTabIndex - 1 + _tabTitles.length) % _tabTitles.length;
    setState(() => _currentTabIndex = prev);
  }

  Widget _buildActiveSpread(bool isDesktop) {
    switch (_currentTabIndex) {
      case 0:
        return CharacterSpread(
          isDesktop: isDesktop,
          onNavigateToContracts: () => _onTabSelected(1),
          onNavigateToNoticeBoard: () => _onTabSelected(3),
        );
      case 1:
        return ContractsSpread(
          isDesktop: isDesktop,
          onTurnPrevious: () => _onTabSelected(0),
          onTurnNext: () => _onTabSelected(2),
        );
      case 2:
        return SignsSpread(
          isDesktop: isDesktop,
          onTurnPrevious: () => _onTabSelected(1),
          onTurnNext: () => _onTabSelected(3),
        );
      case 3:
        return NoticeBoardSpread(
          isDesktop: isDesktop,
          onTurnPrevious: () => _onTabSelected(2),
          onTurnNext: () => _onTabSelected(4),
        );
      case 4:
        return GlossarySpread(
          isDesktop: isDesktop,
          onTurnPrevious: () => _onTabSelected(3),
          onTurnToBeginning: () => _onTabSelected(0),
        );
      default:
        return CharacterSpread(
          isDesktop: isDesktop,
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
          if (!_hasEntered) {
            WitcherAudio.sword();
            WitcherAudio.startAmbient();
            setState(() => _hasEntered = true);
            return;
          }
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
        backgroundColor: const Color(0xFFC7B38A),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 650),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: !_hasEntered
              ? WitcherTitleScreen(
                  key: const ValueKey('witcher_title_screen'),
                  onEnter: () {
                    setState(() => _hasEntered = true);
                  },
                )
              : EmberParticles(
                  key: const ValueKey('witcher_grimoire_main'),
                  child: Stack(
                    children: [
                      // The Antique Witcher Tome / Grimoire Frame
                      Positioned.fill(
                        child: WitcherBookFrame(
                          selectedIndex: _currentTabIndex,
                          onTabSelected: _onTabSelected,
                          tabTitles: _tabTitles,
                          onOpenDandelion: () {
                            _dandelionKey.currentState?.openChat();
                          },
                          onToggleAudio: () {
                            setState(() {
                              WitcherAudio.toggleAudio();
                            });
                          },
                          isAudioEnabled: WitcherAudio.isEnabled,
                          onToggleFullscreen: () {
                            setState(() {
                              _isFullscreen = WitcherAudio.toggleFullscreen();
                            });
                          },
                          isFullscreen: _isFullscreen,
                          onDownloadDossier: () {
                            WitcherAudio.downloadResume();
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isDesktop = constraints.maxWidth > 900;

                              return WitcherPageFlipTransition(
                                currentIndex: _currentTabIndex,
                                child: KeyedSubtree(
                                  key: ValueKey<int>(_currentTabIndex),
                                  child: _buildActiveSpread(isDesktop),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Floating Dandelion AI Chat Companion in bottom right
                      DandelionChatWidget(key: _dandelionKey),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
