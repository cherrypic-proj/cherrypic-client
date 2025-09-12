import 'package:cherrypic/data/dto/request/social_login_request_dto.dart';
import 'package:cherrypic/data/dto/response/login_response_dto.dart';
import 'package:cherrypic/data/services/apple_auth_data_source.dart'; // <-- Apple DataSource 임포트
import 'package:cherrypic/data/services/auth_remote_data_source.dart';
import 'package:cherrypic/data/services/kakao_auth_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final KakaoAuthDataSource _kakaoDataSource;
  final AppleAuthDataSource _appleDataSource;

  AuthRepository({
    AuthRemoteDataSource? remoteDataSource,
    KakaoAuthDataSource? kakaoDataSource,
    AppleAuthDataSource? appleDataSource,
  }) : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource(),
       _kakaoDataSource = kakaoDataSource ?? KakaoAuthDataSource(),
       _appleDataSource = appleDataSource ?? AppleAuthDataSource();

  Future<String?> _getIdTokenFromKakao() async {
    return await _kakaoDataSource.login();
  }

  // 애플 ID 토큰을 가져오는 내부 함수 추가
  Future<String?> _getIdTokenFromApple() async {
    return await _appleDataSource.login();
  }

  Future<LoginResponseDto> socialLogin(String provider) async {
    String? idToken;

    if (provider == 'KAKAO') {
      idToken = await _getIdTokenFromKakao();
    } else if (provider == 'APPLE') {
      idToken = await _getIdTokenFromApple();
    }

    if (idToken == null) {
      throw Exception('소셜 로그인에 실패했습니다. (토큰 없음)');
    }

    final requestDto = SocialLoginRequestDto(idToken: idToken);
    return await _remoteDataSource.socialLogin(provider, requestDto);
  }
}
