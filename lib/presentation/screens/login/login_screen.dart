import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:provider/provider.dart';

import 'component/social_login_button.dart';
import 'login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Widget withViewModel() {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const LoginScreen(),
    );
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();

    return Scaffold(
      backgroundColor: AppColor.mainLightRed,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 로고
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/CherryPic_logo.png', width: 80),
                  const SizedBox(height: 20),
                  Image.asset('assets/images/CherryPic_title.png', width: 140),
                ],
              ),
            ),

            // 로그인 버튼
            SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 카카오 로그인 버튼
                  SocialLoginButton(
                    backgroundColor: AppColor.kakaoBg,
                    image: Image.asset(
                      'assets/images/kakao_icon.png',
                      width: 18,
                    ),
                    text: '카카오 로그인',
                    textColor: Colors.black,
                    onTap: viewModel.loginWithKakao,
                  ),

                  const SizedBox(height: 13),

                  // 애플 로그인 버튼
                  SocialLoginButton(
                    backgroundColor: Colors.black,
                    image: Image.asset(
                      'assets/images/apple_icon.png',
                      width: 18,
                    ),
                    text: 'Apple로 로그인',
                    textColor: Colors.white,
                    onTap: viewModel.loginWithApple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
