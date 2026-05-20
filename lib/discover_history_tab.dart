import 'package:flutter/material.dart';
import 'gemini_chat_widget.dart';

class DiscoverHistoryTab extends StatelessWidget {
  const DiscoverHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Unique key for separate state
    return const GeminiChatWidget(key: Key('history_chat'));
  }
}
