import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

/// AppTheme — Ancient Egypt Tourist Experience
///
/// Design philosophy:
///  • Light theme  → Warm papyrus + pharaoh gold: daytime desert exploration
///  • Dark theme   → Deep obsidian + amber gold: torchlit tomb atmosphere
///
/// Typography uses 'Cinzel' (serif, Roman/Egyptian monumental feel) for
/// headings and 'Lato' for body. Register both in pubspec.yaml under fonts.
///
/// Elevation model follows Material 3 tonal surfaces, but with Egyptian
/// gold tinting instead of the default primary tint.
class AppTheme {
  AppTheme._();

  // ─── Border Radii ─────────────────────────────────────────────────────────
  static const double _radiusCard = 16;
  static const double _radiusInput = 14;
  static const double _radiusButton = 12;
  static const double _radiusChip = 24;

  // ─── Elevation ────────────────────────────────────────────────────────────
  static const double _elevationCard = 4;
  static const double _elevationAppBar = 6;
  static const double _elevationDialog = 12;

  // ════════════════════════════════════════════════════════════════════════════
  //  LIGHT THEME — "Desert Daylight"
  // ════════════════════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    final ColorScheme cs = const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.sandstone,
      onPrimaryContainer: AppColors.kohlBlack,

      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      secondaryContainer: Color(0xFFB2DFDB),
      onSecondaryContainer: AppColors.lapisLazuli,

      tertiary: AppColors.lapisLazuli,
      onTertiary: AppColors.lightOnSecondary,
      tertiaryContainer: AppColors.royalBlue,
      onTertiaryContainer: AppColors.lightOnSecondary,

      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      surfaceVariant: AppColors.sandstone,
      onSurfaceVariant: AppColors.papyrusText,

      background: AppColors.lightBackground,
      onBackground: AppColors.lightOnBackground,

      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      errorContainer: AppColors.paleError,
      onErrorContainer: AppColors.bloodOfRa,

      outline: AppColors.mummyLinen,
      outlineVariant: Color(0xFFCDBF9A),
      shadow: AppColors.kohlBlack,
      scrim: AppColors.kohlBlack,
      inverseSurface: AppColors.darkTomb,
      onInverseSurface: AppColors.moonstone,
      inversePrimary: AppColors.ancientAmber,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: cs,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.kohlBlack,
        elevation: _elevationAppBar,
        scrolledUnderElevation: 4,
        shadowColor: AppColors.pharaohGold.withOpacity(0.4),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.kohlBlack, size: 26),
        actionsIconTheme: const IconThemeData(
          color: AppColors.kohlBlack,
          size: 26,
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.kohlBlack,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Cinzel',
          letterSpacing: 1.5,
        ),
        toolbarTextStyle: const TextStyle(
          color: AppColors.papyrusText,
          fontFamily: 'Lato',
        ),
      ),

      // ── Bottom Navigation Bar ────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.papyrus,
        selectedItemColor: AppColors.pharaohGold,
        unselectedItemColor: AppColors.papyrusText,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(fontFamily: 'Lato', fontSize: 11),
      ),

      // ── Navigation Bar (Material 3) ──────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.papyrus,
        indicatorColor: AppColors.pharaohGold.withOpacity(0.20),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.pharaohGold, size: 26);
          }
          return const IconThemeData(color: AppColors.papyrusText, size: 24);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.pharaohGold,
              letterSpacing: 0.5,
            );
          }
          return const TextStyle(
            fontFamily: 'Lato',
            fontSize: 11,
            color: AppColors.papyrusText,
          );
        }),
        elevation: 6,
      ),

      // ── Cards ────────────────────────────────────────────────────────────
      cardTheme: CardTheme(
        color: AppColors.cardLight,
        elevation: _elevationCard,
        shadowColor: AppColors.pharaohGold.withOpacity(0.18),
        surfaceTintColor: AppColors.pharaohGold.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusCard),
          side: BorderSide(color: AppColors.mummyLinen, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated Button ─────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pharaohGold,
          foregroundColor: AppColors.kohlBlack,
          disabledBackgroundColor: AppColors.mummyLinen,
          disabledForegroundColor: AppColors.papyrusText,
          elevation: 3,
          shadowColor: AppColors.pharaohGold.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusButton),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.pharaohGold,
          side: const BorderSide(color: AppColors.pharaohGold, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusButton),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),

      // ── Text Button ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.pharaohGold,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.pharaohGold,
        foregroundColor: AppColors.kohlBlack,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.sandstone,
        selectedColor: AppColors.pharaohGold.withOpacity(0.25),
        disabledColor: AppColors.mummyLinen,
        labelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 13,
          color: AppColors.kohlBlack,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 13,
          color: AppColors.kohlBlack,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: AppColors.mummyLinen),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusChip),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── Tab Bar ──────────────────────────────────────────────────────────
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.pharaohGold,
        unselectedLabelColor: AppColors.papyrusText,
        indicatorColor: AppColors.pharaohGold,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: AppColors.mummyLinen,
      ),

      // ── List Tile ────────────────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.pharaohGold,
        textColor: AppColors.kohlBlack,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        titleTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.kohlBlack,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 13,
          color: AppColors.papyrusText,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 13,
          color: AppColors.papyrusText,
        ),
      ),

      // ── Dialog ───────────────────────────────────────────────────────────
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.papyrus,
        elevation: _elevationDialog,
        shadowColor: AppColors.kohlBlack.withOpacity(0.38),
        surfaceTintColor: AppColors.pharaohGold.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.mummyLinen, width: 1),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.kohlBlack,
          letterSpacing: 1.0,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 15,
          color: AppColors.papyrusText,
          height: 1.5,
        ),
      ),

      // ── Bottom Sheet ─────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.papyrus,
        surfaceTintColor: AppColors.pharaohGold.withOpacity(0.04),
        elevation: 16,
        shadowColor: AppColors.kohlBlack.withOpacity(0.26),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        dragHandleColor: AppColors.mummyLinen,
        dragHandleSize: const Size(48, 4),
        showDragHandle: true,
        clipBehavior: Clip.antiAlias,
      ),

      // ── Snack Bar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lapisLazuli,
        contentTextStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: AppColors.lightOnSecondary,
        ),
        actionTextColor: AppColors.ancientAmber,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),

      // ── Progress Indicators ──────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.pharaohGold,
        linearTrackColor: AppColors.sandstone,
        circularTrackColor: AppColors.sandstone,
        refreshBackgroundColor: AppColors.papyrus,
      ),

      // ── Slider ───────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.pharaohGold,
        inactiveTrackColor: AppColors.mummyLinen,
        thumbColor: AppColors.pharaohGold,
        overlayColor: AppColors.pharaohGold.withOpacity(0.15),
        valueIndicatorColor: AppColors.lapisLazuli,
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          color: AppColors.lightOnSecondary,
          fontSize: 13,
        ),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
      ),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.pharaohGold
                  : AppColors.mummyLinen,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.pharaohGold.withOpacity(0.40)
                  : AppColors.sandstone,
        ),
      ),

      // ── Checkbox ─────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.pharaohGold
                  : AppColors.papyrus.withOpacity(0),
        ),
        checkColor: MaterialStateProperty.all(AppColors.kohlBlack),
        side: const BorderSide(color: AppColors.mummyLinen, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Radio ─────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.pharaohGold
                  : AppColors.papyrusText,
        ),
      ),

      // ── Text Theme ────────────────────────────────────────────────────────
      textTheme: _buildLightTextTheme(),

      // ── Icon Theme ────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: AppColors.pharaohGold, size: 24),
      primaryIconTheme: const IconThemeData(
        color: AppColors.kohlBlack,
        size: 26,
      ),

      // ── Divider ────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.mummyLinen,
        thickness: 1,
        space: 24,
      ),

      // ── Input Decoration ─────────────────────────────────────────────────
      inputDecorationTheme: _buildLightInputTheme(),

      // ── Search Bar ───────────────────────────────────────────────────────
      searchBarTheme: SearchBarThemeData(
        backgroundColor: MaterialStateProperty.all(AppColors.papyrus),
        elevation: MaterialStateProperty.all(2),
        shadowColor: MaterialStateProperty.all(
          AppColors.pharaohGold.withOpacity(0.15),
        ),
        side: MaterialStateProperty.all(
          const BorderSide(color: AppColors.mummyLinen, width: 1),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        hintStyle: MaterialStateProperty.all(
          const TextStyle(fontFamily: 'Lato', color: AppColors.papyrusText),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontFamily: 'Lato', color: AppColors.kohlBlack),
        ),
      ),

      // ── Popup Menu ───────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.papyrus,
        elevation: 6,
        shadowColor: AppColors.pharaohGold.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.mummyLinen, width: 1),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: AppColors.kohlBlack,
        ),
      ),

      // ── Tooltip ──────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.lapisLazuli,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 12,
          color: AppColors.lightOnSecondary,
        ),
      ),

      // ── Badge ─────────────────────────────────────────────────────────────
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.bloodOfRa,
        textColor: Colors.white,
        smallSize: 8,
        largeSize: 18,
        textStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  DARK THEME — "Torchlit Tomb"
  // ════════════════════════════════════════════════════════════════════════════
  static ThemeData get darkTheme {
    final ColorScheme cs = const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.obsidian,
      primaryContainer: AppColors.darkScroll,
      onPrimaryContainer: AppColors.ancientAmber,

      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.obsidian,
      secondaryContainer: AppColors.lapisLazuli,
      onSecondaryContainer: AppColors.lightTurquoise,

      tertiary: AppColors.sacredTurquoise,
      onTertiary: AppColors.obsidian,
      tertiaryContainer: AppColors.nileBlue,
      onTertiaryContainer: AppColors.lightTurquoise,

      surface: AppColors.darkSurface,
      onSurface: AppColors.moonstone,
      surfaceVariant: AppColors.darkScroll,
      onSurfaceVariant: AppColors.ghostGold,

      background: AppColors.darkBackground,
      onBackground: AppColors.moonstone,

      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      errorContainer: Color(0xFF5C1010),
      onErrorContainer: Color(0xFFFFB3B3),

      outline: AppColors.darkHieroglyph,
      outlineVariant: Color(0xFF4A4330),
      shadow: AppColors.kohlBlack,
      scrim: AppColors.kohlBlack,
      inverseSurface: AppColors.sandstone,
      onInverseSurface: AppColors.kohlBlack,
      inversePrimary: AppColors.pharaohGold,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkTomb,
        foregroundColor: AppColors.moonstone,
        elevation: _elevationAppBar,
        scrolledUnderElevation: 4,
        shadowColor: AppColors.kohlBlack.withOpacity(0.54),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.ancientAmber, size: 26),
        actionsIconTheme: const IconThemeData(
          color: AppColors.ancientAmber,
          size: 26,
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.ancientAmber,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Cinzel',
          letterSpacing: 1.5,
        ),
        toolbarTextStyle: const TextStyle(
          color: AppColors.ghostGold,
          fontFamily: 'Lato',
        ),
      ),

      // ── Bottom Navigation Bar ────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkTomb,
        selectedItemColor: AppColors.ancientAmber,
        unselectedItemColor: AppColors.ghostGold,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(fontFamily: 'Lato', fontSize: 11),
      ),

      // ── Navigation Bar (Material 3) ──────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkTomb,
        indicatorColor: AppColors.ancientAmber.withOpacity(0.20),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.ancientAmber, size: 26);
          }
          return const IconThemeData(color: AppColors.ghostGold, size: 24);
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.ancientAmber,
              letterSpacing: 0.5,
            );
          }
          return const TextStyle(
            fontFamily: 'Lato',
            fontSize: 11,
            color: AppColors.ghostGold,
          );
        }),
        elevation: 6,
      ),

      // ── Cards ────────────────────────────────────────────────────────────
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: _elevationCard,
        shadowColor: AppColors.kohlBlack.withOpacity(0.54),
        surfaceTintColor: AppColors.ancientAmber.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusCard),
          side: BorderSide(color: AppColors.darkHieroglyph, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated Button ─────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ancientAmber,
          foregroundColor: AppColors.obsidian,
          disabledBackgroundColor: AppColors.darkScroll,
          disabledForegroundColor: AppColors.ghostGold,
          elevation: 3,
          shadowColor: AppColors.ancientAmber.withOpacity(0.35),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusButton),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.desertSand,
          side: const BorderSide(color: AppColors.ancientAmber, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radiusButton),
          ),
          textStyle: const TextStyle(
            color: AppColors.desertSand,
            fontFamily: 'Cinzel',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),

      // ── Text Button ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.ancientAmber,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.ancientAmber,
        foregroundColor: AppColors.obsidian,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkScroll,
        selectedColor: AppColors.ancientAmber.withOpacity(0.25),
        disabledColor: AppColors.darkHieroglyph,
        labelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 13,
          color: AppColors.moonstone,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 13,
          color: AppColors.ancientAmber,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: AppColors.darkHieroglyph),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radiusChip),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── Tab Bar ──────────────────────────────────────────────────────────
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.ancientAmber,
        unselectedLabelColor: AppColors.ghostGold,
        indicatorColor: AppColors.ancientAmber,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: AppColors.darkHieroglyph,
      ),

      // ── List Tile ────────────────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.ancientAmber,
        textColor: AppColors.moonstone,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        titleTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.moonstone,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 13,
          color: AppColors.ghostGold,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 13,
          color: AppColors.ghostGold,
        ),
      ),

      // ── Dialog ───────────────────────────────────────────────────────────
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.darkTomb,
        elevation: _elevationDialog,
        shadowColor: Colors.black54,
        surfaceTintColor: AppColors.ancientAmber.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.darkHieroglyph, width: 1),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.ancientAmber,
          letterSpacing: 1.0,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 15,
          color: AppColors.ghostGold,
          height: 1.5,
        ),
      ),

      // ── Bottom Sheet ─────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkTomb,
        surfaceTintColor: AppColors.ancientAmber.withOpacity(0.04),
        elevation: 16,
        shadowColor: Colors.black54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        dragHandleColor: AppColors.darkHieroglyph,
        dragHandleSize: const Size(48, 4),
        showDragHandle: true,
        clipBehavior: Clip.antiAlias,
      ),

      // ── Snack Bar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkScroll,
        contentTextStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: AppColors.moonstone,
        ),
        actionTextColor: AppColors.ancientAmber,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.ancientAmber, width: 0.8),
        ),
        elevation: 6,
      ),

      // ── Progress Indicators ──────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.ancientAmber,
        linearTrackColor: AppColors.darkScroll,
        circularTrackColor: AppColors.darkScroll,
        refreshBackgroundColor: AppColors.darkTomb,
      ),

      // ── Slider ───────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.ancientAmber,
        inactiveTrackColor: AppColors.darkScroll,
        thumbColor: AppColors.ancientAmber,
        overlayColor: AppColors.ancientAmber.withOpacity(0.15),
        valueIndicatorColor: AppColors.ancientAmber,
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: 'Cinzel',
          color: AppColors.obsidian,
          fontSize: 13,
        ),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
      ),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.ancientAmber
                  : AppColors.ghostGold,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.ancientAmber.withOpacity(0.40)
                  : AppColors.darkScroll,
        ),
      ),

      // ── Checkbox ─────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.ancientAmber
                  : AppColors.darkTomb.withOpacity(0),
        ),
        checkColor: MaterialStateProperty.all(AppColors.obsidian),
        side: const BorderSide(color: AppColors.darkHieroglyph, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Radio ─────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.selected)
                  ? AppColors.ancientAmber
                  : AppColors.ghostGold,
        ),
      ),

      // ── Text Theme ────────────────────────────────────────────────────────
      textTheme: _buildDarkTextTheme(),

      // ── Icon Theme ────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: AppColors.ancientAmber, size: 24),
      primaryIconTheme: const IconThemeData(
        color: AppColors.ancientAmber,
        size: 26,
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.darkHieroglyph,
        thickness: 1,
        space: 24,
      ),

      // ── Input Decoration ─────────────────────────────────────────────────
      inputDecorationTheme: _buildDarkInputTheme(),

      // ── Search Bar ───────────────────────────────────────────────────────
      searchBarTheme: SearchBarThemeData(
        backgroundColor: MaterialStateProperty.all(AppColors.darkTomb),
        elevation: MaterialStateProperty.all(2),
        shadowColor: MaterialStateProperty.all(
          AppColors.kohlBlack.withOpacity(0.38),
        ),
        side: MaterialStateProperty.all(
          const BorderSide(color: AppColors.darkHieroglyph, width: 1),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        hintStyle: MaterialStateProperty.all(
          const TextStyle(fontFamily: 'Lato', color: AppColors.ghostGold),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontFamily: 'Lato', color: AppColors.moonstone),
        ),
      ),

      // ── Popup Menu ───────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.darkTomb,
        elevation: 8,
        shadowColor: AppColors.kohlBlack.withOpacity(0.54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.darkHieroglyph, width: 1),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: AppColors.moonstone,
        ),
      ),

      // ── Tooltip ──────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.darkScroll,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.ancientAmber.withOpacity(0.4)),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 12,
          color: AppColors.moonstone,
        ),
      ),

      // ── Badge ─────────────────────────────────────────────────────────────
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.darkError,
        textColor: AppColors.lightOnSecondary,
        smallSize: 8,
        largeSize: 18,
        textStyle: TextStyle(
          fontFamily: 'Lato',
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  TEXT THEMES
  // ════════════════════════════════════════════════════════════════════════════

  /// Light text theme — Cinzel for display/headlines, Lato for body
  static TextTheme _buildLightTextTheme() => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 36,
      fontWeight: FontWeight.w900,
      color: AppColors.kohlBlack,
      letterSpacing: 1.5,
      height: 1.1,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.kohlBlack,
      letterSpacing: 1.2,
      height: 1.15,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.kohlBlack,
      letterSpacing: 1.0,
      height: 1.2,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.kohlBlack,
      letterSpacing: 0.8,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 19,
      fontWeight: FontWeight.w600,
      color: AppColors.kohlBlack,
      letterSpacing: 0.6,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: AppColors.kohlBlack,
      letterSpacing: 0.4,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.kohlBlack,
      letterSpacing: 0.5,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.kohlBlack,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.kohlBlack,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.kohlBlack,
      letterSpacing: 0.1,
      height: 1.6,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.papyrusText,
      letterSpacing: 0.1,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.papyrusText,
      letterSpacing: 0.2,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.kohlBlack,
      letterSpacing: 1.0,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.papyrusText,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.papyrusText,
      letterSpacing: 0.5,
    ),
  );

  /// Dark text theme — same font choice, swapped to moonstone/ghostGold palette
  static TextTheme _buildDarkTextTheme() => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 36,
      fontWeight: FontWeight.w900,
      color: AppColors.ancientAmber,
      letterSpacing: 1.5,
      height: 1.1,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.ancientAmber,
      letterSpacing: 1.2,
      height: 1.15,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.moonstone,
      letterSpacing: 1.0,
      height: 1.2,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.moonstone,
      letterSpacing: 0.8,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 19,
      fontWeight: FontWeight.w600,
      color: AppColors.moonstone,
      letterSpacing: 0.6,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: AppColors.moonstone,
      letterSpacing: 0.4,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.moonstone,
      letterSpacing: 0.5,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.moonstone,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.moonstone,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.moonstone,
      letterSpacing: 0.1,
      height: 1.6,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.ghostGold,
      letterSpacing: 0.1,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.ghostGold,
      letterSpacing: 0.2,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Cinzel',
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.ancientAmber,
      letterSpacing: 1.0,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Lato',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.ghostGold,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Lato',
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.ghostGold,
      letterSpacing: 0.5,
    ),
  );

  // ════════════════════════════════════════════════════════════════════════════
  //  INPUT DECORATION THEMES
  // ════════════════════════════════════════════════════════════════════════════

  static InputDecorationTheme _buildLightInputTheme() => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.papyrus,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.mummyLinen, width: 1.2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.mummyLinen, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.pharaohGold, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.bloodOfRa, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.bloodOfRa, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: BorderSide(color: AppColors.mummyLinen.withOpacity(0.5)),
    ),

    labelStyle: const TextStyle(
      fontFamily: 'Lato',
      color: AppColors.papyrusText,
      fontSize: 14,
    ),
    floatingLabelStyle: const TextStyle(
      fontFamily: 'Cinzel',
      color: AppColors.pharaohGold,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    hintStyle: const TextStyle(
      fontFamily: 'Lato',
      color: AppColors.papyrusText,
      fontSize: 14,
    ),
    errorStyle: const TextStyle(
      fontFamily: 'Lato',
      color: AppColors.bloodOfRa,
      fontSize: 12,
    ),
    prefixIconColor: AppColors.pharaohGold,
    suffixIconColor: AppColors.papyrusText,
  );

  static InputDecorationTheme _buildDarkInputTheme() => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkTomb,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.darkHieroglyph, width: 1.2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.darkHieroglyph, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.ancientAmber, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.darkError, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: const BorderSide(color: AppColors.darkError, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radiusInput),
      borderSide: BorderSide(color: AppColors.darkHieroglyph.withOpacity(0.5)),
    ),

    labelStyle: const TextStyle(
      fontFamily: 'Lato',
      color: AppColors.ghostGold,
      fontSize: 14,
    ),
    floatingLabelStyle: const TextStyle(
      fontFamily: 'Cinzel',
      color: AppColors.ancientAmber,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    hintStyle: const TextStyle(
      fontFamily: 'Lato',
      color: AppColors.ghostGold,
      fontSize: 14,
    ),
    errorStyle: const TextStyle(
      fontFamily: 'Lato',
      color: AppColors.darkError,
      fontSize: 12,
    ),
    prefixIconColor: AppColors.ancientAmber,
    suffixIconColor: AppColors.ghostGold,
  );

  // ════════════════════════════════════════════════════════════════════════════
  //  UTILITY HELPERS
  // ════════════════════════════════════════════════════════════════════════════

  /// Returns a Box decoration suitable for a golden-bordered "papyrus card"
  /// that can be used in custom widgets.
  static BoxDecoration papyrusCardDecoration({bool isDark = false}) =>
      BoxDecoration(
        color: isDark ? AppColors.darkChamber : AppColors.papyrus,
        borderRadius: BorderRadius.circular(_radiusCard),
        border: Border.all(
          color:
              isDark
                  ? AppColors.ancientAmber.withOpacity(0.25)
                  : AppColors.pharaohGold.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.45)
                    : AppColors.pharaohGold.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      );

  /// A gradient decoration for hero sections / full-bleed banners.
  static BoxDecoration heroBannerDecoration({bool isDark = false}) =>
      BoxDecoration(
        gradient: isDark ? AppColors.tombGradient : AppColors.pharaohGradient,
        borderRadius: BorderRadius.circular(20),
      );

  /// Creates a [MaterialColor] from any [Color] — required by legacy
  /// `primarySwatch` usage in some Material 2 widgets.
  static MaterialColor createMaterialColor(Color color) {
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;
    final strengths = [0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
