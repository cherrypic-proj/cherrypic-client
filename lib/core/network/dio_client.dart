import 'package:cherrypic/core/network/auth_interceptor.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  final Dio dio;
  late final PersistCookieJar cookieJar; // 영구 저장용 CookieJar

  DioClient._internal()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://dev-api.cherrypic.today',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  // 외부에서 호출 가능하도록 public으로 변경
  Future<void> initializeCookieJar() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = "${appDocDir.path}/.cookies/";
    cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));

    // 쿠키 매니저 추가 (영구 저장 인스턴스 사용)
    dio.interceptors.add(CookieManager(cookieJar));

    // 로그 인터셉터 추가
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    // 인증 인터셉터 추가 (토큰 재발급 처리)
    dio.interceptors.add(AuthInterceptor(dio));
  }
}
