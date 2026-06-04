import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/src/features/landmarks/landmarks_data.dart';
import 'package:finalproject/src/features/landmarks/landmark_detail_page.dart';
import 'package:finalproject/src/features/monuments/monument_detection_page.dart';
import 'package:finalproject/src/features/navigation/tabs_screen.dart';
import 'package:finalproject/src/features/home/widgets/home_components.dart';
import 'package:finalproject/src/shared/theme/theme_provider.dart';
import 'package:finalproject/src/shared/theme/colors.dart';
import 'package:finalproject/src/shared/ui/styled_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _showAllMonuments = false;

  late final AnimationController _heroAnimController;
  late final Animation<double> _heroFadeAnim;
  late final Animation<Offset> _heroSlideAnim;

  // Staggered content animations
  late final AnimationController _contentAnimController;
  late final Animation<double> _contentFadeAnim;
  late final Animation<Offset> _contentSlideAnim;

  @override
  void initState() {
    super.initState();

    _heroAnimController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _heroFadeAnim = CurvedAnimation(
      parent: _heroAnimController,
      curve: Curves.easeOut,
    );
    _heroSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _heroAnimController, curve: Curves.easeOutCubic),
    );

    _contentAnimController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _contentFadeAnim = CurvedAnimation(
      parent: _contentAnimController,
      curve: Curves.easeOut,
    );
    _contentSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentAnimController,
        curve: Curves.easeOutCubic,
      ),
    );

    _heroAnimController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _contentAnimController.forward();
    });
  }

  @override
  void dispose() {
    _heroAnimController.dispose();
    _contentAnimController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final monuments = landmarks['landmarks'] as List<Map<String, dynamic>>;
    final isDark = themeProvider.isDark(context);

    // Keep system UI in sync
    SystemChrome.setSystemUIOverlayStyle(
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    final timeline = _buildTimelineData();
    final tips = _buildTipsData();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, themeProvider, isDark),
      floatingActionButton: _buildFab(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero (full-width, no horizontal padding) ──────────────────
            FadeTransition(
              opacity: _heroFadeAnim,
              child: SlideTransition(
                position: _heroSlideAnim,
                child: _buildHeroSection(context, isDark),
              ),
            ),

            // ── Gold rule after hero ───────────────────────────────────────
            _GoldRule(isDark: isDark),

            // ── Staggered content body ────────────────────────────────────
            FadeTransition(
              opacity: _contentFadeAnim,
              child: SlideTransition(
                position: _contentSlideAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      _buildQuickActionBar(context, isDark),
                      const SizedBox(height: 32),
                      _buildStatsStrip(context, monuments.length, isDark),
                      const SizedBox(height: 32),
                      _buildTouristTipsSection(context, tips),
                      const SizedBox(height: 32),
                      _buildFeaturedMonumentsSection(context, monuments),
                      const SizedBox(height: 32),
                      _buildHistoricalTimelineSection(
                        context,
                        timeline,
                        isDark,
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDark,
  ) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      // Logo + wordmark
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cartouche icon badge
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: goldColor.withOpacity(0.40), width: 1),
            ),
            child: Icon(Icons.auto_awesome, size: 17, color: goldColor),
          ),
          const SizedBox(width: 10),
          Text(
            'MyPharago',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ],
      ),
      actions: [
        // Theme toggle pill
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: goldColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: goldColor.withOpacity(0.25), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: StyledButtons.themeToggleButton(
              isDark: isDark,
              context: context,
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HERO SECTION
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeroSection(BuildContext context, bool isDark) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient:
            isDark
                ? const LinearGradient(
                  colors: [
                    AppColors.obsidian,
                    AppColors.darkTomb,
                    AppColors.darkChamber,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.55, 1.0],
                )
                : LinearGradient(
                  colors: [
                    AppColors.pharaohGold.withOpacity(0.22),
                    AppColors.desertSand,
                    AppColors.papyrus,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
      ),
      child: Stack(
        children: [
          // Decorative diamond pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _EgyptPatternPainter(
                color: goldColor.withOpacity(isDark ? 0.06 : 0.08),
              ),
            ),
          ),

          // Gold corner accent — top right
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: _CornerAccentPainter(color: goldColor.withOpacity(0.18)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Official guide chip ──────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: goldColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: goldColor.withOpacity(0.45),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: goldColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'EGYPT  •  OFFICIAL TOURIST GUIDE',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: goldColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ── Main headline ────────────────────────────────────────
                Text(
                  'Discover\nAncient Egypt',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 42,
                    height: 1.05,
                    letterSpacing: 1.0,
                    color:
                        isDark ? AppColors.ancientAmber : AppColors.kohlBlack,
                  ),
                ),

                const SizedBox(height: 16),

                // ── Sub-headline ─────────────────────────────────────────
                Text(
                  '5,000 years of civilization await. Explore pyramids, temples, and hieroglyphs with your personal AI guide.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        isDark
                            ? AppColors.moonstone.withOpacity(0.82)
                            : AppColors.kohlBlack.withOpacity(0.72),
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 30),

                // ── CTA buttons ──────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _HeroButton(
                        label: 'Start Exploring',
                        icon: Icons.explore_rounded,
                        isPrimary: true,
                        isDark: isDark,
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => const TabsScreen(initialTabIndex: 1),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _HeroButton(
                      label: 'Translate',
                      icon: Icons.translate_rounded,
                      isPrimary: false,
                      isDark: isDark,
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const TabsScreen(initialTabIndex: 0),
                            ),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // QUICK ACTION BAR
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildQuickActionBar(BuildContext context, bool isDark) {
    final actions = [
      _QuickAction(
        label: 'Monuments',
        icon: Icons.account_balance_rounded,
        color: isDark ? AppColors.ancientAmber : AppColors.pharaohGold,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TabsScreen(initialTabIndex: 1),
              ),
            ),
      ),
      _QuickAction(
        label: 'AR Scan',
        icon: Icons.document_scanner_rounded,
        color: isDark ? AppColors.lightTurquoise : AppColors.sacredTurquoise,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MonumentDetectionPage()),
            ),
      ),
      _QuickAction(
        label: 'Hieroglyphs',
        icon: Icons.translate_rounded,
        color: isDark ? AppColors.polishedGold : AppColors.deepGold,
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TabsScreen(initialTabIndex: 0),
              ),
            ),
      ),
      _QuickAction(
        label: 'Maps',
        icon: Icons.map_rounded,
        color: isDark ? AppColors.nileBlue : AppColors.lapisLazuli,
        onTap:
            () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Maps coming soon!'))),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Quick Access', isDark: isDark),
        const SizedBox(height: 14),
        Row(
          children:
              actions.asMap().entries.map((entry) {
                final isLast = entry.key == actions.length - 1;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 10),
                    child: _QuickActionTile(action: entry.value),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STATS STRIP
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildStatsStrip(
    BuildContext context,
    int monumentCount,
    bool isDark,
  ) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkChamber : AppColors.papyrus,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldColor.withOpacity(0.28), width: 1),
        boxShadow: [
          BoxShadow(
            color: goldColor.withOpacity(isDark ? 0.12 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatItem(
              value: '$monumentCount',
              label: 'Monuments',
              icon: Icons.account_balance_rounded,
              isDark: isDark,
            ),
            _GoldVerticalDivider(isDark: isDark),
            const _StatItem(
              value: '5,000+',
              label: 'Years History',
              icon: Icons.history_edu_rounded,
              isDark: false, // resolved inside
            ),
            _GoldVerticalDivider(isDark: isDark),
            const _StatItem(
              value: '700+',
              label: 'Hieroglyphs',
              icon: Icons.translate_rounded,
              isDark: false,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TOURIST TIPS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildTouristTipsSection(
    BuildContext context,
    List<Map<String, dynamic>> tips,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Visitor Tips',
          subtitle: 'Essential advice for your trip',
          badge: '${tips.length} tips',
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: tips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final tip = tips[index];
              return HomeTipCard(
                category: tip['category'] as String,
                tip: tip['tip'] as String,
                icon: tip['icon'] as IconData,
              );
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FEATURED MONUMENTS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFeaturedMonumentsSection(
    BuildContext context,
    List<Map<String, dynamic>> monuments,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayedMonuments =
        _showAllMonuments ? monuments : monuments.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Key Sites',
          subtitle: 'Must-see sites in Egypt',
          badge: '${monuments.length} total',
          actionLabel: _showAllMonuments ? 'Show Less' : 'See All',
          isDark: isDark,
          onAction:
              () => setState(() => _showAllMonuments = !_showAllMonuments),
        ),
        const SizedBox(height: 14),
        Column(
          children:
              displayedMonuments
                  .map(
                    (landmark) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HomeMonumentCard(
                        landmark: landmark,
                        onExplore:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        LandmarkDetailPage(landmark: landmark),
                              ),
                            ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HISTORICAL TIMELINE
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHistoricalTimelineSection(
    BuildContext context,
    List<Map<String, String>> timeline,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Egyptian Timeline',
          subtitle: 'Journey through 5,000 years',
          badge: '${timeline.length} periods',
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: timeline.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final period = timeline[index];
            return _TimelineCard(
              period: period['period']!,
              years: period['years']!,
              highlight: period['highlight']!,
              emoji: period['icon']!,
              isLast: index == timeline.length - 1,
              isDark: isDark,
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FAB
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MonumentDetectionPage()),
          ),
      icon: const Icon(Icons.document_scanner_rounded),
      label: const Text('Scan Monument'),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DATA HELPERS
  // ─────────────────────────────────────────────────────────────────────────
  List<Map<String, String>> _buildTimelineData() => [
    {
      'period': 'Pre-Dynastic Period',
      'years': 'Before 3100 BC',
      'highlight':
          'Development of agriculture and early settlements along the Nile',
      'icon': '🌾',
    },
    {
      'period': 'Early Dynastic Period',
      'years': 'c. 3100–2686 BC',
      'highlight': 'Unification of Upper and Lower Egypt by King Narmer',
      'icon': '👑',
    },
    {
      'period': 'Old Kingdom',
      'years': 'c. 2686–2181 BC',
      'highlight': 'Era of pyramid building — the Pyramids of Giza constructed',
      'icon': '🔺',
    },
    {
      'period': 'Middle Kingdom',
      'years': 'c. 2055–1650 BC',
      'highlight': 'Cultural revival; literature and arts flourished',
      'icon': '📜',
    },
    {
      'period': 'New Kingdom',
      'years': 'c. 1550–1077 BC',
      'highlight':
          'Egypt\'s golden age — Tutankhamun, Ramses II, Empire expansion',
      'icon': '🔺',
    },
    {
      'period': 'Ptolemaic Period',
      'years': 'c. 332–30 BC',
      'highlight':
          'Rule of Greek Ptolemies, Cleopatra VII, Library of Alexandria',
      'icon': '🏛️',
    },
    {
      'period': 'Roman Period',
      'years': '30 BC – 395 AD',
      'highlight': 'Egypt becomes a Roman province after Cleopatra\'s death',
      'icon': '🦅',
    },
  ];

  List<Map<String, dynamic>> _buildTipsData() => [
    {
      'tip':
          'Wear light, breathable clothing and sturdy shoes for site visits.',
      'icon': Icons.checkroom_outlined,
      'category': 'Dress Code',
    },
    {
      'tip': 'Carry at least 2 liters of water — desert heat can be intense.',
      'icon': Icons.water_drop_outlined,
      'category': 'Hydration',
    },
    {
      'tip': 'Best visiting hours are 7–10 AM to avoid crowds and heat.',
      'icon': Icons.wb_sunny_outlined,
      'category': 'Timing',
    },
    {
      'tip':
          'Photography fees apply inside tombs. Always check before shooting.',
      'icon': Icons.camera_alt_outlined,
      'category': 'Photography',
    },
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GOLD HORIZONTAL RULE  — decorative separator between hero and content
// ═══════════════════════════════════════════════════════════════════════════════
class _GoldRule extends StatelessWidget {
  final bool isDark;
  const _GoldRule({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            goldColor.withOpacity(0.60),
            goldColor,
            goldColor.withOpacity(0.60),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badge;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.isDark,
    this.subtitle,
    this.badge,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left gold tick-mark accent
        Container(
          width: 3,
          height: 28,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: goldColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: goldColor.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: goldColor.withOpacity(0.30),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: goldColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),

        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel!,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: goldColor,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, size: 16, color: goldColor),
              ],
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  STAT ITEM
// ═══════════════════════════════════════════════════════════════════════════════
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool isDark;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkResolved = Theme.of(context).brightness == Brightness.dark;
    final goldColor =
        isDarkResolved ? AppColors.ancientAmber : AppColors.pharaohGold;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: goldColor),
            const SizedBox(height: 7),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Cinzel',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: goldColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  GOLD VERTICAL DIVIDER
// ═══════════════════════════════════════════════════════════════════════════════
class _GoldVerticalDivider extends StatelessWidget {
  final bool isDark;
  const _GoldVerticalDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;
    return Container(
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            goldColor.withOpacity(0.35),
            goldColor.withOpacity(0.35),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  QUICK ACTION TILE
// ═══════════════════════════════════════════════════════════════════════════════
class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _QuickActionTile extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: action.color.withOpacity(isDark ? 0.13 : 0.09),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: action.color.withOpacity(isDark ? 0.30 : 0.22),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(action.icon, size: 26, color: action.color),
              const SizedBox(height: 7),
              Text(
                action.label,
                style: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: action.color,
                  letterSpacing: 0.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  HERO BUTTONS
// ═══════════════════════════════════════════════════════════════════════════════
class _HeroButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isDark;
  final VoidCallback onPressed;

  const _HeroButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
    }
    // Secondary: outlined, styled for the hero background
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: goldColor),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: goldColor,
        side: BorderSide(color: goldColor.withOpacity(0.55), width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  TIMELINE CARD
// ═══════════════════════════════════════════════════════════════════════════════
class _TimelineCard extends StatelessWidget {
  final String period;
  final String years;
  final String highlight;
  final String emoji;
  final bool isLast;
  final bool isDark;

  const _TimelineCard({
    required this.period,
    required this.years,
    required this.highlight,
    required this.emoji,
    required this.isLast,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppColors.ancientAmber : AppColors.pharaohGold;
    final lineColor = goldColor.withOpacity(0.25);
    final dotColor = goldColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline spine ──────────────────────────────────────────────
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Dot
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor.withOpacity(0.15),
                    border: Border.all(color: dotColor, width: 2),
                  ),
                ),
                // Vertical line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: lineColor,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Content ─────────────────────────────────────────────────────
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkChamber : AppColors.papyrus,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: goldColor.withOpacity(0.18),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: goldColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: goldColor.withOpacity(0.22),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          period,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontFamily: 'Cinzel',
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          years,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: goldColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          highlight,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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

// ═══════════════════════════════════════════════════════════════════════════════
//  CUSTOM PAINTERS
// ═══════════════════════════════════════════════════════════════════════════════

/// Repeating diamond (Egyptian lattice) pattern for hero background texture
class _EgyptPatternPainter extends CustomPainter {
  final Color color;
  const _EgyptPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    const step = 44.0;
    for (double x = -step; x < size.width + step; x += step) {
      for (double y = -step; y < size.height + step; y += step) {
        final path =
            Path()
              ..moveTo(x + step / 2, y)
              ..lineTo(x + step, y + step / 2)
              ..lineTo(x + step / 2, y + step)
              ..lineTo(x, y + step / 2)
              ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_EgyptPatternPainter old) => old.color != color;
}

/// Triangle corner accent for hero top-right
class _CornerAccentPainter extends CustomPainter {
  final Color color;
  const _CornerAccentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width - size.height, 0)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerAccentPainter old) => old.color != color;
}
