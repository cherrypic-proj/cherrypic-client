import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'app/cherrypic_app.dart';

// main 함수를 async로 변경합니다.
void main() async {
  // runApp 전에 비동기 작업을 수행하려면 반드시 이 라인을 추가해야 합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일을 로드하여 환경 변수를 준비합니다.
  await dotenv.load(fileName: ".env");

  // .env 파일에서 불러온 네이티브 앱 키로 카카오 SDK를 초기화합니다.
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);

  // 모든 초기화가 끝난 후 앱을 실행합니다.
  runApp(const CherrypicApp());
}
