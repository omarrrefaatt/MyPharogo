import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MonumentDetectionPage extends StatefulWidget {
  const MonumentDetectionPage({Key? key}) : super(key: key);

  @override
  State<MonumentDetectionPage> createState() => _MonumentDetectionPageState();
}

class _MonumentDetectionPageState extends State<MonumentDetectionPage>
    with TickerProviderStateMixin {
  File? _selectedImage;
  bool _isLoading = false;
  String? _detectedMonument;
  String? _wikipediaSummary;
  String? _wikipediaUrl;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _detectedMonument = null;
          _wikipediaSummary = null;
          _wikipediaUrl = null;
        });
        _slideController.forward();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _detectMonument() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://082a4bafd8fe.ngrok-free.app/predict'),
      );

      // Add image file
      var multipartFile = await http.MultipartFile.fromPath(
        'photo',
        _selectedImage!.path,
      );
      request.files.add(multipartFile);

      // Add required headers for ngrok
      request.headers['ngrok-skip-browser-warning'] = 'true';

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final monumentName =
            data['prediction'] ?? data['monument'] ?? 'Unknown Monument';

        setState(() {
          _detectedMonument = monumentName;
        });

        // Search Wikipedia for the monument
        await _searchWikipedia(monumentName);
      } else {
        _showErrorSnackBar('Failed to detect monument. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Network error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchWikipedia(String monumentName) async {
    try {
      // Search Wikipedia API
      final searchUrl = Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(monumentName)}',
      );

      final response = await http.get(searchUrl);
      print('Wikipedia Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _wikipediaSummary = data['extract'] ?? 'No summary available';
          _wikipediaUrl = data['content_urls']?['desktop']?['page'];
        });
      } else {
        // Fallback: try search API
        await _searchWikipediaFallback(monumentName);
      }
    } catch (e) {
      await _searchWikipediaFallback(monumentName);
    }
  }

  Future<void> _searchWikipediaFallback(String monumentName) async {
    try {
      final searchUrl = Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro=true&explaintext=true&titles=${Uri.encodeComponent(monumentName)}',
      );

      final response = await http.get(searchUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'];
        final page = pages[pages.keys.first];

        setState(() {
          _wikipediaSummary =
              page['extract'] ?? 'No information found about this monument.';
          _wikipediaUrl =
              'https://en.wikipedia.org/wiki/${Uri.encodeComponent(monumentName)}';
        });
      }
    } catch (e) {
      setState(() {
        _wikipediaSummary = 'Unable to fetch information about this monument.';
      });
    }
  }

  Future<void> _launchWikipedia() async {
    if (_wikipediaUrl != null) {
      final uri = Uri.parse(_wikipediaUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open Wikipedia page');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Choose Image Source',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monument Explorer'), elevation: 0),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance_rounded,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Discover History',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unlock the secrets of monuments with just a snap! 📸\n\nEvery monument tells a story spanning centuries. From ancient temples carved by forgotten civilizations to modern memorials honoring heroes, each structure holds mysteries waiting to be unveiled.\n\nCapture any monument, and let AI reveal its name, history, and significance instantly.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Image Selection
              if (_selectedImage == null)
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          size: 48,
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap to Add Monument Photo',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Camera or Gallery',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

              // Selected Image Display
              if (_selectedImage != null)
                SlideTransition(
                  position: _slideAnimation,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.file(
                            _selectedImage!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      _isLoading ? null : _detectMonument,
                                  icon:
                                      _isLoading
                                          ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : const Icon(Icons.search_rounded),
                                  label: Text(
                                    _isLoading
                                        ? 'Analyzing...'
                                        : 'Identify Monument',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                onPressed: _showImageSourceDialog,
                                icon: const Icon(Icons.refresh_rounded),
                                tooltip: 'Change Image',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Results Section
              if (_detectedMonument != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Monument Identified',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _detectedMonument!,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        if (_wikipediaSummary != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Historical Overview',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _wikipediaSummary!,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.justify,
                          ),

                          if (_wikipediaUrl != null) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _launchWikipedia,
                                icon: const Icon(Icons.open_in_new_rounded),
                                label: const Text('Read More on Wikipedia'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],

                        if (_wikipediaSummary == null && !_isLoading) ...[
                          const SizedBox(height: 12),
                          const Center(child: CircularProgressIndicator()),
                          const SizedBox(height: 8),
                          Text(
                            'Fetching historical information...',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
