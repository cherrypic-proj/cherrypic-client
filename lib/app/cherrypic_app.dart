import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/router/app_router.dart';

class CherrypicApp extends StatelessWidget {
  final String initialRoute;

  const CherrypicApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: createAppRouter(initialRoute), // GoRouter를 동적으로 생성
      title: 'Cherrypic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppFont.family,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      ),
    );
  }
}
