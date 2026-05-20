import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMaps(
  BuildContext context,
  Map<String, dynamic> landmark,
) async {
  final double lat = landmark['latitude'] ?? 0.0;
  final double lng = landmark['longitude'] ?? 0.0;
  final String name = landmark['name'] ?? 'Unknown Landmark';

  final List<String> urlsToTry = [
    // Google Maps app
    'comgooglemaps://?q=$lat,$lng',
    // iOS Apple Maps
    'maps://?q=$lat,$lng',
    // Universal Google Maps
    'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
  ];

  bool mapOpened = false;

  for (String url in urlsToTry) {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      print('Successfully opened maps with URL: $url');
      mapOpened = true;
      break;
    } else {
      print('Could not launch $url');
    }
  }

  if (!mapOpened) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unable to open maps for $name'),
        action: SnackBarAction(
          label: 'Copy Coordinates',
          onPressed: () {
            final coords = '$lat, $lng';
            Clipboard.setData(ClipboardData(text: coords));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Coordinates copied: $coords')),
            );
          },
        ),
      ),
    );
  }
}
