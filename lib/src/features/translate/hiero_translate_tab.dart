import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared/theme/colors.dart';
import '../../shared/theme/app_theme.dart';

class HieroTranslateTab extends StatefulWidget {
  const HieroTranslateTab({super.key});

  @override
  State<HieroTranslateTab> createState() => _HieroTranslateTabState();
}

class _HieroTranslateTabState extends State<HieroTranslateTab>
    with SingleTickerProviderStateMixin {
  File? _image;
  String? _translation;
  bool _isLoading = false;

  // Animation controller for the result card entrance
  late final AnimationController _resultAnim;
  late final Animation<double> _resultFade;
  late final Animation<Offset> _resultSlide;

  @override
  void initState() {
    super.initState();
    _resultAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _resultFade = CurvedAnimation(parent: _resultAnim, curve: Curves.easeOut);
    _resultSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _resultAnim, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _resultAnim.dispose();
    super.dispose();
  }

  // ── Image picking ──────────────────────────────────────────────────────────

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _resultAnim.reset();
      setState(() {
        _image = File(pickedFile.path);
        _translation = null;
      });
      await _sendImageToApi(_image!);
    }
  }

  Future<void> _sendImageToApi(File image) async {
    setState(() => _isLoading = true);
    try {
      final uri = Uri.parse('http://10.0.2.2:5000/predict');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        setState(() => _translation = jsonData['class'] as String?);
      } else {
        setState(() => _translation = 'Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _translation = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
      if (_translation != null) _resultAnim.forward();
    }
  }

  // ── Source picker bottom sheet ─────────────────────────────────────────────

  void _showImageSourceSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder:
          (_) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sheet handle is drawn by the theme (showDragHandle: true)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Choose Source',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  _SourceTile(
                    icon: Icons.camera_alt_rounded,
                    label: 'Take Photo',
                    subtitle: 'Use your camera to capture a hieroglyph',
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const SizedBox(height: 10),
                  _SourceTile(
                    icon: Icons.photo_library_rounded,
                    label: 'Choose from Gallery',
                    subtitle: 'Select an existing image from your device',
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Section header ───────────────────────────────────────────────
          _SectionHeader(
            icon: Icons.translate_rounded,
            title: 'Hieroglyph Scanner',
            tagline: 'Unveil the language of the gods',
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // ── Image preview / placeholder ──────────────────────────────────
          _ImagePreviewCard(image: _image, isDark: isDark),

          const SizedBox(height: 24),

          // ── Translate button ─────────────────────────────────────────────
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.document_scanner_rounded, size: 20),
              label: const Text('Translate Hieroglyph'),
              onPressed: _isLoading ? null : _showImageSourceSheet,
            ),
          ),

          const SizedBox(height: 32),

          // ── Loading indicator ────────────────────────────────────────────
          if (_isLoading) _LoadingIndicator(isDark: isDark),

          // ── Result card ──────────────────────────────────────────────────
          if (_translation != null && !_isLoading)
            FadeTransition(
              opacity: _resultFade,
              child: SlideTransition(
                position: _resultSlide,
                child: _TranslationResultCard(
                  translation: _translation!,
                  isDark: isDark,
                  cs: cs,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String tagline;
  final bool isDark;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.tagline,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Gold icon badge
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: goldColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: goldColor.withOpacity(0.30), width: 1),
          ),
          child: Icon(icon, color: goldColor, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                tagline,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(letterSpacing: 0.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  IMAGE PREVIEW CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _ImagePreviewCard extends StatelessWidget {
  final File? image;
  final bool isDark;

  const _ImagePreviewCard({required this.image, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Container(
      height: 240,
      decoration: AppTheme.papyrusCardDecoration(isDark: isDark),
      clipBehavior: Clip.antiAlias,
      child:
          image != null
              ? Stack(
                fit: StackFit.expand,
                children: [
                  // The image itself
                  Image.file(image!, fit: BoxFit.cover),
                  // Subtle gold vignette overlay at the bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.35),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // "Tap to change" hint
                  Positioned(
                    left: 12,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Tap button to change image',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Eye of Ra placeholder icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: goldColor.withOpacity(0.10),
                      border: Border.all(
                        color: goldColor.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: goldColor.withOpacity(0.55),
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hieroglyph selected',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:
                          isDark ? AppColors.ghostGold : AppColors.papyrusText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap the button below to capture\nor choose an image from your gallery',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  LOADING INDICATOR
// ═══════════════════════════════════════════════════════════════════════════════

class _LoadingIndicator extends StatelessWidget {
  final bool isDark;
  const _LoadingIndicator({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: AppTheme.papyrusCardDecoration(isDark: isDark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: goldColor,
              backgroundColor: goldColor.withOpacity(0.15),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Consulting the Oracle…',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(letterSpacing: 0.8),
          ),
          const SizedBox(height: 4),
          Text(
            'Deciphering the sacred script',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TRANSLATION RESULT CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _TranslationResultCard extends StatelessWidget {
  final String translation;
  final bool isDark;
  final ColorScheme cs;

  const _TranslationResultCard({
    required this.translation,
    required this.isDark,
    required this.cs,
  });

  bool get _isError => translation.startsWith('Error');

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;
    final accentColor =
        _isError
            ? (isDark ? AppColors.darkError : AppColors.bloodOfRa)
            : goldColor;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkChamber : AppColors.papyrus,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(isDark ? 0.18 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Result header strip ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.10),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              border: Border(
                bottom: BorderSide(
                  color: accentColor.withOpacity(0.20),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isError
                      ? Icons.warning_amber_rounded
                      : Icons.auto_awesome_rounded,
                  color: accentColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  _isError ? 'Translation Failed' : 'Translation Result',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: accentColor,
                    fontFamily: 'Cinzel',
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ornament ─────────────────────────────────────────────
          if (!_isError)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: _HieroglyphDivider(color: goldColor),
            ),

          // ── Translation text ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Text(
              translation,
              textAlign: TextAlign.center,
              style:
                  _isError
                      ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            isDark ? AppColors.darkError : AppColors.bloodOfRa,
                      )
                      : Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 28,
                        fontFamily: 'Cinzel',
                        color:
                            isDark ? AppColors.moonstone : AppColors.kohlBlack,
                        letterSpacing: 2.0,
                        height: 1.3,
                      ),
            ),
          ),

          // ── Footer label ─────────────────────────────────────────────────
          if (!_isError)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.06),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_edu_rounded,
                    size: 14,
                    color: isDark ? AppColors.ghostGold : AppColors.papyrusText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Identified via AI Oracle · Ancient Egypt Explorer',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(letterSpacing: 0.4),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  HIEROGLYPH DECORATIVE DIVIDER
// ═══════════════════════════════════════════════════════════════════════════════

class _HieroglyphDivider extends StatelessWidget {
  final Color color;
  const _HieroglyphDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, color.withOpacity(0.40)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.brightness_5_rounded,
              color: color.withOpacity(0.55),
              size: 16,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.40), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SOURCE TILE  (inside bottom sheet)
// ═══════════════════════════════════════════════════════════════════════════════

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: goldColor.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: goldColor.withOpacity(0.18), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: goldColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: goldColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: goldColor.withOpacity(0.55),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
