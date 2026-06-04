import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../indicator/chat_bubble.dart';
import '../decorations/chat_constants.dart';
import '../assistant/chat_dialogs.dart';
import '../decorations/chat_header.dart';
import '../assistant/chat_input_bar.dart';
import 'chat_message.dart';
import 'chat_theme.dart';
import 'gemini_service.dart';
import '../assistant/typing_indicator.dart';

// ignore: depend_on_referenced_packages
import 'package:finalproject/src/shared/ui/image_source_sheet.dart';

/// Root widget for the Egyptian Museum AI chat feature.
///
/// Architecture:
///   GeminiChatWidget (state holder)
///   ├── ChatHeader          — presentational
///   ├── ListView (ChatBubble, TypingIndicator)
///   └── ChatInputBar        — presentational
///   [GeminiService]         — network layer (no widgets)
///   [ChatDialogs]           — static dialog helpers
///   [ChatTheme]             — design tokens
///   [ChatConstants]         — strings & config
class GeminiChatWidget extends StatefulWidget {
  const GeminiChatWidget({super.key});

  @override
  State<GeminiChatWidget> createState() => _GeminiChatWidgetState();
}

class _GeminiChatWidgetState extends State<GeminiChatWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ── State ─────────────────────────────────────────────────────────────────

  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  late final GeminiService _gemini;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _gemini = GeminiService(apiKey: dotenv.env['GEMINI_API_KEY'] ?? '');

    // Seed the conversation with the system prompt (hidden from the UI).
    _messages.add(
      ChatMessage(
        role: 'user',
        text: ChatConstants.assistantSystemPrompt,
        sender: ChatConstants.userName,
      ),
    );

    // Delayed welcome so the user sees the screen first.
    Future.delayed(const Duration(milliseconds: 400), _addWelcomeMessage);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Welcome ───────────────────────────────────────────────────────────────

  void _addWelcomeMessage() {
    if (!mounted) return;
    setState(() {
      _messages.add(
        ChatMessage(
          role: 'model',
          text: ChatConstants.welcomeMessage,
          sender: ChatConstants.assistantName,
        ),
      );
    });
    _scrollToBottom();
  }

  // ── Scrolling ─────────────────────────────────────────────────────────────

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

  // ── Text chat ─────────────────────────────────────────────────────────────

  Future<void> _sendText() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;
    _controller.clear();

    setState(() {
      _messages.add(
        ChatMessage(role: 'user', text: text, sender: ChatConstants.userName),
      );
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final reply = await _gemini.sendTextHistory(_messages);
      _appendAssistantMessage(reply);
    } on GeminiException catch (_) {
      _appendAssistantMessage(ChatConstants.errorConnection);
    } catch (_) {
      _appendAssistantMessage(ChatConstants.errorConnection);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Image chat ────────────────────────────────────────────────────────────

  Future<void> _showImageSourceDialog() async {
    await showImageSourceSheet(
      context,
      title: ChatConstants.imageSheetTitle,
      subtitle: ChatConstants.imageSheetSubtitle,
      onImageSelected: _pickImage,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);

    // Permission check
    final PermissionStatus status =
        source == ImageSource.camera
            ? await Permission.camera.request()
            : await Permission.photos.request();

    if (status != PermissionStatus.granted) {
      if (mounted) {
        await ChatDialogs.showPermission(
          context,
          permissionLabel: source == ImageSource.camera ? 'Camera' : 'Gallery',
        );
      }
      return;
    }

    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: ChatConstants.imageMaxDimension.toDouble(),
        maxHeight: ChatConstants.imageMaxDimension.toDouble(),
        imageQuality: ChatConstants.imageQuality,
      );
      if (picked == null) return;
      await _sendImage(picked);
    } catch (e) {
      if (mounted) await ChatDialogs.showError(context, e.toString());
    }
  }

  Future<void> _sendImage(XFile picked) async {
    setState(() {
      _messages.add(
        ChatMessage(
          role: 'user',
          text: ChatConstants.imageUserText,
          sender: ChatConstants.userName,
          imageFile: File(picked.path),
        ),
      );
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final reply = await _gemini.analyzeImage(File(picked.path));
      _appendAssistantMessage(reply);
    } on GeminiException catch (_) {
      _appendAssistantMessage(ChatConstants.errorImageAnalysis);
    } catch (_) {
      _appendAssistantMessage(ChatConstants.errorImageAnalysis);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _appendAssistantMessage(String text) {
    if (!mounted) return;
    setState(() {
      _messages.add(
        ChatMessage(
          role: 'model',
          text: text,
          sender: ChatConstants.assistantName,
        ),
      );
    });
    _scrollToBottom();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Visible message count: skip index 0 (system prompt).
    final visibleCount = (_messages.length - 1) + (_isLoading ? 1 : 0);

    return Container(
      decoration: BoxDecoration(
        gradient: ChatTheme.backgroundGradientFor(context),
      ),
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          const ChatHeader(),

          // ── Message list ──────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 14),
              itemCount: visibleCount,
              itemBuilder: (_, index) {
                // Show typing indicator as the last item while loading.
                if (_isLoading && index == _messages.length - 1) {
                  return const TypingIndicator();
                }
                final msg = _messages[index + 1]; // +1 to skip system prompt
                return ChatBubble(message: msg);
              },
            ),
          ),

          // ── Input bar ─────────────────────────────────────────────────────
          ChatInputBar(
            controller: _controller,
            isLoading: _isLoading,
            onSend: _sendText,
            onCamera: _showImageSourceDialog,
          ),
        ],
      ),
    );
  }
}
