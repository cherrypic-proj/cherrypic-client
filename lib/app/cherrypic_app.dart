import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/core/router/app_router.dart';

class CherrypicApp extends StatelessWidget {
  const CherrypicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
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
