import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AppTextStyles {
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.deepTeal,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    height: 1.5,
    color: AppColors.deepTeal,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkTeal,
  );
}
