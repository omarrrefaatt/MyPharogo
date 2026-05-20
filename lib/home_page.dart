import 'package:finalproject/helpers/maps.dart';
import 'package:finalproject/monument_detection_page.dart';
import 'package:finalproject/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/shared/theme_providers.dart';
import 'shared/styled_buttons.dart';
import 'landmarks_data.dart';
import 'landmark_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _showAllMonuments = false;
  bool _showAllFeatures = false;
  late AnimationController _monumentsAnimationController;
  late AnimationController _featuresAnimationController;

  @override
  void initState() {
    super.initState();
    _monumentsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _featuresAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _monumentsAnimationController.dispose();
    _featuresAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPharogo'),
        actions: [
          // Theme toggle button
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
            // Welcome Card
            _buildWelcomeCard(context),
            const SizedBox(height: 24),

            // Quick Stats Section
            _buildQuickStatsSection(context),
            const SizedBox(height: 24),

            // Featured Monuments Section
            _buildFeaturedMonumentsSection(context),
            const SizedBox(height: 24),
            _buildHistoricalTimelineSection(context),
            const SizedBox(height: 24),

            // App Features Section
            _buildAppFeaturesSection(context),
            const SizedBox(height: 24),

            // Historical Timeline Section
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
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
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

  Widget _buildQuickStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Facts', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                '${landmarks['landmarks'].length}',
                'Monuments',
                Icons.location_city,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                '5000+',
                'Years of History',
                Icons.schedule,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                '700+',
                'Hieroglyphs',
                Icons.translate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String number,
    String label,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              number,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
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

  Widget _buildFeaturedMonumentsSection(BuildContext context) {
    final monumentsList = landmarks['landmarks'] as List;
    final displayedMonuments =
        _showAllMonuments ? monumentsList : monumentsList.take(3).toList();

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
              '${displayedMonuments.length}/${monumentsList.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Column(
            children:
                displayedMonuments.map<Widget>((landmark) {
                  return Column(
                    children: [
                      _buildEnhancedMonumentCard(context, landmark),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
          ),
        ),

        if (monumentsList.length > 3) ...[
          const SizedBox(height: 8),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: StyledButtons.secondaryButton(
                // key: ValueKey(_showAllMonuments),
                text: _showAllMonuments ? 'Show Less' : 'View All Monuments',
                icon: _showAllMonuments ? Icons.expand_less : Icons.expand_more,
                onPressed: () {
                  setState(() {
                    _showAllMonuments = !_showAllMonuments;
                  });
                  if (_showAllMonuments) {
                    _monumentsAnimationController.forward();
                  } else {
                    _monumentsAnimationController.reverse();
                  }
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEnhancedMonumentCard(
    BuildContext context,
    Map<String, dynamic> landmark,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandmarkDetailPage(landmark: landmark),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Hero(
                tag: 'monument_${landmark['name']}',
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getIconForLandmark(landmark['name']),
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      landmark['name'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getShortDescription(landmark['description']),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StyledButtons.cardActionButton(
                            text: 'Explore',
                            icon: Icons.arrow_forward,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => LandmarkDetailPage(
                                        landmark: landmark,
                                      ),
                                ),
                              );
                            },
                            isOutlined: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StyledButtons.iconButton(
                          icon: Icons.map,
                          onPressed: () => openGoogleMaps(context, landmark),
                          tooltip: 'View on Map',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppFeaturesSection(BuildContext context) {
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: displayedFeatures.length,
          itemBuilder: (context, index) {
            final feature = displayedFeatures[index];
            return _buildFeatureCard(context, feature);
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

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> feature) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${feature['title']} coming soon!')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (feature['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(feature['icon'], size: 28, color: feature['color']),
              ),
              const SizedBox(height: 12),
              Text(
                feature['title'],
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                feature['description'],
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoricalTimelineSection(BuildContext context) {
    final periods = [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Egyptian Timeline',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: periods.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final period = periods[index];
            return _buildTimelineCard(context, period, index, periods.length);
          },
        ),
      ],
    );
  }

  Widget _buildTimelineCard(
    BuildContext context,
    Map<String, String> period,
    int index,
    int total,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.amber[700],
                shape: BoxShape.circle,
              ),
            ),
            if (index != total - 1)
              Container(width: 2, height: 80, color: Colors.amber[700]),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    period['period']!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    period['years']!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '🌟 ${period['highlight']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getShortDescription(String fullDescription) {
    List<String> sentences = fullDescription.split('.');
    if (sentences.isNotEmpty) {
      String firstSentence = sentences[0].trim();
      if (firstSentence.length > 100) {
        return '${firstSentence.substring(0, 100)}...';
      }
      return '$firstSentence.';
    }
    return fullDescription.length > 100
        ? '${fullDescription.substring(0, 100)}...'
        : fullDescription;
  }

  IconData _getIconForLandmark(String landmarkName) {
    if (landmarkName.toLowerCase().contains('pyramid')) {
      return Icons.landscape;
    } else if (landmarkName.toLowerCase().contains('temple') ||
        landmarkName.toLowerCase().contains('karnak') ||
        landmarkName.toLowerCase().contains('luxor') ||
        landmarkName.toLowerCase().contains('philae')) {
      return Icons.account_balance;
    } else if (landmarkName.toLowerCase().contains('valley') ||
        landmarkName.toLowerCase().contains('tomb')) {
      return Icons.terrain;
    } else if (landmarkName.toLowerCase().contains('sphinx')) {
      return Icons.pets;
    } else if (landmarkName.toLowerCase().contains('museum')) {
      return Icons.museum;
    } else if (landmarkName.toLowerCase().contains('abu simbel')) {
      return Icons.architecture;
    } else {
      return Icons.location_city;
    }
  }
}
