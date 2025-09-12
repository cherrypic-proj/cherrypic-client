import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthDataSource {
  // 애플 로그인 시도 후 identityToken(ID 토큰)을 반환하는 함수
  Future<String?> login() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 서버에 전달할 ID 토큰
      return credential.identityToken;
    } catch (e) {
      // 사용자가 로그인을 취소했거나 실패한 경우
      return null;
    }
  }
}
