import 'dart:io';

/// Represents a single message in the Egyptian museum chat.
class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.text,
    required this.sender,
    this.imageFile,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? const _NowPlaceholder();
    // Use factory if you need real DateTime — see note below.

  final String    role;      // "user" | "model"
  final String    text;
  final String    sender;
  final File?     imageFile; // non-null for image messages
  final dynamic   timestamp; // keep as DateTime in your real project

  bool get isUser      => role == 'user';
  bool get isAssistant => role == 'model';
  bool get hasImage    => imageFile != null;

  /// Serialise to the Gemini API contents format (text-only messages).
  Map<String, dynamic> toApiPart() => {
    'role': role,
    'parts': [
      {'text': text},
    ],
  };
}

// ---------------------------------------------------------------------------
// Workaround placeholder — replace with `DateTime.now()` via a factory once
// you wire up real timestamps in your project.
// ---------------------------------------------------------------------------
class _NowPlaceholder {
  const _NowPlaceholder();
}
