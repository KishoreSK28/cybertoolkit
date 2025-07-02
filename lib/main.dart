import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const CyberToolkitApp());
}

class CyberToolkitApp extends StatelessWidget {
  const CyberToolkitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cyber Toolkit',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.greenAccent,
        scaffoldBackgroundColor: Colors.black,
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        ...AppRoutes.routes,
      },
    );
  }
}
