import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:finalproject/src/shared/theme/colors.dart';
import 'package:finalproject/src/shared/ui/image_source_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'chat_message.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiChatWidget extends StatefulWidget {
  const GeminiChatWidget({super.key});

  @override
  State<GeminiChatWidget> createState() => _GeminiChatWidgetState();
}

class _GeminiChatWidgetState extends State<GeminiChatWidget>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  // Typing indicator animation
  late final AnimationController _typingAnimController;

  String? get apiKey => dotenv.env['GEMINI_API_KEY'];

  final String assistantPrompt =
      "You are a virtual Egyptian museum tour guide inside a mobile app. You speak with warmth, "
      "pride, and deep knowledge about ancient Egyptian history, pharaohs, gods, pyramids, and "
      "artifacts. Your tone is friendly, educational, and enthusiastic—like a real guide walking "
      "visitors through the wonders of Egypt. Use simple but captivating language, include cultural "
      "expressions like Ahlan wa sahlan! or You won't believe what happened next!, and tell short "
      "stories from ancient dynasties, temples, and legends. "
      "You should: "
      "- Answer user questions about pharaohs, gods, battles, inventions, and daily life "
      "- Describe historical sites and artifacts as if you're standing beside them "
      "- Add fun facts and context that make history exciting and easy to understand "
      "- Offer respectful humor and folklore references when appropriate "
      "You are here to educate and fascinate, just like a personal guide through the land of the pharaohs!";

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _typingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _messages.add(
      ChatMessage(sender: 'You', role: 'user', text: assistantPrompt),
    );
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _typingAnimController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Welcome message ──────────────────────────────────────────────────────

  void _addWelcomeMessage() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            role: 'model',
            sender: 'Assistant',
            text:
                '🏺 Ahlan wa sahlan! Welcome to the Egyptian Museum! 🏺\n\n'
                'I am your virtual tour guide, ready to take you on an incredible journey through '
                '5,000 years of ancient Egyptian history! From the mighty pharaohs to the mysterious '
                'gods, from towering pyramids to precious artifacts — I\'m here to share the wonders '
                'of ancient Egypt with you.\n\n'
                'What would you like to explore today? Ask me about pharaohs like Tutankhamun or '
                'Cleopatra, the secrets of mummification, the construction of the Great Pyramid, '
                'or anything else that sparks your curiosity about the land of the Nile! ✨',
          ),
        );
      });
    });
  }

  // ── Scroll ───────────────────────────────────────────────────────────────

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Image handling ───────────────────────────────────────────────────────

  Future<void> _showImageSourceDialog() async {
    await showImageSourceSheet(
      context,
      title: 'Share an Egyptian Artifact! 🏺',
      subtitle:
          'Take a photo or choose from gallery to learn more about Egyptian artifacts.',
      onImageSelected: (source) => _pickImage(source),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (status != PermissionStatus.granted) {
          _showPermissionDialog('Camera');
          return;
        }
      } else {
        final status = await Permission.photos.request();
        if (status != PermissionStatus.granted) {
          _showPermissionDialog('Gallery');
          return;
        }
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) await _sendImageMessage(image);
    } catch (e) {
      _showErrorDialog('Failed to pick image: ${e.toString()}');
    }
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────

  void _showPermissionDialog(String permission) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text('Permission Required'),
              ],
            ),
            content: Text(
              'Please grant $permission permission to share images of Egyptian artifacts.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text('Something went wrong'),
              ],
            ),
            content: Text(message),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // ── API — image message ──────────────────────────────────────────────────

  Future<void> _sendImageMessage(XFile image) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    setState(() {
      _messages.add(
        ChatMessage(
          role: 'user',
          text:
              '📸 [Image shared] Please tell me about this Egyptian artifact!',
          sender: 'You',
          imageFile: File(image.path),
        ),
      );
      _isLoading = true;
    });
    _scrollToBottom();

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
    );

    const imagePrompt =
        'Please analyze this image of what appears to be an Egyptian artifact or historical item. '
        'As an Egyptian museum guide, provide detailed information about what you see, including '
        'historical context, significance, time period, cultural importance, and any interesting '
        'stories or facts related to it. If it\'s not clearly Egyptian, please still provide '
        'educational information about what you observe and relate it to Egyptian history if possible.';

    final requestBody = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': imagePrompt},
            {
              'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image},
            },
          ],
        },
      ],
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (reply != null) {
          setState(() {
            _messages.add(
              ChatMessage(role: 'model', text: reply, sender: 'Assistant'),
            );
          });
          _scrollToBottom();
        }
      } else {
        _addErrorReply(
          'I apologize, but I\'m having trouble analyzing your image right now. '
          'Please try again in a moment! The ancient spirits of the Nile sometimes '
          'make technology a bit temperamental! 🏺✨',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _addErrorReply(
        'I apologize, but I encountered an issue analyzing your image. Please try again! 🏺',
      );
    }
  }

  // ── API — text message ───────────────────────────────────────────────────

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      _messages.add(
        ChatMessage(role: 'user', text: userMessage, sender: 'You'),
      );
      _isLoading = true;
    });
    _scrollToBottom();

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
    );

    final history =
        _messages
            .map(
              (msg) => {
                'role': msg.role,
                'parts': [
                  {'text': msg.text},
                ],
              },
            )
            .toList();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'contents': history}),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (reply != null) {
          setState(() {
            _messages.add(
              ChatMessage(role: 'model', text: reply, sender: 'Assistant'),
            );
          });
          _scrollToBottom();
        }
      } else {
        _addErrorReply(
          'I\'m having trouble connecting right now. Please try again in a moment! 🏺',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _addErrorReply(
        'I\'m having trouble connecting right now. Please try again! 🏺',
      );
    }
  }

  void _addErrorReply(String text) {
    setState(() {
      _messages.add(
        ChatMessage(role: 'model', sender: 'Assistant', text: text),
      );
    });
  }

  // ════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Container(
      // Subtle papyrus / obsidian tinted background
      decoration: BoxDecoration(
        color: isDark ? AppColors.obsidian : AppColors.desertSand,
      ),
      child: Column(
        children: [
          _buildChatHeader(context, isDark, goldColor),
          _buildMessageList(context, isDark, goldColor),
          _buildInputBar(context, isDark, goldColor),
        ],
      ),
    );
  }

  // ── Chat header ──────────────────────────────────────────────────────────

  Widget _buildChatHeader(BuildContext context, bool isDark, Color goldColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkTomb : AppColors.papyrus,
        border: Border(
          bottom: BorderSide(color: goldColor.withOpacity(0.25), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: goldColor.withOpacity(isDark ? 0.10 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Guide avatar badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [AppColors.ancientAmber, AppColors.deepGold]
                        : [AppColors.pharaohGold, AppColors.deepGold],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: goldColor.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text('🏺', style: TextStyle(fontSize: 22)),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Egyptian Museum Guide',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'Cinzel',
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.osirisGreen,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.osirisGreen.withOpacity(0.50),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Your guide through 5,000 years of history',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Clear chat button
          IconButton(
            onPressed: () => _showClearChatDialog(context),
            icon: Icon(
              Icons.restart_alt_rounded,
              color: goldColor.withOpacity(0.70),
              size: 22,
            ),
            tooltip: 'Clear chat',
            style: IconButton.styleFrom(
              backgroundColor: goldColor.withOpacity(0.10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Start Over?'),
            content: const Text(
              'This will clear the current conversation and start fresh with your guide.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.clear();
                    _messages.add(
                      ChatMessage(
                        sender: 'You',
                        role: 'user',
                        text: assistantPrompt,
                      ),
                    );
                  });
                  _addWelcomeMessage();
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  // ── Message list ─────────────────────────────────────────────────────────

  Widget _buildMessageList(BuildContext context, bool isDark, Color goldColor) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: (_messages.length - 1) + (_isLoading ? 1 : 0),
        itemBuilder: (_, index) {
          if (_isLoading && index == _messages.length - 1) {
            return _buildTypingIndicator(isDark, goldColor);
          }

          final msg = _messages[index + 1]; // offset past system prompt
          final isUser = msg.role == 'user';

          return _ChatBubble(
            message: msg,
            isUser: isUser,
            isDark: isDark,
            goldColor: goldColor,
          );
        },
      ),
    );
  }

  // ── Typing indicator ─────────────────────────────────────────────────────

  Widget _buildTypingIndicator(bool isDark, Color goldColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Guide avatar
          _GuideAvatar(goldColor: goldColor),
          const SizedBox(width: 8),

          // Dots bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkScroll : AppColors.papyrus,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: goldColor.withOpacity(0.22), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 5 : 0),
                  child: _AnimatedDot(
                    controller: _typingAnimController,
                    index: i,
                    color: goldColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Input bar ────────────────────────────────────────────────────────────

  Widget _buildInputBar(BuildContext context, bool isDark, Color goldColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkTomb : AppColors.papyrus,
        border: Border(
          top: BorderSide(color: goldColor.withOpacity(0.22), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ── Attach image button ─────────────────────────────────────
            _InputActionButton(
              icon: Icons.add_photo_alternate_rounded,
              color: isDark ? AppColors.sacredTurquoise : AppColors.lapisLazuli,
              isDark: isDark,
              tooltip: 'Share artifact image',
              onPressed: _showImageSourceDialog,
            ),

            const SizedBox(width: 8),

            // ── Text field ───────────────────────────────────────────────
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkScroll : AppColors.desertSand,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: goldColor.withOpacity(0.30),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty && !_isLoading) {
                      sendMessage(value.trim());
                      _controller.clear();
                    }
                  },
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 15,
                    color: isDark ? AppColors.moonstone : AppColors.kohlBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask about ancient Egypt…',
                    hintStyle: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color:
                          isDark
                              ? AppColors.ghostGold.withOpacity(0.60)
                              : AppColors.papyrusText.withOpacity(0.70),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // ── Send button ──────────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    _isLoading
                        ? null
                        : LinearGradient(
                          colors:
                              isDark
                                  ? [AppColors.ancientAmber, AppColors.deepGold]
                                  : [AppColors.pharaohGold, AppColors.deepGold],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                color: _isLoading ? goldColor.withOpacity(0.25) : null,
                boxShadow:
                    _isLoading
                        ? []
                        : [
                          BoxShadow(
                            color: goldColor.withOpacity(0.40),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap:
                      _isLoading
                          ? null
                          : () {
                            if (_controller.text.trim().isNotEmpty) {
                              sendMessage(_controller.text.trim());
                              _controller.clear();
                            }
                          },
                  child: Center(
                    child: Icon(
                      _isLoading
                          ? Icons.hourglass_top_rounded
                          : Icons.send_rounded,
                      size: 20,
                      color:
                          _isLoading
                              ? goldColor.withOpacity(0.55)
                              : (isDark
                                  ? AppColors.obsidian
                                  : AppColors.kohlBlack),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  CHAT BUBBLE
// ═══════════════════════════════════════════════════════════════════════════════

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;
  final bool isDark;
  final Color goldColor;

  const _ChatBubble({
    required this.message,
    required this.isUser,
    required this.isDark,
    required this.goldColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Guide avatar (left of assistant message)
          if (!isUser) ...[
            _GuideAvatar(goldColor: goldColor),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.74,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient:
                      isUser
                          ? LinearGradient(
                            colors:
                                isDark
                                    ? [
                                      AppColors.ancientAmber,
                                      AppColors.deepGold,
                                    ]
                                    : [
                                      AppColors.pharaohGold,
                                      AppColors.deepGold,
                                    ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  color:
                      isUser
                          ? null
                          : (isDark ? AppColors.darkScroll : AppColors.papyrus),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isUser ? 20 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 20),
                  ),
                  border:
                      isUser
                          ? null
                          : Border.all(
                            color: goldColor.withOpacity(0.22),
                            width: 1,
                          ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isUser
                              ? goldColor.withOpacity(isDark ? 0.22 : 0.18)
                              : Colors.black.withOpacity(isDark ? 0.22 : 0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image preview
                    if (message.imageFile != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          message.imageFile!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Text
                    Text(
                      message.text,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 15,
                        height: 1.5,
                        color:
                            isUser
                                ? (isDark
                                    ? AppColors.obsidian
                                    : AppColors.kohlBlack)
                                : (isDark
                                    ? AppColors.moonstone
                                    : AppColors.kohlBlack),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // User avatar (right of user message)
          if (isUser) ...[
            const SizedBox(width: 8),
            _UserAvatar(goldColor: goldColor, isDark: isDark),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GUIDE AVATAR
// ═══════════════════════════════════════════════════════════════════════════════

class _GuideAvatar extends StatelessWidget {
  final Color goldColor;
  const _GuideAvatar({required this.goldColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [goldColor, goldColor.withOpacity(0.70)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: goldColor.withOpacity(0.30), blurRadius: 5),
        ],
      ),
      child: const Center(child: Text('🏺', style: TextStyle(fontSize: 15))),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  USER AVATAR
// ═══════════════════════════════════════════════════════════════════════════════

class _UserAvatar extends StatelessWidget {
  final Color goldColor;
  final bool isDark;
  const _UserAvatar({required this.goldColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.darkScroll : AppColors.sandstone,
        border: Border.all(color: goldColor, width: 1.8),
      ),
      child: const Center(child: Text('👤', style: TextStyle(fontSize: 15))),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ANIMATED TYPING DOT
// ═══════════════════════════════════════════════════════════════════════════════

class _AnimatedDot extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final Color color;

  const _AnimatedDot({
    required this.controller,
    required this.index,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Each dot bounces at a staggered offset
    final offsetBegin = index * 0.2;
    final offsetEnd = offsetBegin + 0.4;

    final bounce = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -6.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -6.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(offsetBegin.clamp(0.0, 1.0), offsetEnd.clamp(0.0, 1.0)),
      ),
    );

    return AnimatedBuilder(
      animation: bounce,
      builder:
          (_, __) => Transform.translate(
            offset: Offset(0, bounce.value),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  INPUT ACTION BUTTON  (attach / camera)
// ═══════════════════════════════════════════════════════════════════════════════

class _InputActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isDark;
  final String tooltip;
  final VoidCallback onPressed;

  const _InputActionButton({
    required this.icon,
    required this.color,
    required this.isDark,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(isDark ? 0.16 : 0.11),
              border: Border.all(
                color: color.withOpacity(isDark ? 0.35 : 0.25),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
        ),
      ),
    );
  }
}
