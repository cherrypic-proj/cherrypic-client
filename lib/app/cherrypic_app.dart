import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';

import '../presentation/screens/my_page/my_page_screen.dart';

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
      home: const MyPageScreen(),
    );
  }
}
