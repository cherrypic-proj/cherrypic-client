import 'package:cherrypic/data/dto/request/social_login_request_dto.dart';
import 'package:cherrypic/data/dto/response/login_response_dto.dart';
import 'package:cherrypic/data/services/auth_remote_data_source.dart';
import 'package:cherrypic/data/services/kakao_auth_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final KakaoAuthDataSource _kakaoDataSource; // <-- Kakao DataSource 의존성 추가

  AuthRepository({
    AuthRemoteDataSource? remoteDataSource,
    KakaoAuthDataSource? kakaoDataSource,
  }) : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource(),
       _kakaoDataSource = kakaoDataSource ?? KakaoAuthDataSource();

  // 카카오 ID 토큰을 가져오는 내부 함수
  Future<String?> _getIdTokenFromKakao() async {
    return await _kakaoDataSource.login();
  }

  // 기존 socialLogin 함수를 공급자에 따라 분기 처리
  Future<LoginResponseDto> socialLogin(String provider) async {
    String? idToken;

    if (provider == 'KAKAO') {
      idToken = await _getIdTokenFromKakao();
    } else if (provider == 'APPLE') {
      // TODO: 추후 Apple 로그인 로직 구현
      throw Exception('Apple 로그인은 아직 지원되지 않습니다.');
    }

    if (idToken == null) {
      throw Exception('소셜 로그인에 실패했습니다. (토큰 없음)');
    }

    final requestDto = SocialLoginRequestDto(idToken: idToken);
    return await _remoteDataSource.socialLogin(provider, requestDto);
  }
}
