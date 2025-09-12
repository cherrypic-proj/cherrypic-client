import 'package:cherrypic/core/router/route_path.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'component/social_login_button.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // initState에서 addListener를 사용하기 위해 ViewModel 변수를 선언합니다.
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<LoginViewModel>();
    // ViewModel의 상태 변화를 감지하여 화면 이동, 스낵바 표시 등을 처리합니다.
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    // 위젯이 사라질 때 리스너를 제거하여 메모리 누수를 방지합니다.
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    // 로그인 성공 시 홈 화면으로 이동
    if (_viewModel.loginSuccess) {
      context.go(RoutePath.home);
    }

    // 에러 메시지가 있을 경우 스낵바 표시
    if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_viewModel.errorMessage!)));
      // 스낵바를 다시 표시하지 않도록 상태 초기화
      _viewModel.resetStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.watch를 사용하여 isLoading 상태가 변경될 때마다 UI를 다시 그리도록 합니다.
    final isLoading = context.watch<LoginViewModel>().isLoading;

    return Scaffold(
      backgroundColor: AppColor.mainLightRed,
      // 로딩 중일 때 화면 전체를 덮는 UI를 쉽게 구현하기 위해 Stack을 사용합니다.
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // 상단 로고
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/CherryPic_logo.png',
                        width: 80,
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/CherryPic_title.png',
                        width: 140,
                      ),
                    ],
                  ),
                ),

                // 로그인 버튼
                SafeArea(
                  minimum: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SocialLoginButton(
                        backgroundColor: AppColor.kakaoBg,
                        image: Image.asset(
                          'assets/images/kakao_icon.png',
                          width: 18,
                        ),
                        text: '카카오 로그인',
                        textColor: Colors.black,
                        onTap: _viewModel.loginWithKakao,
                      ),
                      const SizedBox(height: 13),
                      SocialLoginButton(
                        backgroundColor: Colors.black,
                        image: Image.asset(
                          'assets/images/apple_icon.png',
                          width: 18,
                        ),
                        text: 'Apple로 로그인',
                        textColor: Colors.white,
                        onTap: _viewModel.loginWithApple,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // isLoading이 true일 때만 로딩 인디케이터를 화면 위에 표시합니다.
          if (isLoading)
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
