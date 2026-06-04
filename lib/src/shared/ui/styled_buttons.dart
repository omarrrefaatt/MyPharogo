import 'package:flutter/material.dart';
import '../theme/colors.dart';

class StyledButtons {
  // Primary Egyptian Button
  static Widget primaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    double? width,
    double height = 48,
    double borderRadius = 12,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 3,
          shadowColor: Theme.of(context).shadowColor.withOpacity(0.26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Secondary Egyptian Button
  static Widget secondaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    double? width,
    double height = 48,
    double borderRadius = 12,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.secondary,
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gold Accent Button
  static Widget goldButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    double? width,
    double height = 48,
    double borderRadius = 12,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          elevation: 3,
          shadowColor: Theme.of(context).shadowColor.withOpacity(0.26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Flat Text Button
  static Widget textButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    Color? color,
    double fontSize = 16,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 6)],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              fontFamily: 'Serif',
            ),
          ),
        ],
      ),
    );
  }

  // Floating Action Button Egyptian Style
  static Widget egyptianFab({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    String? tooltip,
    bool isExtended = false,
    String? label,
  }) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 6,
        tooltip: tooltip,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Serif',
          ),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 6,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }

  // Icon Button Egyptian Style
  static Widget iconButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    Color? color,
    double size = 24,
    String? tooltip,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: color ?? Theme.of(context).colorScheme.primary,
      iconSize: size,
      tooltip: tooltip,
      padding: padding,
    );
  }

  // Toggle Button for Dark/Light Mode
  static Widget themeToggleButton({
    required BuildContext context,
    required bool isDark,
    required VoidCallback onPressed,
    double size = 40,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color:
            isDark
                ? Theme.of(context).colorScheme.surfaceVariant
                : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          size: size * 0.6,
        ),
        color: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Card Action Button
  static Widget cardActionButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isOutlined = false,
  }) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.arrow_forward, size: 16),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  // Chip Button
  static Widget chipButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    bool isSelected = false,
    IconData? icon,
  }) {
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onPressed(),
      label: Text(text),
      avatar: icon != null ? Icon(icon, size: 16) : null,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      selectedColor: Theme.of(context).colorScheme.primary,
      checkmarkColor: Theme.of(context).colorScheme.onPrimary,
      labelStyle: TextStyle(
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
