import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/widgets/custom_app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Text(
            '메인 화면',
            style: AppFont.size20,
          ),
        ),
      ),
    );
  }
}
