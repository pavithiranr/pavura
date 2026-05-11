import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/screens/sign_in_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PavuraApp());
}

class PavuraApp extends StatelessWidget {
  const PavuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const _AuthWrapper(),
        routes: {
          '/signin': (_) => const SignInScreen(),
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}

/// Wrapper widget to handle authentication state
class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // If user is authenticated, show home screen
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        }
        // Otherwise show sign in screen
        return const SignInScreen();
      },
    );
  }
}
