import 'dart:convert';
import 'dart:io';
import 'package:finalproject/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ChatMessage.dart';

class GeminiChatWidget extends StatefulWidget {
  const GeminiChatWidget({super.key});

  @override
  State<GeminiChatWidget> createState() => _GeminiChatWidgetState();
}

class _GeminiChatWidgetState extends State<GeminiChatWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  final String apiKey = 'AIzaSyC_dxECkqG4K_bAOpeGcVbBpbRE181NnPo';
  String assistantPrompt =
      "You are a virtual Egyptian museum tour guide inside a mobile app. You speak with warmth, pride, and deep knowledge about ancient Egyptian history, pharaohs, gods, pyramids, and artifacts. Your tone is friendly, educational, and enthusiastic—like a real guide walking visitors through the wonders of Egypt. Use simple but captivating language, include cultural expressions like Ahlan wa sahlan! or You won't believe what happened next!, and tell short stories from ancient dynasties, temples, and legends. "
      "You should: "
      "- Answer user questions about pharaohs, gods, battles, inventions, and daily life "
      "- Describe historical sites and artifacts as if you're standing beside them "
      "- Add fun facts and context that make history exciting and easy to understand "
      "- Offer respectful humor and folklore references when appropriate "
      "You are here to educate and fascinate, just like a personal guide through the land of the pharaohs!";

  // Egyptian theme colors
  static const Color primaryGold = AppColors.deepTeal;
  static const Color darkBlue = Color(0xFF1B2951);
  static const Color lightSand = Color(0xFFF5E6D3);
  static const Color papyrusBeige = Color(0xFFF0E68C);

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(sender: "You", role: "user", text: assistantPrompt),
    );

    // Add welcome message
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(
          ChatMessage(
            role: "model",
            text:
                "🏺 Ahlan wa sahlan! Welcome to the Egyptian Museum! 🏺\n\n"
                "I am your virtual tour guide, ready to take you on an incredible journey through "
                "5,000 years of ancient Egyptian history! From the mighty pharaohs to the mysterious "
                "gods, from towering pyramids to precious artifacts - I'm here to share the wonders "
                "of ancient Egypt with you.\n\n"
                "What would you like to explore today? Ask me about pharaohs like Tutankhamun or "
                "Cleopatra, the secrets of mummification, the construction of the Great Pyramid, "
                "or anything else that sparks your curiosity about the land of the Nile! ✨",
            sender: "Assistant",
          ),
        );
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Share an Egyptian Artifact! 🏺',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Take a photo or choose from gallery to learn more about Egyptian artifacts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: darkBlue.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildImageSourceButton(
                              icon: Icons.camera_alt,
                              label: 'Camera',
                              onTap: () => _pickImage(ImageSource.camera),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildImageSourceButton(
                              icon: Icons.photo_library,
                              label: 'Gallery',
                              onTap: () => _pickImage(ImageSource.gallery),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryGold, primaryGold.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: primaryGold.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: darkBlue, size: 32),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Close the bottom sheet

    try {
      // Request permissions
      if (source == ImageSource.camera) {
        final cameraStatus = await Permission.camera.request();
        if (cameraStatus != PermissionStatus.granted) {
          _showPermissionDialog('Camera');
          return;
        }
      } else {
        final storageStatus = await Permission.photos.request();
        if (storageStatus != PermissionStatus.granted) {
          _showPermissionDialog('Gallery');
          return;
        }
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _sendImageMessage(image);
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: ${e.toString()}');
    }
  }

  void _showPermissionDialog(String permission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text(
            'Please grant $permission permission to share images of Egyptian artifacts.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendImageMessage(XFile image) async {
    // Convert image to base64
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Add user message with image
    setState(() {
      _messages.add(
        ChatMessage(
          role: "user",
          text:
              "📸 [Image shared] Please tell me about this Egyptian artifact!",
          sender: "You",
          imageFile: File(image.path), // Store the image file for display
        ),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=$apiKey',
    );

    // Prepare the request with image
    final imagePrompt =
        "Please analyze this image of what appears to be an Egyptian artifact or historical item. "
        "As an Egyptian museum guide, provide detailed information about what you see, including historical context, "
        "significance, time period, cultural importance, and any interesting stories or facts related to it. "
        "If it's not clearly Egyptian, please still provide educational information about what you observe and "
        "relate it to Egyptian history if possible.";

    final requestBody = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": imagePrompt},
            {
              "inline_data": {"mime_type": "image/jpeg", "data": base64Image},
            },
          ],
        },
      ],
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
        if (reply != null) {
          setState(() {
            _messages.add(
              ChatMessage(role: "model", text: reply, sender: "Assistant"),
            );
          });
          _scrollToBottom();
        }
      } else {
        setState(() {
          _messages.add(
            ChatMessage(
              sender: "Assistant",
              role: "model",
              text:
                  "I apologize, but I'm having trouble analyzing your image right now. "
                  "Please try again in a moment! The ancient spirits of the Nile sometimes "
                  "make technology a bit temperamental! 🏺✨",
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add(
          ChatMessage(
            sender: "Assistant",
            role: "model",
            text:
                "I apologize, but I encountered an issue while analyzing your image. "
                "Please try again! 🏺",
          ),
        );
      });
    }
  }

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      _messages.add(
        ChatMessage(role: "user", text: userMessage, sender: "You"),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=$apiKey',
    );

    final List<Map<String, dynamic>> history =
        _messages.map((msg) {
          return {
            "role": msg.role,
            "parts": [
              {"text": msg.text},
            ],
          };
        }).toList();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"contents": history}),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
        if (reply != null) {
          setState(() {
            _messages.add(
              ChatMessage(role: "model", text: reply, sender: "Assistant"),
            );
          });
          _scrollToBottom();
        }
      } else {
        setState(() {
          _messages.add(
            ChatMessage(
              sender: "Assistant",
              role: "model",
              text:
                  "I apologize, but I'm having trouble connecting right now. Please try again in a moment! 🏺",
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add(
          ChatMessage(
            sender: "Assistant",
            role: "model",
            text:
                "I apologize, but I'm having trouble connecting right now. Please try again in a moment! 🏺",
          ),
        );
      });
    }
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 4),
                _buildDot(1),
                SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: primaryGold, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightSand.withOpacity(0.3), papyrusBeige.withOpacity(0.1)],
        ),
      ),
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: darkBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Text('🏺', style: TextStyle(fontSize: 20)),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Egyptian Museum Guide',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Your journey through ancient Egypt',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount:
                  (_messages.length - 1) +
                  (_isLoading ? 1 : 0), // skip the initial prompt
              itemBuilder: (_, index) {
                if (_isLoading && index == _messages.length - 1) {
                  return _buildTypingIndicator();
                }

                final msg = _messages[index + 1]; // offset by 1
                final isUser = msg.role == "user";

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment:
                        isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryGold,
                                primaryGold.withOpacity(0.8),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('🏺', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            gradient:
                                isUser
                                    ? LinearGradient(
                                      colors: [
                                        primaryGold,
                                        primaryGold.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                    : LinearGradient(
                                      colors: [
                                        darkBlue,
                                        darkBlue.withOpacity(0.9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(isUser ? 20 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display image if available
                              if (msg.imageFile != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    msg.imageFile!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                              Text(
                                msg.text,
                                style: TextStyle(fontSize: 16, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: lightSand,
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryGold, width: 2),
                          ),
                          child: Center(
                            child: Text('👤', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.all(16),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty && !_isLoading) {
                            sendMessage(value.trim());
                            _controller.clear();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Ask about ancient Egypt...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryGold, primaryGold.withOpacity(0.8)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryGold.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isLoading ? Icons.hourglass_empty : Icons.send,
                      ),
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                if (_controller.text.trim().isNotEmpty) {
                                  sendMessage(_controller.text.trim());
                                  _controller.clear();
                                }
                              },
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: lightSand,
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryGold.withOpacity(0.5)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _showImageSourceDialog,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
