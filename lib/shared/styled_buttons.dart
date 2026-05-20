import 'package:flutter/material.dart';
import 'colors.dart';

class StyledButtons {
  // Primary Egyptian Button
  static Widget primaryButton({
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
          backgroundColor: AppColors.egyptianRed,
          foregroundColor: AppColors.lightSand,
          elevation: 3,
          shadowColor: Colors.black26,
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
          foregroundColor: AppColors.deepTeal,
          side: const BorderSide(color: AppColors.deepTeal, width: 2),
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
          backgroundColor: AppColors.goldSand,
          foregroundColor: AppColors.deepTeal,
          elevation: 3,
          shadowColor: Colors.black26,
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
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    Color? color,
    double fontSize = 16,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.egyptianRed,
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
    required VoidCallback onPressed,
    required IconData icon,
    String? tooltip,
    bool isExtended = false,
    String? label,
  }) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: AppColors.egyptianRed,
        foregroundColor: AppColors.lightSand,
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
      backgroundColor: AppColors.egyptianRed,
      foregroundColor: AppColors.lightSand,
      elevation: 6,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }

  // Icon Button Egyptian Style
  static Widget iconButton({
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
      color: color ?? AppColors.deepTeal,
      iconSize: size,
      tooltip: tooltip,
      padding: padding,
    );
  }

  // Toggle Button for Dark/Light Mode
  static Widget themeToggleButton({
    required bool isDark,
    required VoidCallback onPressed,
    double size = 40,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: isDark ? AppColors.goldSand : AppColors.deepTeal,
          width: 2,
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          size: size * 0.6,
        ),
        color: isDark ? AppColors.goldSand : AppColors.deepTeal,
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Card Action Button
  static Widget cardActionButton({
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
          foregroundColor: AppColors.egyptianRed,
          side: const BorderSide(color: AppColors.egyptianRed),
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
        backgroundColor: AppColors.egyptianRed,
        foregroundColor: AppColors.lightSand,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  // Chip Button
  static Widget chipButton({
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
      backgroundColor: AppColors.lightSurface,
      selectedColor: AppColors.goldSand,
      checkmarkColor: AppColors.deepTeal,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.deepTeal : AppColors.textSecondaryLight,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.egyptianRed : AppColors.dividerLight,
        ),
      ),
    );
  }
}
