// app.dart
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/locale.dart';
import 'ui/screens/splash_screen.dart';

class OfflineTranslatorApp extends StatelessWidget {
  const OfflineTranslatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '离线翻译',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
