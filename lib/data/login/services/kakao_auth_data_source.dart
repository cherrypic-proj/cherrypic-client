import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthDataSource {
  // 카카오 로그인 시도 후 ID 토큰을 반환하는 함수
  Future<String?> login() async {
    // 카카오톡 실행 가능 여부 확인
    if (await isKakaoTalkInstalled()) {
      try {
        // 카카오톡으로 로그인 시도
        final token = await UserApi.instance.loginWithKakaoTalk();
        return token.idToken;
      } catch (error) {
        // 사용자가 카카오톡에서 로그인을 취소한 경우 등 에러 발생 시
        // 카카오 계정으로 로그인 계속 진행
        return await _loginWithAccount();
      }
    } else {
      // 카카오톡이 설치되어 있지 않은 경우
      return await _loginWithAccount();
    }
  }

  // 카카오 계정으로 로그인
  Future<String?> _loginWithAccount() async {
    try {
      final token = await UserApi.instance.loginWithKakaoAccount();
      return token.idToken;
    } catch (error) {
      // 사용자가 로그인 취소 등
      return null;
    }
  }

  // 로그아웃 (필요시 사용)
  Future<void> logout() async {
    await UserApi.instance.logout();
  }
}
