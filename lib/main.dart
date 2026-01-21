import 'package:flutter/material.dart';
import 'package:daily_app/components/page_controller.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily App',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(brightness: Brightness.dark),
      ),
      home: PagesController(),
    );
  }
}
