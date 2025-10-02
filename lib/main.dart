import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/data/login/services/auto_login_service.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'app/cherrypic_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일을 로드하여 환경 변수를 준비합니다.
  await dotenv.load(fileName: ".env");

  // .env 파일에서 불러온 네이티브 앱 키로 카카오 SDK를 초기화합니다.
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);

  // DioClient 초기화 (CookieJar 초기화 포함)
  final dioClient = DioClient();
  await dioClient.initializeCookieJar();

  // 자동 로그인 체크
  final autoLoginService = AutoLoginService();
  final isLoggedIn = await autoLoginService.checkAutoLogin();
  final initialRoute = isLoggedIn ? RoutePath.home : RoutePath.login;

  runApp(CherrypicApp(initialRoute: initialRoute));
}
