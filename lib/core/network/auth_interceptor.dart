import 'package:dio/dio.dart';
import 'package:cherrypic/core/network/api_path.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 (토큰 만료) 시 처리
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      // 이미 재발급 중이면 대기열에 추가
      if (_isRefreshing) {
        _pendingRequests.add(requestOptions);
        return;
      }

      _isRefreshing = true;

      try {
        // 토큰 재발급 시도
        final success = await _refreshToken();

        if (success) {
          // 재발급 성공 시 원래 요청 재시도
          final response = await _retry(requestOptions);
          handler.resolve(response);

          // 대기 중인 요청들도 재시도
          await _retryPendingRequests();
        } else {
          // 재발급 실패 시 로그아웃 처리
          await _handleRefreshFailure();
          handler.reject(err);
        }
      } catch (e) {
        await _handleRefreshFailure();
        handler.reject(err);
      } finally {
        _isRefreshing = false;
        _pendingRequests.clear();
      }
    } else {
      handler.next(err);
    }
  }

  // 토큰 재발급
  Future<bool> _refreshToken() async {
    try {
      final response = await _dio.post(ApiPath.authReissue);
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  // 실패한 요청 재시도
  Future<Response> _retry(RequestOptions requestOptions) async {
    return await _dio.fetch(requestOptions);
  }

  // 대기 중인 요청들 재시도
  Future<void> _retryPendingRequests() async {
    for (final request in _pendingRequests) {
      try {
        await _retry(request);
      } catch (e) {
        // 개별 요청 실패는 무시하고 계속 진행
      }
    }
  }

  // 재발급 실패 시 로그아웃 처리
  Future<void> _handleRefreshFailure() async {
    // 쿠키 삭제
    // 로그인 화면으로 이동
    // 사용자에게 알림
  }
}
