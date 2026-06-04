/// All static strings and constants for the Egyptian chatbot.
abstract class ChatConstants {
  // ── API ───────────────────────────────────────────────────────────────────
  static const String geminiModel = 'gemini-2.5-flash';
  static String geminiUrl(String apiKey) =>
      'https://generativelanguage.googleapis.com/v1beta/models/$geminiModel:generateContent?key=$apiKey';

  // ── System Prompt ─────────────────────────────────────────────────────────
  static const String assistantSystemPrompt =
      'You are a virtual Egyptian museum tour guide inside a mobile app. '
      'You speak with warmth, pride, and deep knowledge about ancient Egyptian history, '
      'pharaohs, gods, pyramids, and artifacts. Your tone is friendly, educational, and '
      'enthusiastic—like a real guide walking visitors through the wonders of Egypt. '
      'Use simple but captivating language, include cultural expressions like '
      '"Ahlan wa sahlan!" or "You won\'t believe what happened next!", and tell short '
      'stories from ancient dynasties, temples, and legends. '
      'You should: '
      '- Answer user questions about pharaohs, gods, battles, inventions, and daily life. '
      '- Describe historical sites and artifacts as if you\'re standing beside them. '
      '- Add fun facts and context that make history exciting and easy to understand. '
      '- Offer respectful humor and folklore references when appropriate. '
      'You are here to educate and fascinate, just like a personal guide through the land of the pharaohs!';

  static const String imageAnalysisPrompt =
      'Please analyze this image of what appears to be an Egyptian artifact or historical item. '
      'As an Egyptian museum guide, provide detailed information about what you see, including '
      'historical context, significance, time period, cultural importance, and any interesting '
      'stories or facts related to it. If it\'s not clearly Egyptian, please still provide '
      'educational information about what you observe and relate it to Egyptian history if possible.';

  // ── Welcome Message ───────────────────────────────────────────────────────
  static const String welcomeMessage =
      '🏺 Ahlan wa sahlan! Welcome to the Egyptian Museum! 🏺\n\n'
      'I am your virtual tour guide, ready to take you on an incredible journey through '
      '5,000 years of ancient Egyptian history! From the mighty pharaohs to the mysterious '
      'gods, from towering pyramids to precious artifacts — I am here to share the wonders '
      'of ancient Egypt with you.\n\n'
      'What would you like to explore today? Ask me about pharaohs like Tutankhamun or '
      'Cleopatra, the secrets of mummification, the construction of the Great Pyramid, '
      'or anything else that sparks your curiosity about the land of the Nile! ✨';

  // ── UI Strings ────────────────────────────────────────────────────────────
  static const String headerTitle = 'Egyptian Museum Guide';
  static const String headerSubtitle = 'Your journey through ancient Egypt';
  static const String inputHint = 'Ask about ancient Egypt…';
  static const String assistantName = 'Khepri';
  static const String userName = 'Visitor';

  // ── Error / Status Messages ───────────────────────────────────────────────
  static const String errorConnection =
      'The sands of time have caused a brief interruption. '
      'Please try again in a moment! 🏺';
  static const String errorImageAnalysis =
      'I apologize, but the ancient spirits are making it difficult to read your image '
      'right now. Please try again! 🏺✨';
  static const String errorPermissionCamera =
      'Please grant Camera permission to share images of Egyptian artifacts.';
  static const String errorPermissionGallery =
      'Please grant Gallery permission to share images of Egyptian artifacts.';

  // ── Image Source Sheet ────────────────────────────────────────────────────
  static const String imageSheetTitle = 'Share an Egyptian Artifact 🏺';
  static const String imageSheetSubtitle =
      'Photograph or choose an artifact to learn its history.';

  // ── Dialog Labels ─────────────────────────────────────────────────────────
  static const String dialogCancel = 'Cancel';
  static const String dialogSettings = 'Settings';
  static const String dialogOk = 'OK';
  static const String dialogErrorTitle = 'Connection Issue';
  static const String dialogPermissionTitle = 'Permission Required';

  // ── Image Upload ──────────────────────────────────────────────────────────
  static const String imageUserText = '📸 Please tell me about this artifact!';
  static const int imageMaxDimension = 1024;
  static const int imageQuality = 85;
}
