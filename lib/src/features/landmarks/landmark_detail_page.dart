import 'package:flutter/material.dart';
import 'package:finalproject/src/utils/maps.dart';

class LandmarkDetailPage extends StatelessWidget {
  final Map<String, dynamic> landmark;

  const LandmarkDetailPage({super.key, required this.landmark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(landmark['name'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                landmark['imageUrl'],
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              landmark['name'],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => openGoogleMaps(context, landmark),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 5),
                    Flexible(child: Text(landmark['location'])),
                    // const SizedBox(width: 3),
                    IconButton(
                      onPressed: () => openGoogleMaps(context, landmark),
                      icon: Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              landmark['description'],
              style: const TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 1.2),
            const Text(
              'Explore More',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Swipe through nearby attractions, view 3D models, or read historical timelines.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
