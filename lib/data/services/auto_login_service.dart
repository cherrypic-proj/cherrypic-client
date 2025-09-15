import 'package:cookie_jar/cookie_jar.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/api_path.dart';

class AutoLoginService {
  final CookieJar _cookieJar;

  AutoLoginService() : _cookieJar = CookieJar();

  // 앱 시작 시 자동 로그인 체크
  Future<bool> checkAutoLogin() async {
    try {
      // 저장된 쿠키에서 토큰 확인
      final cookies = await _cookieJar.loadForRequest(
        Uri.parse('https://dev-api.cherrypic.today'),
      );

      final hasAccessToken = cookies.any(
        (cookie) => cookie.name == 'accessToken' && cookie.value.isNotEmpty,
      );

      if (!hasAccessToken) {
        return false;
      }

      // 토큰 유효성 검사 (예: 사용자 정보 조회)
      return await _validateToken();
    } catch (e) {
      return false;
    }
  }

  // 토큰 유효성 검사
  Future<bool> _validateToken() async {
    try {
      final response = await DioClient().dio.get('/user/profile');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 로그아웃 시 쿠키 삭제
  Future<void> logout() async {
    await _cookieJar.deleteAll();
  }
}
