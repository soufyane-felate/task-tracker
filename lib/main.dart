import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(TaskTrackerApp());
}

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 51, 192, 240),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 51, 192, 235)),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
