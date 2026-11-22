import 'package:flutter/material.dart';

class WitcherGoldText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const WitcherGoldText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = (style ?? const TextStyle()).copyWith(
      color: Colors.white,
    );

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF9E6), // Specular light gold
            Color(0xFFF5D37E), // Bright polished gold
            Color(0xFFE5B869), // Iconic Witcher gold
            Color(0xFFC5A059), // Rich gold
            Color(0xFF8F6E2A), // Shadow gold
          ],
          stops: [0.0, 0.25, 0.55, 0.85, 1.0],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: baseStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
