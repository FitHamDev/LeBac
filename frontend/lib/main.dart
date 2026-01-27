import 'package:flutter/material.dart';
import 'package:frontend/pages/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BossieLeBac',
      home: const StartPage(),
    );
  }
}
