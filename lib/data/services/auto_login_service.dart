import 'package:cherrypic/core/network/dio_client.dart';

class AutoLoginService {
  // DioClient의 공유 CookieJar 사용
  get _cookieJar => DioClient().cookieJar;

  Future<bool> checkAutoLogin() async {
    try {
      final cookies = await _cookieJar.loadForRequest(
        Uri.parse('https://dev-api.cherrypic.today'),
      );

      final hasAccessToken = cookies.any(
        (cookie) => cookie.name == 'accessToken' && cookie.value.isNotEmpty,
      );

      return hasAccessToken; // 쿠키만 확인하고 끝
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _cookieJar.deleteAll();
  }
}
