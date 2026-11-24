import 'package:flutter/material.dart';
import '../../core/constants/resume_data.dart';
import '../../core/theme/witcher_colors.dart';
import '../../core/theme/witcher_typography.dart';
import '../witcher_medallion.dart';

class WitcherBookFrame extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<String> tabTitles;
  final VoidCallback onOpenDandelion;
  final VoidCallback onToggleAudio;
  final bool isAudioEnabled;
  final VoidCallback onToggleFullscreen;
  final bool isFullscreen;
  final VoidCallback onDownloadDossier;

  const WitcherBookFrame({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabTitles,
    required this.onOpenDandelion,
    required this.onToggleAudio,
    required this.isAudioEnabled,
    required this.onToggleFullscreen,
    required this.isFullscreen,
    required this.onDownloadDossier,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        return Container(
          width: double.infinity,
          height: double.infinity,
          // Dull, Matte Antique Vellum Paper spanning the entire screen
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFA8966E), // Top edge antique dust & tanning
                Color(0xFFBCA981), // Upper dull vellum
                Color(0xFFB29F77), // Lower dull vellum
                Color(0xFF9E8B64), // Bottom edge antique dust & tanning
              ],
              stops: [0.0, 0.12, 0.88, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top Header on the Dull Parchment
                _buildManuscriptHeader(context, isDesktop),
                const SizedBox(height: 2),

                // Main Parchment Spread
                Expanded(
                  child: Stack(
                    children: [
                      // Active Dual Spread Content
                      Positioned.fill(
                        child: child,
                      ),

                      // Matte 3D Book Spine Gutter with Deep Shadow Trench & Binding Cords (Exact 50% middle)
                      if (isDesktop)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Center(
                              child: SizedBox(
                                width: 76,
                                height: double.infinity,
                                child: CustomPaint(
                                  painter: _ExactCenterCreasePainter(),
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 12,
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _MobileTopBinderPainter(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Elegant Calligraphic Header on the Parchment
  Widget _buildManuscriptHeader(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      return _buildDesktopHeader(context);
    } else {
      return _buildMobileHeader(context);
    }
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0x35B8A47A),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFA89168),
            width: 1.2,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Left Side: Medallion & Character Title
          Align(
            alignment: Alignment.centerLeft,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (selectedIndex != 0) {
                    onTabSelected(0);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1E150E),
                        border: Border.all(color: const Color(0xFF8F7026), width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x30000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: WitcherMedallion(size: 24, glowing: true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ResumeData.witcherTitle.toUpperCase(),
                          style: WitcherTypography.parchmentHeading.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                            color: const Color(0xFF6B1914), // Faded iron-gall crimson
                          ),
                        ),
                        Text(
                          "GRANDMASTER OF THE NEURAL SCHOOL",
                          style: WitcherTypography.parchmentFolio.copyWith(
                            fontSize: 8.5,
                            letterSpacing: 1.2,
                            color: const Color(0xFF5E4D3C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Dead Center: Chapter Tabs
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(tabTitles.length, (index) {
                  final isSelected = selectedIndex == index;
                  return _ParchmentTabItem(
                    title: tabTitles[index],
                    index: index,
                    isSelected: isSelected,
                    onTap: () {
                      if (selectedIndex != index) {
                        onTabSelected(index);
                      }
                    },
                  );
                }),
              ),
            ),
          ),

          // 3. Right Side: ONLY Sound, Fullscreen, and Dossier
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Audio Toggle
                _ParchmentUtilityButton(
                  icon: isAudioEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  label: isAudioEnabled ? "SOUND" : "MUTED",
                  tooltip: "Kaer Morhen & Ard Skellig Ambient Soundtrack",
                  isActive: isAudioEnabled,
                  onTap: onToggleAudio,
                ),
                const SizedBox(width: 6),

                // Fullscreen Toggle
                _ParchmentUtilityButton(
                  icon: isFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                  label: isFullscreen ? "WINDOW" : "FULL",
                  tooltip: "Toggle Fullscreen View",
                  isActive: isFullscreen,
                  onTap: onToggleFullscreen,
                ),
                const SizedBox(width: 6),

                // Dossier Download
                _ParchmentUtilityButton(
                  icon: Icons.download_rounded,
                  label: "DOSSIER",
                  tooltip: "Download Resume & AWS ML Engineer Certificate",
                  isActive: true,
                  highlightColor: const Color(0xFF6B1914),
                  onTap: onDownloadDossier,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Responsive 2-Tier Header for Mobile/Phone Browsers
  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0x35B8A47A),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFA89168),
            width: 1.2,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tier 1: Wolf Crest + Title (Left) and Quick Utilities (Right)
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (selectedIndex != 0) onTabSelected(0);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E150E),
                          border: Border.all(color: const Color(0xFF8F7026), width: 1.3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x30000000),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: WitcherMedallion(size: 20, glowing: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ResumeData.witcherTitle.toUpperCase(),
                            style: WitcherTypography.parchmentHeading.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: const Color(0xFF6B1914),
                            ),
                          ),
                          Text(
                            "SCHOOL OF THE NEURAL WOLF",
                            style: WitcherTypography.parchmentFolio.copyWith(
                              fontSize: 7.5,
                              letterSpacing: 0.8,
                              color: const Color(0xFF5E4D3C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ParchmentUtilityButton(
                      icon: isAudioEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                      label: isAudioEnabled ? "SOUND" : "MUTED",
                      tooltip: "Ambient Audio",
                      isActive: isAudioEnabled,
                      onTap: onToggleAudio,
                    ),
                    const SizedBox(width: 5),
                    _ParchmentUtilityButton(
                      icon: Icons.download_rounded,
                      label: "DOSSIER",
                      tooltip: "Download Dossier",
                      isActive: true,
                      highlightColor: const Color(0xFF6B1914),
                      onTap: onDownloadDossier,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Hairline separator
          Container(
            height: 1,
            color: const Color(0x25A89168),
          ),

          // Tier 2: Horizontally Scrollable Parchment Chapter Ribbons
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(tabTitles.length, (index) {
                  final isSelected = selectedIndex == index;
                  return _ParchmentTabItem(
                    title: tabTitles[index],
                    index: index,
                    isSelected: isSelected,
                    isCompact: true,
                    onTap: () {
                      if (selectedIndex != index) onTabSelected(index);
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Chapter Tab Item on Parchment
class _ParchmentTabItem extends StatefulWidget {
  final String title;
  final int index;
  final bool isSelected;
  final bool isCompact;
  final VoidCallback onTap;

  const _ParchmentTabItem({
    required this.title,
    required this.index,
    required this.isSelected,
    this.isCompact = false,
    required this.onTap,
  });

  @override
  State<_ParchmentTabItem> createState() => _ParchmentTabItemState();
}

class _ParchmentTabItemState extends State<_ParchmentTabItem> {
  bool _isHovered = false;

  final List<String> romanNumerals = ["I", "II", "III", "IV", "V"];

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;
    final compact = widget.isCompact;
    final roman = widget.index < romanNumerals.length
        ? romanNumerals[widget.index]
        : "${widget.index + 1}";

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: EdgeInsets.symmetric(horizontal: compact ? 3 : 4),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? (active ? 9 : 7) : (active ? 14 : 10),
            vertical: compact ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFFA5926A)
                : (_isHovered ? const Color(0xFFB8A57D) : Colors.transparent),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: active
                  ? const Color(0xFF6B1914)
                  : (_isHovered ? const Color(0xFF8F7B54) : Colors.transparent),
              width: 1.2,
            ),
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: Color(0x2825180A),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$roman.",
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: compact ? 10 : 11,
                  fontWeight: FontWeight.w800,
                  color: active
                      ? const Color(0xFF6B1914)
                      : (_isHovered ? const Color(0xFF7A5812) : const Color(0xFF5E4D3C)),
                ),
              ),
              SizedBox(width: compact ? 3 : 5),
              Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: compact ? (active ? 10 : 9.5) : (active ? 11.5 : 11),
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: compact ? 0.9 : 1.4,
                  color: active
                      ? const Color(0xFF6B1914)
                      : (_isHovered ? WitcherColors.inkPrimary : const Color(0xFF5E4D3C)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Utility Button on Parchment
class _ParchmentUtilityButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final String tooltip;
  final bool isActive;
  final Color? highlightColor;
  final VoidCallback onTap;

  const _ParchmentUtilityButton({
    required this.icon,
    this.label,
    required this.tooltip,
    required this.isActive,
    this.highlightColor,
    required this.onTap,
  });

  @override
  State<_ParchmentUtilityButton> createState() => _ParchmentUtilityButtonState();
}

class _ParchmentUtilityButtonState extends State<_ParchmentUtilityButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.highlightColor ??
        (widget.isActive ? const Color(0xFF7A5812) : const Color(0xFF5E4D3C));

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: _isHovered ? const Color(0xFFB29E76) : const Color(0xFFA8956E),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: _isHovered ? activeColor : const Color(0xFF8F7B54),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1825180A),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: activeColor),
                if (widget.label != null) ...[
                  const SizedBox(width: 5),
                  Text(
                    widget.label!,
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: activeColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Matte 3D Book Spine Gutter with Deep Shadow Trench & Binding Cords (No shiny white reflections)
class _ExactCenterCreasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // 1. Realistic Multi-stop Spine Shadow Trench (Deep curved matte paper valley)
    final valleyShader = LinearGradient(
      colors: [
        Colors.transparent,
        const Color(0x222E1A0B),
        const Color(0x55281408),
        const Color(0x9A200E05),
        const Color(0xEE110602), // Deep matte shadow trench in cleft
        const Color(0x9A200E05),
        const Color(0x55281408),
        const Color(0x222E1A0B),
        Colors.transparent,
      ],
      stops: const [0.0, 0.16, 0.32, 0.44, 0.50, 0.56, 0.68, 0.84, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final valleyPaint = Paint()..shader = valleyShader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), valleyPaint);

    // 2. Razor-thin fold line at the center
    final cleftLinePaint = Paint()
      ..color = const Color(0xF00D0502)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), cleftLinePaint);

    // 3. Five Hand-Stitched Binding Cords (Holding the two book leaves together, as in Witcher 3)
    final cordPositions = [0.12, 0.28, 0.50, 0.72, 0.88];

    final holePaint = Paint()
      ..color = const Color(0xEE0F0602)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = const Color(0x70000000)
      ..strokeWidth = 2.4;

    final cordPaint = Paint()
      ..color = const Color(0xFF3D2713) // Weathered dark hemp cord
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final cordHighlightPaint = Paint()
      ..color = const Color(0xFF5C3F22)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    for (final pos in cordPositions) {
      final y = size.height * pos;

      // Needle puncture holes on left and right sides of fold
      canvas.drawCircle(Offset(centerX - 13, y), 1.8, holePaint);
      canvas.drawCircle(Offset(centerX + 13, y), 1.8, holePaint);

      // Cord cast shadow (downward slant)
      canvas.drawLine(
        Offset(centerX - 12, y + 1.6),
        Offset(centerX + 12, y + 1.6),
        shadowPaint,
      );

      // Hemp / leather braided cord stitch
      canvas.drawLine(
        Offset(centerX - 12, y),
        Offset(centerX + 12, y),
        cordPaint,
      );

      // Cord thread highlight (matte, muted)
      canvas.drawLine(
        Offset(centerX - 11, y - 0.5),
        Offset(centerX + 11, y - 0.5),
        cordHighlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ExactCenterCreasePainter oldDelegate) => false;
}

// Top binding binder with leather stitches & shadow for mobile/phone codex
class _MobileTopBinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // 1. Top hinge drop shadow cast onto the page leaf
    final shadowShader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x551A0D05),
        Color(0x201A0D05),
        Colors.transparent,
      ],
      stops: [0.0, 0.55, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = shadowShader);

    // 2. Leather stitches across the top horizontal fold line
    final holePaint = Paint()
      ..color = const Color(0xEE120602)
      ..style = PaintingStyle.fill;
    final cordPaint = Paint()
      ..color = const Color(0xFF3E2815)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final highlightPaint = Paint()
      ..color = const Color(0xFF6B4826)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final stitchCount = (size.width / 52).clamp(5, 9).toInt();
    for (int i = 1; i <= stitchCount; i++) {
      final x = (size.width / (stitchCount + 1)) * i;
      canvas.drawCircle(Offset(x - 4, 3.5), 1.3, holePaint);
      canvas.drawCircle(Offset(x + 4, 3.5), 1.3, holePaint);
      canvas.drawLine(Offset(x - 4, 3.5), Offset(x + 4, 3.5), cordPaint);
      canvas.drawLine(Offset(x - 3, 3.0), Offset(x + 3, 3.0), highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MobileTopBinderPainter oldDelegate) => false;
}
