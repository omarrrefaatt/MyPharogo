import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../decorations/chat_constants.dart';
import '../chat/chat_theme.dart';

/// Collection of themed dialogs used across the chat feature.
abstract class ChatDialogs {
  // ── Permission ─────────────────────────────────────────────────────────────

  static Future<void> showPermission(
    BuildContext context, {
    required String permissionLabel,
  }) {
    final message =
        permissionLabel == 'Camera'
            ? ChatConstants.errorPermissionCamera
            : ChatConstants.errorPermissionGallery;

    return showDialog(
      context: context,
      builder:
          (_) => _EgyptianDialog(
            title: ChatConstants.dialogPermissionTitle,
            icon: Icons.lock_outline_rounded,
            content: message,
            actions: [
              _DialogAction(
                label: ChatConstants.dialogCancel,
                onTap: () => Navigator.pop(context),
              ),
              _DialogAction(
                label: ChatConstants.dialogSettings,
                isPrimary: true,
                onTap: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
              ),
            ],
          ),
    );
  }

  // ── Error ──────────────────────────────────────────────────────────────────

  static Future<void> showError(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder:
          (_) => _EgyptianDialog(
            title: ChatConstants.dialogErrorTitle,
            icon: Icons.warning_amber_rounded,
            iconColor: Theme.of(context).colorScheme.error,
            content: message,
            actions: [
              _DialogAction(
                label: ChatConstants.dialogOk,
                isPrimary: true,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private reusable dialog shell
// ─────────────────────────────────────────────────────────────────────────────

class _EgyptianDialog extends StatelessWidget {
  const _EgyptianDialog({
    required this.title,
    required this.content,
    required this.actions,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String content;
  final List<Widget> actions;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.25),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: iconColor ?? Theme.of(context).colorScheme.primary,
                size: 36,
              ),
              const SizedBox(height: 12),
            ],
            Text(
              title,
              style: ChatTheme.dialogTitleFor(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.primary.withOpacity(0.18),
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.primary.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: ChatTheme.dialogContentFor(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
                  actions
                      .map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: a,
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogAction extends StatelessWidget {
  const _DialogAction({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: ChatTheme.fontDisplay,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSecondary,
              letterSpacing: 0.6,
            ),
          ),
        ),
      );
    }
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: ChatTheme.fontBody,
          fontSize: 13,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        ),
      ),
    );
  }
}
