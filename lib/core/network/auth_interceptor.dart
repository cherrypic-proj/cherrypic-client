import 'package:dio/dio.dart';
import 'package:cherrypic/core/network/api_path.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/navigation_service.dart';
import 'package:flutter/material.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestPath = err.requestOptions.path;

    // 재발급 API와 로그인 API는 인터셉터 제외 (무한루프 방지)
    if (requestPath.contains('/auth/reissue') ||
        requestPath.contains('/auth/social-login')) {
      handler.next(err);
      return;
    }

    // 401 에러 (토큰 만료) 시 처리
    if (err.response?.statusCode == 401) {
      // 💥💥 추가된 코드 💥💥
      // refreshToken이 없을 경우, 재발급을 시도하지 않고 바로 요청을 실패시킨다.
      final cookies = await DioClient().cookieJar.loadForRequest(
        err.requestOptions.uri,
      );
      final hasRefreshToken = cookies.any(
        (c) => c.name == 'refreshToken' && c.value.isNotEmpty,
      );

      if (!hasRefreshToken) {
        debugPrint('리프레시 토큰이 없으므로 재발급을 시도하지 않습니다.');
        handler.reject(err);
        return;
      }
      final requestOptions = err.requestOptions;

      if (_isRefreshing) {
        _pendingRequests.add(requestOptions);
        return;
      }

      _isRefreshing = true;

      try {
        final success = await _refreshToken();

        if (success) {
          final response = await _retry(requestOptions);
          handler.resolve(response);
          await _retryPendingRequests();
        } else {
          print('토큰 재발급 실패로 인한 원래 요청 실패 처리');
          handler.reject(err);
        }
      } catch (e) {
        // 재발급 로직 자체에서 예외 발생 시 (네트워크 등)
        print('토큰 재발급 로직 예외: $e');
        handler.reject(err); // 원래 요청 실패 처리
      } finally {
        _isRefreshing = false;
        _pendingRequests.clear();
      }
    } else {
      handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          headers: _dio.options.headers,
        ),
      );

      final cookieJar = DioClient().cookieJar;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final cookies = await cookieJar.loadForRequest(options.uri);
            if (cookies.isNotEmpty) {
              options.headers['cookie'] = cookies
                  .map((cookie) => '${cookie.name}=${cookie.value}')
                  .join('; ');
            }
            handler.next(options);
          },
        ),
      );

      final response = await dio.post(ApiPath.authReissue);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('토큰 재발급 실패: $e');
      return false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    return await _dio.fetch(requestOptions);
  }

  Future<void> _retryPendingRequests() async {
    for (final request in _pendingRequests) {
      try {
        await _retry(request);
      } catch (e) {
        print('대기 중인 요청 재시도 실패: $e');
      }
    }
  }

  Future<void> _handleRefreshFailure() async {
    print('리프레시 토큰 만료 - 로그아웃 처리 시작');

    // 1. 쿠키 삭제
    await DioClient().cookieJar.deleteAll();
    print('쿠키 삭제 완료');

    // 2. 로그인 화면으로 이동
    NavigationService.navigateToLogin();
  }
}
