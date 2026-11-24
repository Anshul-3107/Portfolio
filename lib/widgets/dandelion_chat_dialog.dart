import 'package:flutter/material.dart';
import '../core/audio/witcher_audio.dart';
import '../core/theme/witcher_colors.dart';
import '../core/theme/witcher_typography.dart';
import '../services/dandelion_service.dart';
import 'witcher_card.dart';

class DandelionChatWidget extends StatefulWidget {
  const DandelionChatWidget({super.key});

  @override
  State<DandelionChatWidget> createState() => DandelionChatWidgetState();
}

class DandelionChatWidgetState extends State<DandelionChatWidget> {
  bool _isOpen = false;
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void openChat() {
    if (!_isOpen) {
      setState(() => _isOpen = true);
      WitcherAudio.sign();
      _scrollToBottom();
    }
  }

  void toggleChat() {
    _toggleChat();
  }

  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'dandelion',
      text:
          "Greetings, noble traveler! I am Dandelion—maestro of ballads, master scribe, and personal chronicler to Anshul of AI, Grandmaster of the Neural School!\n\n"
          "What tales seek you? His battle against financial fraud in FraudLens, his botanical vision runes in Leaf Compass, or his AWS credentials?",
    ),
  ];

  final List<String> _suggestedPrompts = [
    "Tell me of FraudLens",
    "What is Leaf Compass?",
    "Explain InfraIntel",
    "What is his AWS Certification?",
    "How can I hire Anshul?",
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() => _isOpen = !_isOpen);
    WitcherAudio.sign();
    if (_isOpen) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSubmitted(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isLoading) return;

    _textController.clear();
    WitcherAudio.click();

    setState(() {
      _messages.add(ChatMessage(sender: 'user', text: trimmed));
      _isLoading = true;
    });
    _scrollToBottom();

    final reply = await DandelionService.sendMessage(
      message: trimmed,
      history: _messages,
    );

    if (mounted) {
      setState(() {
        _messages.add(ChatMessage(sender: 'dandelion', text: reply));
        _isLoading = false;
      });
      WitcherAudio.tab();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Positioned(
      bottom: isMobile ? 16 : 36,
      right: isMobile ? 12 : 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isOpen) _buildChatWindow(context),
          if (_isOpen) const SizedBox(height: 10),
          _buildFloatingButton(isMobile),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => WitcherAudio.hover(),
      child: GestureDetector(
        onTap: _toggleChat,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 11 : 16,
            vertical: isMobile ? 7 : 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF14171E),
            border: Border.all(color: WitcherColors.goldBright, width: 1.5),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: WitcherColors.gold.withValues(alpha: 0.35),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isMobile ? 24 : 28,
                height: isMobile ? 24 : 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WitcherColors.gold.withValues(alpha: 0.2),
                  border: Border.all(color: WitcherColors.goldBright),
                ),
                child: Icon(
                  Icons.history_edu_rounded,
                  color: WitcherColors.goldBright,
                  size: isMobile ? 13 : 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isOpen
                    ? (isMobile ? "CLOSE" : "CLOSE SCRIBE")
                    : (isMobile ? "DANDELION" : "CONSULT DANDELION"),
                style: WitcherTypography.tagText.copyWith(
                  color: WitcherColors.goldBright,
                  fontSize: isMobile ? 10.5 : 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: isMobile ? 1.0 : 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatWindow(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isMobile = screenWidth < 600;
    final windowWidth = isMobile ? screenWidth - 24 : 420.0;
    final windowHeight = isMobile ? (screenHeight * 0.70).clamp(320.0, 520.0) : 520.0;

    return WitcherCard(
      borderColor: WitcherColors.goldBright,
      borderWidth: 1.5,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: windowWidth,
        height: windowHeight,
        child: Column(
          children: [
            _buildWindowHeader(),
            const Divider(color: WitcherColors.borderDark, height: 1),
            Expanded(child: _buildMessagesList()),
            if (_isLoading) _buildLoadingIndicator(),
            _buildSuggestedPrompts(),
            const Divider(color: WitcherColors.borderDark, height: 1),
            _buildInputRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildWindowHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF101217),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_stories_rounded,
                color: WitcherColors.goldBright,
                size: 18,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "DANDELION",
                    style: WitcherTypography.titleSmall.copyWith(
                      color: WitcherColors.goldBright,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    "MASTER SCRIBE & CHRONICLER",
                    style: WitcherTypography.metricLabel.copyWith(
                      color: WitcherColors.textMuted,
                      fontSize: 8.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _toggleChat,
              child: const Icon(
                Icons.close_rounded,
                color: WitcherColors.textMuted,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(14),
      physics: const BouncingScrollPhysics(),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isDandelion = message.sender == 'dandelion';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isDandelion ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isDandelion) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: WitcherColors.gold.withValues(alpha: 0.2),
                    border: Border.all(color: WitcherColors.goldBright, width: 1),
                  ),
                  child: const Icon(
                    Icons.history_edu_rounded,
                    color: WitcherColors.goldBright,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDandelion
                        ? const Color(0xFF1E222B)
                        : const Color(0xFF14171E),
                    border: Border.all(
                      color: isDandelion
                          ? WitcherColors.goldMuted.withValues(alpha: 0.7)
                          : WitcherColors.borderDark,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    message.text,
                    style: WitcherTypography.bodyMedium.copyWith(
                      color: isDandelion
                          ? WitcherColors.textParchmentLight
                          : WitcherColors.textParchment,
                      fontSize: 12.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              if (!isDandelion) const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: WitcherColors.goldBright,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Dandelion is tuning his lute...",
            style: WitcherTypography.bodySmall.copyWith(
              color: WitcherColors.goldMuted,
              fontStyle: FontStyle.italic,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedPrompts() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: const Color(0xFF101217),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: _suggestedPrompts.map((prompt) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _handleSubmitted(prompt),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D24),
                      border: Border.all(
                        color: WitcherColors.goldMuted.withValues(alpha: 0.6),
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      prompt,
                      style: WitcherTypography.tagText.copyWith(
                        color: WitcherColors.goldBright,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInputRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFF14171E),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: WitcherTypography.bodyMedium.copyWith(
                color: WitcherColors.textParchmentLight,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: "Ask of Anshul's deeds...",
                hintStyle: WitcherTypography.bodySmall.copyWith(
                  color: WitcherColors.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _handleSubmitted(_textController.text),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: WitcherColors.gold.withValues(alpha: 0.2),
                  border: Border.all(color: WitcherColors.goldBright),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: WitcherColors.goldBright,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
