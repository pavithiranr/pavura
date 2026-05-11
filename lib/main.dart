import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/screens/sign_in_screen.dart';
import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const PavuraApp());
}

class PavuraApp extends StatelessWidget {
  const PavuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SignInScreen(),
      routes: {
        '/signin': (_) => const SignInScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
