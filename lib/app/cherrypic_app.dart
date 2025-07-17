import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/screens/login/login_screen.dart';
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
      home: const LoginScreen(),
    );
  }
}
