import 'package:cherrypic/presentation/screens/test/box_card_test.dart';
import 'package:cherrypic/presentation/screens/test/button_test.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/screens/main/main_screen.dart';
import 'package:cherrypic/core/constants/font.dart';

import '../presentation/screens/main/main_album_screen.dart';
import '../presentation/screens/test/main_album_test.dart';

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
      // home: const MainScreen(),
      // home: const ButtonTestScreen(),
      // home: const BoxCardTest(),
      // home: const MainAlbumTest(),
      home: const MainAlbumScreen(),
    );
  }
}
