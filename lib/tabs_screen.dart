import 'package:flutter/material.dart';
import 'hiero_translate_tab.dart';
import 'discover_history_tab.dart';

class TabsScreen extends StatelessWidget {
  final int initialTabIndex;
  const TabsScreen({super.key, required this.initialTabIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,  // <-- Use initialTabIndex here
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ancient Egypt Explorer'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Hiero-translate'),
              Tab(text: 'Discover history'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HieroTranslateTab(),
            DiscoverHistoryTab(),
          ],
        ),
      ),
    );
  }
}
