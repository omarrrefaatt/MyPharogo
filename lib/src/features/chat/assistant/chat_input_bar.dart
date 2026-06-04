import 'package:flutter/material.dart';
import '../decorations/chat_constants.dart';
import '../chat/chat_theme.dart';

/// Bottom input bar: text field + send button + camera button.
///
/// All callbacks are passed in so this widget stays purely presentational.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    required this.onCamera,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;
  final VoidCallback onCamera;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        gradient: ChatTheme.inputBarGradientFor(context),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Camera button
            _CircleButton(
              decoration: ChatTheme.cameraButtonDecorationFor(context),
              onPressed: isLoading ? null : onCamera,
              child: Icon(
                Icons.camera_alt_outlined,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),

            // Text field
            Expanded(
              child: Container(
                decoration: ChatTheme.inputContainerDecorationFor(context),
                child: TextField(
                  controller: controller,
                  style: ChatTheme.assistantMessageTextFor(context).copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                  ),
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) {
                    if (!isLoading && controller.text.trim().isNotEmpty) {
                      onSend();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: ChatConstants.inputHint,
                    hintStyle: ChatTheme.hintText(context),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Send button
            _CircleButton(
              decoration:
                  isLoading
                      ? ChatTheme.sendButtonDecorationFor(context).copyWith(
                        // muted while loading
                        boxShadow: [],
                      )
                      : ChatTheme.sendButtonDecorationFor(context),
              onPressed: isLoading ? null : onSend,
              child:
                  isLoading
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                      : Icon(
                        Icons.send_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.decoration,
    required this.child,
    this.onPressed,
  });

  final BoxDecoration decoration;
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: onPressed == null ? 0.45 : 1.0,
        child: Container(
          width: 46,
          height: 46,
          decoration: decoration,
          child: Center(child: child),
        ),
      ),
    );
  }
}
