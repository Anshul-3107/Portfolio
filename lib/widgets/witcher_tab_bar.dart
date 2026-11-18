import 'package:flutter/material.dart';
import '../core/audio/witcher_audio.dart';
import '../core/theme/witcher_colors.dart';
import '../core/theme/witcher_typography.dart';

class WitcherTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<String> tabTitles;

  const WitcherTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabTitles,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabTitles.length, (index) {
          final isSelected = selectedIndex == index;
          return _WitcherTabItem(
            title: tabTitles[index],
            isSelected: isSelected,
            onTap: () {
              if (selectedIndex != index) {
                WitcherAudio.tab();
                onTabSelected(index);
              }
            },
          );
        }),
      ),
    );
  }
}

class _WitcherTabItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _WitcherTabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_WitcherTabItem> createState() => _WitcherTabItemState();
}

class _WitcherTabItemState extends State<_WitcherTabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;
    final color = active
        ? WitcherColors.goldBright
        : (_isHovered ? WitcherColors.textParchmentLight : WitcherColors.textMuted);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        WitcherAudio.hover();
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (active) ...[
                    const Icon(
                      Icons.diamond_rounded,
                      size: 8,
                      color: WitcherColors.goldBright,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    widget.title.toUpperCase(),
                    style: WitcherTypography.navTab.copyWith(
                      color: color,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      shadows: active
                          ? [
                              Shadow(
                                color: WitcherColors.gold.withValues(alpha: 0.6),
                                blurRadius: 10,
                              ),
                            ]
                          : [],
                    ),
                  ),
                  if (active) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.diamond_rounded,
                      size: 8,
                      color: WitcherColors.goldBright,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: active ? 36 : (_isHovered ? 16 : 0),
                decoration: BoxDecoration(
                  color: active
                      ? WitcherColors.goldBright
                      : (_isHovered ? WitcherColors.goldMuted : Colors.transparent),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: WitcherColors.gold.withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ]
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
