import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE2E8F0);
    const hintColor = Color(0xFF94A3B8);

    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color),
        );

    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: hintColor, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: border(borderColor),
          enabledBorder: border(borderColor),
          focusedBorder: border(Colors.blue),
          errorBorder: border(Colors.red),
          focusedErrorBorder: border(Colors.red),
        ),
      ),
      initialRoute: '/signup',
      routes: appRoutes,
    );
  }
}