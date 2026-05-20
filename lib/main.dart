import 'package:finalproject/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/app_theme.dart';
import '/shared/theme_providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(), 
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Ancient Egyptian Monuments',
            debugShowCheckedModeBanner: false,

            // Apply your custom themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            home: const HomePage(),
          );
        },
      ),
    );
  }
}
