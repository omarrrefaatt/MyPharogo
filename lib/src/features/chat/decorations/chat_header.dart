import 'package:flutter/material.dart';
import 'chat_constants.dart';
import '../chat/chat_theme.dart';

/// Decorative header bar shown at the top of the chat screen.
class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        gradient: ChatTheme.headerGradientFor(context),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Guide avatar
              Container(
                width: 44,
                height: 44,
                decoration: ChatTheme.avatarDecorationFor(context),
                child: const Center(
                  child: Text('𓂀', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ChatConstants.headerTitle,
                      style: ChatTheme.headerTitleFor(context),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ChatConstants.headerSubtitle,
                      style: ChatTheme.headerSubtitleFor(context),
                    ),
                  ],
                ),
              ),

              // Status indicator
              _OnlineIndicator(),
            ],
          ),

          const SizedBox(height: 10),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Theme.of(context).colorScheme.secondary.withOpacity(0.18),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.35),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _OnlineIndicator extends StatefulWidget {
  @override
  State<_OnlineIndicator> createState() => _OnlineIndicatorState();
}

class _OnlineIndicatorState extends State<_OnlineIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scale,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Theme.of(context).colorScheme.secondary.withOpacity(0.18),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.35),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'Online',
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.secondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
