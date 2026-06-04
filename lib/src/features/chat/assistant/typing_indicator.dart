import 'package:flutter/material.dart';
import '../chat/chat_theme.dart';

/// Three-dot animated typing indicator shown while the assistant is generating.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  static const int _dotCount = 3;
  static const int _stepMs = 180;
  static const double _dotSize = 8;
  static const double _raisedShift = -6;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_dotCount, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 540),
      );
      Future.delayed(Duration(milliseconds: i * _stepMs), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
      return ctrl;
    });

    _animations =
        _controllers
            .map(
              (c) => Tween<double>(
                begin: 0,
                end: _raisedShift,
              ).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)),
            )
            .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Ghost avatar
          Container(
            width: 34,
            height: 34,
            decoration: ChatTheme.avatarDecorationFor(context),
            child: const Center(
              child: Text('𓂀', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: ChatTheme.assistantBubbleDecorationFor(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_dotCount, (i) {
                return AnimatedBuilder(
                  animation: _animations[i],
                  builder:
                      (_, __) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        transform: Matrix4.translationValues(
                          0,
                          _animations[i].value,
                          0,
                        ),
                        width: _dotSize,
                        height: _dotSize,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary
                              .withOpacity(0.7 + 0.3 * (i / _dotCount)),
                          shape: BoxShape.circle,
                        ),
                      ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
