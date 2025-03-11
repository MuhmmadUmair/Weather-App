import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        appBarTheme: AppBarTheme(),
        cardTheme: CardTheme(
          elevation: 6,
          // ignore: deprecated_member_use
          shadowColor: Colors.black.withOpacity(0.5),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const WeatherScreen(),
    );
  }
}
