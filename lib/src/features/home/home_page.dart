import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/src/features/landmarks/landmarks_data.dart';
import 'package:finalproject/src/features/landmarks/landmark_detail_page.dart';
import 'package:finalproject/src/features/monuments/monument_detection_page.dart';
import 'package:finalproject/src/features/navigation/tabs_screen.dart';
import 'package:finalproject/src/features/home/widgets/home_components.dart';
import 'package:finalproject/src/shared/theme/theme_provider.dart';
import 'package:finalproject/src/shared/ui/styled_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showAllMonuments = false;
  bool _showAllFeatures = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final monuments = landmarks['landmarks'] as List<Map<String, dynamic>>;

    final features = [
      {
        'title': 'Interactive Maps',
        'description':
            'Explore monument locations with detailed maps and directions',
        'icon': Icons.map,
        'color': Colors.blue,
      },
      {
        'title': 'AR Experience',
        'description': 'View monuments in augmented reality from your device',
        'icon': Icons.view_in_ar,
        'color': Colors.purple,
      },
      {
        'title': 'Audio Guides',
        'description': 'Listen to expert narrations about each monument',
        'icon': Icons.headphones,
        'color': Colors.green,
      },
    ];

    final timeline = [
      {
        'period': 'Pre-Dynastic Period',
        'years': 'Before 3100 BC',
        'highlight': 'Development of agriculture, early settlements',
      },
      {
        'period': 'Early Dynastic Period',
        'years': 'c. 3100–2686 BC',
        'highlight': 'Unification of Upper and Lower Egypt by King Narmer',
      },
      {
        'period': 'Old Kingdom',
        'years': 'c. 2686–2181 BC',
        'highlight': 'Era of pyramid building including the Pyramids of Giza',
      },
      {
        'period': 'First Intermediate Period',
        'years': 'c. 2181–2055 BC',
        'highlight': 'Political chaos and decentralization',
      },
      {
        'period': 'Middle Kingdom',
        'years': 'c. 2055–1650 BC',
        'highlight': 'Cultural revival and literature flourished',
      },
      {
        'period': 'Second Intermediate Period',
        'years': 'c. 1650–1550 BC',
        'highlight': 'Hyksos invasion and rule in the north',
      },
      {
        'period': 'New Kingdom',
        'years': 'c. 1550–1077 BC',
        'highlight': 'Egyptian Empire expansion, Tutankhamun, Ramses II',
      },
      {
        'period': 'Third Intermediate Period',
        'years': 'c. 1077–664 BC',
        'highlight': 'Division and foreign invasions',
      },
      {
        'period': 'Late Period',
        'years': 'c. 664–332 BC',
        'highlight': 'Brief revival and Persian invasions',
      },
      {
        'period': 'Ptolemaic Period',
        'years': 'c. 332–30 BC',
        'highlight':
            'Rule of Greek Ptolemies, Cleopatra VII, Library of Alexandria',
      },
      {
        'period': 'Roman Period',
        'years': '30 BC – 395 AD',
        'highlight': 'Egypt as a Roman province after Cleopatra’s death',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPharogo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: StyledButtons.themeToggleButton(
              isDark: themeProvider.isDark(context),
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            _buildQuickStatsSection(context, monuments.length),
            const SizedBox(height: 24),
            _buildFeaturedMonumentsSection(context, monuments),
            const SizedBox(height: 24),
            _buildAppFeaturesSection(context, features),
            const SizedBox(height: 24),
            _buildHistoricalTimelineSection(context, timeline),
          ],
        ),
      ),
      floatingActionButton: StyledButtons.egyptianFab(
        icon: Icons.add,
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Add new monument!')));
        },
        tooltip: 'Add Monument',
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withAlpha(25),
              colorScheme.secondary.withAlpha(13),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Welcome to Ancient Egypt',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Explore the magnificent monuments and treasures of ancient Egyptian civilization. Discover hieroglyphs, learn about pharaohs, and journey through 5,000 years of history.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: StyledButtons.primaryButton(
                      text: 'Hieroglyphic Translator',
                      icon: Icons.translate,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const TabsScreen(initialTabIndex: 0),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: StyledButtons.secondaryButton(
                      text: 'Discover Ancient Egypt',
                      icon: Icons.history_edu,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const TabsScreen(initialTabIndex: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: StyledButtons.secondaryButton(
                      text: 'Explore Monuments',
                      icon: Icons.history_edu,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MonumentDetectionPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection(BuildContext context, int monumentCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Facts', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: HomeStatCard(
                value: '$monumentCount',
                label: 'Monuments',
                icon: Icons.location_city,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: HomeStatCard(
                value: '5000+',
                label: 'Years of History',
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: HomeStatCard(
                value: '700+',
                label: 'Hieroglyphs',
                icon: Icons.translate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedMonumentsSection(
    BuildContext context,
    List<Map<String, dynamic>> monuments,
  ) {
    final displayedMonuments =
        _showAllMonuments ? monuments : monuments.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Monuments',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${displayedMonuments.length}/${monuments.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children:
              displayedMonuments
                  .map(
                    (landmark) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HomeMonumentCard(
                        landmark: landmark,
                        onExplore: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      LandmarkDetailPage(landmark: landmark),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
        ),
        if (monuments.length > 3) ...[
          const SizedBox(height: 8),
          Center(
            child: StyledButtons.secondaryButton(
              text: _showAllMonuments ? 'Show Less' : 'View All Monuments',
              icon: _showAllMonuments ? Icons.expand_less : Icons.expand_more,
              onPressed: () {
                setState(() {
                  _showAllMonuments = !_showAllMonuments;
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAppFeaturesSection(
    BuildContext context,
    List<Map<String, Object>> features,
  ) {
    final displayedFeatures =
        _showAllFeatures ? features : features.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('App Features', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedFeatures.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final feature = displayedFeatures[index];
            return HomeFeatureCard(
              title: feature['title'] as String,
              description: feature['description'] as String,
              icon: feature['icon'] as IconData,
              color: feature['color'] as Color,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${feature['title']} coming soon!')),
                );
              },
            );
          },
        ),
        if (features.length > 3) ...[
          const SizedBox(height: 16),
          Center(
            child: StyledButtons.secondaryButton(
              text:
                  _showAllFeatures ? 'Show Less Features' : 'View All Features',
              icon: _showAllFeatures ? Icons.expand_less : Icons.expand_more,
              onPressed: () {
                setState(() {
                  _showAllFeatures = !_showAllFeatures;
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHistoricalTimelineSection(
    BuildContext context,
    List<Map<String, String>> timeline,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Egyptian Timeline',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ListView.separated(
          itemCount: timeline.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 0),
          itemBuilder: (context, index) {
            final period = timeline[index];
            return HomeTimelineCard(
              period: period['period']!,
              years: period['years']!,
              highlight: period['highlight']!,
              isLast: index == timeline.length - 1,
            );
          },
        ),
      ],
    );
  }
}
