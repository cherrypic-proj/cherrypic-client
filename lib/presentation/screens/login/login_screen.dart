import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainLightRed,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/CherryPic_logo.png',
              width: 80,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/CherryPic_title.png',
              width: 140,
            ),
            const SizedBox(height: 160),
            Text(
              '로그인 / 회원가입',
              style: AppFont.size14.copyWith(
                color: AppColor.mainRed,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/kakao_icon.png', width: 70),
                const SizedBox(width: 10),
                Image.asset('assets/images/apple_icon.png', width: 70),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
