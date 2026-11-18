import 'package:flutter/material.dart';
import 'core/theme/witcher_colors.dart';
import 'core/theme/witcher_typography.dart';
import 'screens/witcher_hud_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AnshulPortfolioApp());
}

class AnshulPortfolioApp extends StatelessWidget {
  const AnshulPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anshul of AI • Grandmaster Witcher Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: WitcherColors.background,
        colorScheme: const ColorScheme.dark(
          primary: WitcherColors.goldBright,
          secondary: WitcherColors.gold,
          surface: WitcherColors.surface,
        ),
        fontFamily: WitcherTypography.fontBody,
        dividerColor: WitcherColors.borderDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WitcherHudScaffold(),
    );
  }
}
