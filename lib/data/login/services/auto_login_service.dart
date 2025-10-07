import 'package:cherrypic/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class AutoLoginService {
  // DioClient의 공유 CookieJar 사용
  get _cookieJar => DioClient().cookieJar;
  get _dio => DioClient().dio;

  Future<bool> checkAutoLogin() async {
    try {
      // 1. 쿠키 존재 여부 확인
      final cookies = await _cookieJar.loadForRequest(
        Uri.parse('https://dev-api.cherrypic.today'),
      );

      final hasAccessToken = cookies.any(
        (cookie) => cookie.name == 'accessToken' && cookie.value.isNotEmpty,
      );

      if (!hasAccessToken) {
        print('자동 로그인 실패: 쿠키 없음');
        return false;
      }

      print('쿠키 확인 완료 - 토큰 유효성 검증 시작');

      // 2. 실제 API 호출로 토큰 유효성 검증
      try {
        final response = await _dio.get(
          '/albums',
          queryParameters: {'status': 'ACTIVE', 'size': 1, 'direction': 'DESC'},
        );

        if (response.statusCode == 200) {
          print('자동 로그인 성공: 유효한 토큰');
          return true;
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          // 401이면 AuthInterceptor가 재발급 시도했지만 실패
          print('자동 로그인 실패: 토큰 만료 및 재발급 실패');
          await logout();
          return false;
        }

        // 네트워크 에러는 일단 true (오프라인 허용)
        print('자동 로그인 경고: 네트워크 에러');
        return true;
      }

      return false;
    } catch (e) {
      print('자동 로그인 체크 중 예외: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _cookieJar.deleteAll();
  }
}
