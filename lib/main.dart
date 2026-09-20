import 'package:flutter/material.dart';
import 'views/dashboard_page.dart';

void main() {
  runApp(const NationalHeroesApp());
}

class NationalHeroesApp extends StatelessWidget {
  const NationalHeroesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'National Heroes of Indonesia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF4EAE0),
      ),
      home: const DashboardPage(),
    );
  }
}