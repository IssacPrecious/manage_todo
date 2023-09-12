import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_todo/constants.dart';
import 'package:manage_todo/dashboard_screen.dart';
import 'package:manage_todo/login_screen.dart';
import 'package:manage_todo/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = sharedPreferences.getBool(isLoggedIn) ?? false;
    bool _isWelcomeScreenShown = sharedPreferences.getBool(isWelcomeScreenShown) ?? false;
    return MaterialApp(
      title: 'ToDo Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          labelSmall: TextStyle(fontSize: 11, letterSpacing: 0.50, fontWeight: FontWeight.w500, color: Colors.grey),
          labelMedium: TextStyle(fontSize: 12, letterSpacing: 0.50, fontWeight: FontWeight.w500, color: Colors.grey),
          labelLarge: TextStyle(fontSize: 14, letterSpacing: 0.10, fontWeight: FontWeight.w500, color: Colors.grey),
          bodySmall: TextStyle(fontSize: 12, letterSpacing: 0.40, fontWeight: FontWeight.w400, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.25, fontWeight: FontWeight.w400, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, letterSpacing: 0.50, fontWeight: FontWeight.w400, color: Colors.white),
          titleSmall: TextStyle(fontSize: 14, letterSpacing: 0.10, fontWeight: FontWeight.bold, color: Colors.white),
          titleMedium: TextStyle(fontSize: 16, letterSpacing: 0.15, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(fontSize: 22, letterSpacing: 0.00, fontWeight: FontWeight.bold, color: Colors.white),
          headlineSmall: TextStyle(fontSize: 24, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.white),
          headlineMedium:
              TextStyle(fontSize: 28, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.white),
          headlineLarge: TextStyle(fontSize: 32, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.white),
          displaySmall: TextStyle(fontSize: 36, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.white),
          displayMedium: TextStyle(fontSize: 45, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.white),
          displayLarge: TextStyle(fontSize: 57, letterSpacing: 0.00, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
      home: _isWelcomeScreenShown && _isLoggedIn
          ? const DashboardScreen()
          : _isWelcomeScreenShown && !_isLoggedIn
              ? const LoginScreen()
              : const WelcomeScreen(),
    );
  }
}
