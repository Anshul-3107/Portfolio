import 'package:flutter/material.dart';
import '../../core/theme/witcher_typography.dart';

class WitcherBookTheme {
  // Dull, Dusty Antique Vellum Page Leaf Gradient with Cylindrical Page Curvature
  // Matte finish, desaturated tones, and aged library dust
  static BoxDecoration parchmentDecoration({
    bool isLeftPage = false,
    bool isRightPage = false,
  }) {
    if (isLeftPage) {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFC2AF87), // Dry, oxidized, aged left outer edge
            Color(0xFFCCA978), // Natural outer margin roll
            Color(0xFFDCCEA7), // Matte vellum belly (dull, non-luminous)
            Color(0xFFD4C39C), // Page slope
            Color(0xFFC8B58D), // Curvature down toward center spine
            Color(0xFFB59F74), // Gutter shadow lead-in
          ],
          stops: [0.0, 0.06, 0.38, 0.76, 0.94, 1.0],
        ),
      );
    } else if (isRightPage) {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFB59F74), // Gutter shadow emergence
            Color(0xFFC8B58D), // Curvature rise from spine
            Color(0xFFD4C39C), // Page slope
            Color(0xFFDCCEA7), // Matte vellum belly (dull, non-luminous)
            Color(0xFFCCA978), // Natural outer margin roll
            Color(0xFFC2AF87), // Dry, oxidized, aged right outer edge
          ],
          stops: [0.0, 0.06, 0.24, 0.62, 0.94, 1.0],
        ),
      );
    }

    // Default / Mobile single-page dull vellum
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFC7B38A),
          Color(0xFFDCCEA7),
          Color(0xFFD5C49D),
          Color(0xFFC2AF87),
        ],
        stops: [0.0, 0.12, 0.88, 1.0],
      ),
    );
  }

  // Dull, Matte Antique Manuscript Card Inset Plate
  static BoxDecoration cardInsetDecoration({
    bool isInteractive = false,
    bool isHovered = false,
    bool isSelected = false,
  }) {
    final borderColor = isSelected
        ? const Color(0xFF6B1914) // Faded iron-gall crimson
        : (isHovered ? const Color(0xFF8A6A24) : const Color(0xFFA8936D));

    return BoxDecoration(
      color: isSelected
          ? const Color(0xFFC2AF87)
          : (isHovered ? const Color(0xFFD8C9A6) : const Color(0xFFCFBE9B)),
      borderRadius: BorderRadius.circular(3),
      border: Border.all(
        color: borderColor,
        width: isSelected || isHovered ? 1.4 : 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0x2225180A),
          blurRadius: isHovered ? 5 : 2.5,
          offset: Offset(0, isHovered ? 2 : 1),
        ),
      ],
    );
  }

  // Deeply Engraved Manuscript Plate (for Complex Telemetry & Vitals)
  static BoxDecoration manuscriptPlateDecoration({
    bool isHovered = false,
  }) {
    return BoxDecoration(
      color: const Color(0xFFCFBE9B),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: isHovered ? const Color(0xFF8A6A24) : const Color(0xFFA8926C),
        width: 1.2,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x2825180A),
          blurRadius: 4,
          offset: Offset(0, 1.5),
        ),
      ],
    );
  }

  // Manuscript Divider Line with Calligraphic Diamond
  static Widget buildOrnamentalDivider({
    String symbol = '❖',
    Color? color,
    double height = 20,
  }) {
    final activeColor = color ?? const Color(0xFF7A5812);
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    activeColor.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              symbol,
              style: TextStyle(
                color: activeColor,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    activeColor.withValues(alpha: 0.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Drop Cap Builder (Illuminated initial letter with faded iron-gall ink)
  static Widget buildDropCap(String letter, String restOfWord) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFC7B58E),
            border: Border.all(color: const Color(0xFF6B1914), width: 1.5),
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x321D1206),
                blurRadius: 3,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Text(
            letter,
            style: WitcherTypography.parchmentDropCap.copyWith(
              color: const Color(0xFF6B1914),
            ),
          ),
        ),
        Text(
          restOfWord,
          style: WitcherTypography.parchmentHeading.copyWith(
            color: const Color(0xFF6B1914),
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
