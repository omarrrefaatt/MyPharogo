import 'package:flutter/material.dart';

/// Central design system for the Egyptian Historical Chatbot.
/// All colors, typography, gradients, and decorations live here.
abstract class ChatTheme {
  static const Color transparent = Color(0x00000000);

  static bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color _primary(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color _primaryContainer(BuildContext context) {
    return Theme.of(context).colorScheme.primaryContainer;
  }

  static Color _surface(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color _surfaceVariant(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }

  static Color _onSurface(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color _onSurfaceVariant(BuildContext context) {
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  static Color _shadowColor(BuildContext context) {
    return Theme.of(context).shadowColor;
  }

  static LinearGradient backgroundGradientFor(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors:
          _isDark(context)
              ? [_surface(context), _surface(context), _surfaceVariant(context)]
              : [
                _surface(context),
                _surface(context),
                _primary(context).withOpacity(0.08),
              ],
    );
  }

  static LinearGradient headerGradientFor(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors:
          _isDark(context)
              ? [_surfaceVariant(context), _primaryContainer(context)]
              : [_surface(context), _primary(context).withOpacity(0.15)],
    );
  }

  static LinearGradient inputBarGradientFor(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors:
          _isDark(context)
              ? [_surfaceVariant(context), _surface(context)]
              : [_surface(context), _surface(context).withOpacity(0.96)],
    );
  }

  static BoxDecoration inputContainerDecorationFor(BuildContext context) {
    return BoxDecoration(
      color: _isDark(context) ? _surfaceVariant(context) : _surface(context),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: _primary(context).withOpacity(0.25), width: 1),
      boxShadow: [
        BoxShadow(
          color: _shadowColor(context).withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration cameraButtonDecorationFor(BuildContext context) {
    return BoxDecoration(
      color: _isDark(context) ? _surfaceVariant(context) : _surface(context),
      shape: BoxShape.circle,
      border: Border.all(color: _primary(context).withOpacity(0.35), width: 1),
    );
  }

  static BoxDecoration sendButtonDecorationFor(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_primaryContainer(context), _primary(context)],
      ),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: _primary(context).withOpacity(0.35),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static BoxDecoration userBubbleDecorationFor(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors:
            _isDark(context)
                ? [_surfaceVariant(context), _primary(context)]
                : [_surface(context), _primary(context).withOpacity(0.20)],
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(4),
      ),
      boxShadow: [
        BoxShadow(
          color: _primary(context).withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration assistantBubbleDecorationFor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      gradient:
          _isDark(context)
              ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _surfaceVariant(context),
                  _primary(context).withOpacity(0.15),
                ],
              )
              : null,
      color: _isDark(context) ? null : colorScheme.surface,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(22),
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
      ),
      border: Border.all(color: _primary(context).withOpacity(0.18), width: 1),
      boxShadow: [
        BoxShadow(
          color: _shadowColor(context).withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static BoxDecoration avatarDecorationFor(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [_primaryContainer(context), _primary(context)],
      ),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: _primary(context).withOpacity(0.4),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static BoxDecoration userAvatarDecorationFor(BuildContext context) {
    return BoxDecoration(
      color: _primaryContainer(context),
      shape: BoxShape.circle,
      border: Border.all(color: _primary(context).withOpacity(0.6), width: 1.5),
    );
  }

  static TextStyle userMessageTextFor(BuildContext context) {
    return TextStyle(
      fontFamily: fontBody,
      fontSize: 15,
      height: 1.5,
      color: _onSurface(context),
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle assistantMessageTextFor(BuildContext context) {
    return TextStyle(
      fontFamily: fontBody,
      fontSize: 15,
      height: 1.6,
      color: _onSurface(context),
    );
  }

  static TextStyle headerTitleFor(BuildContext context) {
    return TextStyle(
      fontFamily: fontDisplay,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
      letterSpacing: 1.2,
    );
  }

  static TextStyle headerSubtitleFor(BuildContext context) {
    return TextStyle(
      fontFamily: fontBody,
      fontSize: 11,
      fontStyle: FontStyle.italic,
      color: _onSurfaceVariant(context),
      letterSpacing: 0.5,
    );
  }

  static TextStyle hintText(BuildContext context) {
    return TextStyle(
      fontFamily: fontBody,
      fontSize: 14,
      fontStyle: FontStyle.italic,
      color: _onSurfaceVariant(context),
    );
  }

  static TextStyle dialogTitleFor(BuildContext context) {
    return TextStyle(
      fontFamily: fontDisplay,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
      letterSpacing: 0.8,
    );
  }

  static TextStyle dialogContentFor(BuildContext context) {
    return TextStyle(
      fontFamily: fontBody,
      fontSize: 14,
      height: 1.5,
      color: _onSurface(context).withOpacity(0.92),
    );
  }

  static TextStyle timestampText(BuildContext context) {
    return TextStyle(
      fontSize: 10,
      color: _onSurfaceVariant(context),
      letterSpacing: 0.3,
    );
  }

  static Widget goldDivider(BuildContext context, {double opacity = 0.25}) =>
      Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              transparent,
              _primary(context).withOpacity(opacity),
              _primary(context).withOpacity(opacity * 1.6),
              _primary(context).withOpacity(opacity),
              transparent,
            ],
          ),
        ),
      );

  // ── Typography ────────────────────────────────────────────────────────────
  static const String fontDisplay = 'Cinzel'; // Add to pubspec.yaml
  static const String fontBody = 'Lora'; // Add to pubspec.yaml
}
