import 'package:cherrypic/core/network/auth_interceptor.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  final Dio dio;

  DioClient._internal()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://dev-api.cherrypic.today',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    // 쿠키 매니저 추가
    dio.interceptors.add(CookieManager(CookieJar()));

    // 로그 인터셉터 추가
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    // 인증 인터셉터 추가 (토큰 재발급 처리)
    dio.interceptors.add(AuthInterceptor(dio));
  }
}
