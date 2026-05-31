import 'package:flutter/material.dart';

IconData getLandmarkIcon(String landmarkName) {
  final name = landmarkName.toLowerCase();

  if (name.contains('pyramid')) {
    return Icons.landscape;
  }
  if (name.contains('temple') ||
      name.contains('karnak') ||
      name.contains('luxor') ||
      name.contains('philae')) {
    return Icons.account_balance;
  }
  if (name.contains('valley') || name.contains('tomb')) {
    return Icons.terrain;
  }
  if (name.contains('sphinx')) {
    return Icons.pets;
  }
  if (name.contains('museum')) {
    return Icons.museum;
  }
  if (name.contains('abu simbel')) {
    return Icons.architecture;
  }

  return Icons.location_city;
}
