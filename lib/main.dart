// main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'landing_page.dart';
import 'news_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final seenLanding = prefs.getBool('seen_landing') ?? false;
  
  runApp(MyApp(seenLanding: seenLanding));
}

class MyApp extends StatelessWidget {
  final bool seenLanding;
  
  const MyApp({
    super.key,
    required this.seenLanding,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: seenLanding ? const NewsPage() : const LandingPage(),
    );
  }
}