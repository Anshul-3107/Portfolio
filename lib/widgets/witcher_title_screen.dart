import 'package:flutter/material.dart';
import '../core/audio/witcher_audio.dart';
import '../core/theme/witcher_colors.dart';
import '../core/theme/witcher_typography.dart';
import 'ember_particles.dart';
import 'witcher_divider.dart';
import 'witcher_gold_text.dart';
import 'witcher_medallion.dart';

class WitcherTitleScreen extends StatefulWidget {
  final VoidCallback onEnter;

  const WitcherTitleScreen({
    super.key,
    required this.onEnter,
  });

  @override
  State<WitcherTitleScreen> createState() => _WitcherTitleScreenState();
}

class _WitcherTitleScreenState extends State<WitcherTitleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleEnter() {
    if (_isExiting) return;
    setState(() => _isExiting = true);

    // Unsheathe blade sound & start soothing ambient music
    WitcherAudio.sword();
    WitcherAudio.startAmbient();

    widget.onEnter();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleEnter,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: WitcherColors.background,
          child: EmberParticles(
            particleCount: 65,
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Grandmaster Talisman Medallion
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: WitcherColors.gold.withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            width: 145,
                            height: 145,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: WitcherColors.goldBright, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: WitcherColors.gold.withValues(alpha: 0.35),
                                  blurRadius: 30,
                                  spreadRadius: 4,
                                ),
                              ],
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0xFF2C3342),
                                  Color(0xFF101217),
                                ],
                              ),
                            ),
                          ),
                          const WitcherMedallion(size: 95, glowing: true),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Title
                      const WitcherGoldText(
                        "ANSHUL OF AI",
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 38,
                          letterSpacing: 6.0,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "GRANDMASTER WITCHER OF THE NEURAL SCHOOL",
                        style: WitcherTypography.metricLabel.copyWith(
                          fontSize: 12,
                          letterSpacing: 3.2,
                          color: WitcherColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 380),
                        child: const WitcherDivider(symbol: '⚔', height: 28),
                      ),
                      const SizedBox(height: 40),

                      // Breathing Enter Callout
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          final p = _pulseAnimation.value;
                          final borderColor = Color.lerp(
                            WitcherColors.goldBright,
                            WitcherColors.crimsonBright,
                            p * 0.4,
                          )!;

                          return Container(
                            constraints: const BoxConstraints(maxWidth: 520),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF13161F).withValues(alpha: 0.9),
                              border: Border.all(color: borderColor, width: 1.4),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: WitcherColors.gold.withValues(alpha: 0.2 + p * 0.25),
                                  blurRadius: 18 + p * 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_right_alt_rounded,
                                  color: WitcherColors.goldBright,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    "CLICK ANYWHERE TO ENTER SANCTUARY",
                                    style: WitcherTypography.titleSmall.copyWith(
                                      color: WitcherColors.goldBright,
                                      fontSize: 13,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.arrow_left_rounded,
                                  color: WitcherColors.goldBright,
                                  size: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Ambient music subtitle
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Icon(
                            Icons.music_note_rounded,
                            size: 14,
                            color: WitcherColors.gold.withValues(alpha: 0.75),
                          ),
                          Text(
                            "Atmospheric Soundscapes: Kaer Morhen & The Fields of Ard Skellig",
                            style: WitcherTypography.bodySmall.copyWith(
                              color: WitcherColors.textMuted.withValues(alpha: 0.8),
                              fontSize: 11.5,
                              letterSpacing: 0.8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
