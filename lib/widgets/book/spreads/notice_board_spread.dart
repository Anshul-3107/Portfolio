import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/audio/witcher_audio.dart';
import '../../../core/constants/resume_data.dart';
import '../../../core/theme/witcher_colors.dart';
import '../../../core/theme/witcher_typography.dart';
import '../witcher_book_theme.dart';
import '../witcher_parchment_page.dart';
import '../witcher_wax_seal.dart';

class NoticeBoardSpread extends StatefulWidget {
  final bool isDesktop;
  final VoidCallback onTurnPrevious;
  final VoidCallback onTurnNext;

  const NoticeBoardSpread({
    super.key,
    required this.isDesktop,
    required this.onTurnPrevious,
    required this.onTurnNext,
  });

  @override
  State<NoticeBoardSpread> createState() => _NoticeBoardSpreadState();
}

class _NoticeBoardSpreadState extends State<NoticeBoardSpread> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSent = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  void _sendDispatch() {
    final name = _nameController.text.trim();
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    WitcherAudio.seal();
    final mailto = Uri(
      scheme: 'mailto',
      path: ResumeData.email,
      queryParameters: {
        'subject': 'Dispatch from $name via Witcher Portfolio',
        'body': message,
      },
    );
    _launchUrl(mailto.toString());
    setState(() => _isSent = true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Page: Folded Bounty Notice Letter with Red Wax Seal (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isLeftPage: true,
              chapterHeader: "CHAPTER IV • THE NOTICE BOARD",
              folioNumber: "FOLIO VII • ROYAL BOUNTY PROCLAMATION",
              onTurnPage: widget.onTurnPrevious,
              turnPageLabel: "⮜ SIGNS",
              isTurnBackwards: true,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildBountyNoticeLetterLeaf(context),
              ),
            ),
          ),

          // Right Page: Comms Dispatch & Dossier Download (Exact 50% split)
          Expanded(
            child: WitcherParchmentPage(
              isRightPage: true,
              chapterHeader: "CHAPTER IV • DISPATCH COMMS",
              folioNumber: "FOLIO VIII • GUILD RAVEN MESSENGERS",
              onTurnPage: widget.onTurnNext,
              turnPageLabel: "GLOSSARY ⮞",
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: _buildDispatchLeaf(context),
              ),
            ),
          ),
        ],
      );
    } else {
      // Mobile Single Page Spread
      return WitcherParchmentPage(
        chapterHeader: "CHAPTER IV • NOTICE BOARD & DISPATCH",
        folioNumber: "FOLIO VII • NOTICE BOARD",
        onTurnPage: widget.onTurnNext,
        turnPageLabel: "GLOSSARY ⮞",
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              _buildBountyNoticeLetterLeaf(context),
              const SizedBox(height: 18),
              WitcherBookTheme.buildOrnamentalDivider(symbol: '📜', height: 20),
              const SizedBox(height: 18),
              _buildDispatchLeaf(context),
            ],
          ),
        ),
      );
    }
  }

  // Left Page: Folded Parchment Bounty Letter (Direct Homage to Reference Image)
  Widget _buildBountyNoticeLetterLeaf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WitcherBookTheme.buildDropCap("H", "ear Ye, Lords & Guildmasters!"),
        const SizedBox(height: 12),

        // The Folded Letter Container (3 horizontal folded panels with wax seal at bottom)
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFBAA77F),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: const Color(0xFFA6936C), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Letter Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "OFFICIAL BOUNTY PROCLAMATION",
                          style: WitcherTypography.parchmentFolio.copyWith(
                            color: WitcherColors.inkCrimson,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text("⚜", style: TextStyle(color: WitcherColors.inkGold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Divider(color: Color(0xFFD4C29E), height: 1),
                    const SizedBox(height: 10),

                    // Fold 1: The Call to Arms
                    Text(
                      "CONTRACT: SEEKING AI/ML SPECIALIST & SYSTEMS ARCHITECT",
                      style: WitcherTypography.parchmentHeading.copyWith(
                        fontSize: 14.5,
                        color: WitcherColors.inkPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "The Guild seeks Anshul of AI for operational missions involving Machine Learning architectures, "
                      "fraud anomaly detection, resilient REST backends, and high-performance client applications.",
                      style: WitcherTypography.parchmentBody.copyWith(
                        fontSize: 12,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Fold crease 1 (visual shadow fold)
                    _buildHorizontalFoldShadow(),
                    const SizedBox(height: 12),

                    // Fold 2: Required Masteries
                    Text(
                      "VERIFIED REQUISITES & QUALIFICATIONS",
                      style: WitcherTypography.parchmentFolio.copyWith(
                        color: WitcherColors.inkGold,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "• B.Tech in CSE (AI & ML), VIT Vellore (2023–2027)\n"
                      "• AWS Certified Machine Learning Engineer – Associate\n"
                      "• Battle-tested: FraudLens (PR-AUC 0.8589), Leaf Compass (CNN 38 classes)\n"
                      "• Disciplines: Python, Django REST, FastAPI, Docker, Flutter, PostgreSQL",
                      style: WitcherTypography.parchmentBody.copyWith(
                        fontSize: 11.5,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Fold crease 2 (visual shadow fold)
                    _buildHorizontalFoldShadow(),
                    const SizedBox(height: 12),

                    // Fold 3: Guild Reward
                    Text(
                      "REWARD & TERMS",
                      style: WitcherTypography.parchmentFolio.copyWith(
                        color: WitcherColors.inkGold,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Competitive honorarium, engineering autonomy, and high-impact production leadership. "
                      "Inquiries may be dispatched via Raven or Direct Courier.",
                      style: WitcherTypography.parchmentBody.copyWith(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // The Authentic Red Wax Seal stamped at the bottom fold
              Positioned(
                bottom: 6,
                right: 20,
                child: WitcherWaxSeal(
                  size: 48,
                  symbol: '🐺',
                  tooltip: "Official Seal of the School of the Wolf",
                  onTap: () {
                    WitcherAudio.seal();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Right Page: Courier Dispatch & Dual Dossier
  Widget _buildDispatchLeaf(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comms Section Header
        Text(
          "RAVEN & GUILD MESSENGERS",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),

        // Quick Raven Buttons (Gmail & WhatsApp)
        Row(
          children: [
            Expanded(
              child: _buildMessengerButton(
                icon: Icons.email_rounded,
                title: "DISPATCH RAVEN",
                subtitle: "Direct Gmail Compose",
                color: WitcherColors.inkCrimson,
                onTap: () => _launchUrl(ResumeData.gmailComposeUrl),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMessengerButton(
                icon: Icons.chat_bubble_rounded,
                title: "GUILD COURIER",
                subtitle: "WhatsApp Channel",
                color: const Color(0xFF1E6B38),
                onTap: () => _launchUrl(ResumeData.whatsAppUrl),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Inscribed Dispatch Form
        Text(
          "INSCRIBE A DIRECT DISPATCH",
          style: WitcherTypography.parchmentFolio.copyWith(
            color: WitcherColors.inkGold,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: WitcherBookTheme.cardInsetDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildManuscriptTextField(
                controller: _nameController,
                label: "Guildmaster / Your Name",
                icon: Icons.person_rounded,
              ),
              const SizedBox(height: 8),
              _buildManuscriptTextField(
                controller: _emailController,
                label: "Return Raven / Email Address",
                icon: Icons.alternate_email_rounded,
              ),
              const SizedBox(height: 8),
              _buildManuscriptTextField(
                controller: _messageController,
                label: "Inscribe your contract dispatch or message...",
                icon: Icons.edit_note_rounded,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Center(
                child: WitcherWaxSeal(
                  size: 46,
                  icon: Icons.send_rounded,
                  label: _isSent ? "DISPATCH SENT!" : "SEND DISPATCH",
                  tooltip: "Deliver message via electronic raven",
                  onTap: _sendDispatch,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Dual Dossier Download Section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFBAA77F),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: WitcherColors.inkGold, width: 1.2),
          ),
          child: Row(
            children: [
              WitcherWaxSeal(
                size: 48,
                icon: Icons.download_rounded,
                tooltip: "Download Dossier",
                onTap: () {
                  WitcherAudio.downloadResume();
                },
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CLAIM WITCHER DOSSIER",
                      style: WitcherTypography.parchmentHeading.copyWith(
                        fontSize: 13.5,
                        color: WitcherColors.inkCrimson,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "One click retrieves Anshul's verified Curriculum Vitae & AWS ML Engineer Associate credentials.",
                      style: WitcherTypography.parchmentBody.copyWith(
                        fontSize: 11,
                        color: WitcherColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalFoldShadow() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.12),
            Colors.transparent,
            Colors.white.withValues(alpha: 0.35),
          ],
        ),
      ),
    );
  }

  Widget _buildMessengerButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          WitcherAudio.click();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: WitcherBookTheme.cardInsetDecoration(),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: WitcherTypography.parchmentFolio.copyWith(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: WitcherTypography.parchmentBody.copyWith(
                        fontSize: 10,
                        color: WitcherColors.inkMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManuscriptTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        color: WitcherColors.inkPrimary,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 16, color: WitcherColors.inkMuted),
        hintText: label,
        hintStyle: const TextStyle(
          fontFamily: 'Marcellus',
          fontSize: 11.5,
          color: WitcherColors.inkMuted,
        ),
        filled: true,
        fillColor: const Color(0xFFB2A078),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: Color(0xFFA6936C), width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: WitcherColors.inkCrimson, width: 1.2),
        ),
      ),
    );
  }
}
