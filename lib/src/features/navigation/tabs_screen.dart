import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../translate/hiero_translate_tab.dart';
import '../history/discover_history_tab.dart';
import '../../shared/theme/colors.dart';

class TabsScreen extends StatefulWidget {
  final int initialTabIndex;
  const TabsScreen({super.key, required this.initialTabIndex});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Tab metadata — icon, label, and a short Egyptian subtitle shown in the AppBar
  static const _tabs = [
    _TabMeta(
      icon: Icons.translate_rounded,
      label: 'Hiero-Translate',
      subtitle: 'Decipher the Sacred Scripts',
    ),
    _TabMeta(
      icon: Icons.auto_stories_rounded,
      label: 'Discover Egypt ',
      subtitle: 'Journey Through the Ages',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final activeTab = _tabController.index;

    // Keep status-bar icons in sync with the AppBar color
    SystemChrome.setSystemUIOverlayStyle(
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return Scaffold(
      // ── AppBar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        // Egyptian cartouche-style title block
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App name — monumental Cinzel caps
            Text(
              'ANCIENT EGYPT',
              style: theme.appBarTheme.titleTextStyle?.copyWith(
                fontSize: 20,
                letterSpacing: 3.5,
              ),
            ),
            const SizedBox(height: 2),
            // Animated subtitle that changes per active tab
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
              child: Text(
                _tabs[activeTab].subtitle,
                key: ValueKey(activeTab),
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.8,
                  color:
                      isDark
                          ? AppColors.ancientAmber.withOpacity(0.75)
                          : AppColors.kohlBlack.withOpacity(0.60),
                ),
              ),
            ),
          ],
        ),

        // Egyptian decorative divider — the Tab Bar itself acts as bottom
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: _EgyptianTabBar(
            controller: _tabController,
            tabs: _tabs,
            isDark: isDark,
            cs: cs,
          ),
        ),

        // Thin gold accent line at the very bottom of the AppBar
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  isDark ? AppColors.ancientAmber : AppColors.pharaohGold,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),

      // ── Tab Body ──────────────────────────────────────────────────────────
      body: TabBarView(
        controller: _tabController,
        children: const [HieroTranslateTab(), DiscoverHistoryTab()],
      ),
    );
  }
}

// ─── Egyptian Tab Bar ─────────────────────────────────────────────────────────

class _EgyptianTabBar extends StatelessWidget {
  final TabController controller;
  final List<_TabMeta> tabs;
  final bool isDark;
  final ColorScheme cs;

  const _EgyptianTabBar({
    required this.controller,
    required this.tabs,
    required this.isDark,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final activeGold = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;
    final inactiveFg =
        isDark
            ? AppColors.ghostGold.withOpacity(0.65)
            : AppColors.papyrusText.withOpacity(0.75);

    return Container(
      height: 56,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.darkScroll.withOpacity(0.70)
                : AppColors.sandstone.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              isDark
                  ? AppColors.ancientAmber.withOpacity(0.18)
                  : AppColors.pharaohGold.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: controller,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(5),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isDark
                    ? [AppColors.ancientAmber, AppColors.pharaohGold]
                    : [AppColors.pharaohGold, AppColors.deepGold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: activeGold.withOpacity(0.35),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: isDark ? AppColors.obsidian : AppColors.kohlBlack,
        unselectedLabelColor: inactiveFg,
        labelStyle: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
        tabs:
            tabs
                .map(
                  (t) => Tab(
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(t.icon, size: 17),
                        const SizedBox(width: 7),
                        Text(t.label),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

// ─── Simple data class ────────────────────────────────────────────────────────

class _TabMeta {
  final IconData icon;
  final String label;
  final String subtitle;
  const _TabMeta({
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}
