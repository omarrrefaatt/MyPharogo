import 'package:flutter/material.dart';
import '../chat/chat_message.dart';
import '../chat/chat_theme.dart';

/// Renders a single chat bubble (user or assistant) with optional image.
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[_AssistantAvatar(), const SizedBox(width: 8)],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.74,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration:
                    isUser
                        ? ChatTheme.userBubbleDecorationFor(context)
                        : ChatTheme.assistantBubbleDecorationFor(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.hasImage) ...[
                      _ImagePreview(imageFile: message.imageFile!),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      message.text,
                      style:
                          isUser
                              ? ChatTheme.userMessageTextFor(context)
                              : ChatTheme.assistantMessageTextFor(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isUser) ...[const SizedBox(width: 8), _UserAvatar()],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AssistantAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: ChatTheme.avatarDecorationFor(context),
      child: const Center(
        child: Text('𓂀', style: TextStyle(fontSize: 18)),
        // Egyptian eye of Horus — substitute with an asset image if preferred.
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: ChatTheme.userAvatarDecorationFor(context),
      child: Icon(
        Icons.person,
        size: 18,
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imageFile});
  final dynamic imageFile; // File in real project

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        imageFile,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
