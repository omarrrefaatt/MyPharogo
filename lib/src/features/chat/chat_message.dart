import 'dart:io';

class ChatMessage {
  final String role;
  final String text;
  final String sender;
  final File? imageFile; // Add support for images

  ChatMessage({
    required this.role,
    required this.text,
    required this.sender,
    this.imageFile,
  });
}
