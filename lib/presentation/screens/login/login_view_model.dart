import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

// 소셜 로그인 제공자 타입 정의
enum SocialLoginProvider { KAKAO, APPLE }

class LoginViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  // UI가 사용할 상태 값들
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess;

  // 로그인 상태 초기화 (에러 메시지를 한번만 표시하기 위함)
  void resetStatus() {
    _loginSuccess = false;
    _errorMessage = null;
  }

  // 실제 로그인 로직을 처리하는 내부 함수
  Future<void> _login(SocialLoginProvider provider) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // UI에게 '로딩 시작'을 알림

    try {
      // TODO: 실제 소셜 로그인 SDK를 통해 idToken을 받아오는 로직 구현 필요
      // 현재는 더미 토큰으로 진행합니다.
      const idToken = 'DUMMY_ID_TOKEN_FOR_TEST';

      // Repository를 통해 서버에 로그인 요청
      final response = await _authRepository.socialLogin(
        provider.name,
        idToken,
      );

      // TODO: 성공 시 토큰 저장 로직 구현 (예: Secure Storage)
      // print('로그인 성공! AccessToken: ${response.accessToken}');

      _loginSuccess = true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } on ApiBusinessException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = '알 수 없는 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners(); // UI에게 '로딩 끝' 및 최종 결과를 알림
    }
  }

  // View에서 호출할 함수들
  void loginWithKakao() {
    _login(SocialLoginProvider.KAKAO);
  }

  void loginWithApple() {
    _login(SocialLoginProvider.APPLE);
  }
}
