import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../decorations/chat_constants.dart';
import 'chat_message.dart';

/// Encapsulates all communication with the Gemini REST API.
/// Keeps networking logic completely out of the widget tree.
class GeminiService {
  GeminiService({required this.apiKey});

  final String apiKey;

  String get _url => ChatConstants.geminiUrl(apiKey);

  // ── Text chat ─────────────────────────────────────────────────────────────

  /// Sends [history] to the model and returns the assistant's reply text,
  /// or throws a [GeminiException] on failure.
  Future<String> sendTextHistory(List<ChatMessage> history) async {
    final contents = history.map((m) => m.toApiPart()).toList();

    final response = await http.post(
      Uri.parse(_url),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'contents': contents}),
    );

    return _parseResponse(response);
  }

  // ── Image + text ──────────────────────────────────────────────────────────

  /// Encodes [imageFile] and sends it to the model with the default
  /// artifact analysis prompt. Returns the reply text.
  Future<String> analyzeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final requestBody = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': ChatConstants.imageAnalysisPrompt},
            {
              'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image},
            },
          ],
        },
      ],
    };

    final response = await http.post(
      Uri.parse(_url),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    return _parseResponse(response);
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  String _parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (reply is String && reply.isNotEmpty) return reply;
      throw const GeminiException('Empty reply from model.');
    }

    throw GeminiException(
      'HTTP ${response.statusCode}: ${response.reasonPhrase}',
    );
  }
}

/// Typed exception for Gemini API errors.
class GeminiException implements Exception {
  const GeminiException(this.message);
  final String message;

  @override
  String toString() => 'GeminiException: $message';
}
