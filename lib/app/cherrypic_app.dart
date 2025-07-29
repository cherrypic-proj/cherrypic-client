import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/screens/main/main_screen.dart';
import 'package:cherrypic/presentation/screens/test/album_card_test_screen.dart';
import 'package:cherrypic/presentation/screens/test/event_card_test_screen.dart';
import 'package:cherrypic/core/constants/font.dart';

class CherrypicApp extends StatelessWidget {
  const CherrypicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cherrypic',
      theme: ThemeData(
        fontFamily: AppFont.family,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const EventCardTestScreen(),
    );
  }
}
