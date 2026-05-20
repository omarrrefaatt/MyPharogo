import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HieroTranslateTab extends StatefulWidget {
  const HieroTranslateTab({super.key});

  @override
  State createState() => _HieroTranslateTabState();
}

class _HieroTranslateTabState extends State<HieroTranslateTab> {
  File? _image;
  String? _translation;
  bool _isLoading = false;

  Future _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _translation = null;
      });

      await _sendImageToApi(_image!);
    }
  }

  Future _sendImageToApi(File image) async {
    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse("https://0af2b6f2c0a6.ngrok-free.app/predict");
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response: $responseBody');

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        setState(() {
          _translation = jsonData['class'];
        });
      } else {
        setState(() {
          _translation = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _translation = "Error: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take Photo"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Choose from Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _image!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Translate Hieroglyph"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              onPressed: _showImageSourceDialog,
            ),
            const SizedBox(height: 30),
            if (_isLoading) CircularProgressIndicator(),
            if (_translation != null && !_isLoading)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(
                  "Translation:\n$_translation",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
