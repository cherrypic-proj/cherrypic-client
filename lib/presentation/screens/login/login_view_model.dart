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
      // ViewModel은 더 이상 토큰을 신경쓰지 않습니다.
      // Repository에게 '카카오 로그인 처리해줘' 라고 요청만 보냅니다.
      await _authRepository.socialLogin(provider.name);

      // ... (성공 처리 로직 동일)
      _loginSuccess = true;

    } on ApiException catch (e) {
      _errorMessage = e.message;
    } on ApiBusinessException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString(); // 상세한 에러 확인을 위해 e.toString() 사용
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loginWithKakao() {
    _login(SocialLoginProvider.KAKAO);
  }

  void loginWithApple() {
    _login(SocialLoginProvider.APPLE);
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
