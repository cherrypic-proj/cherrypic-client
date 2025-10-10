import 'package:cherrypic/core/network/api_path.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/login/dto/request/social_login_request_dto.dart';
import 'package:cherrypic/data/login/dto/response/login_response_dto.dart';
import 'package:dio/dio.dart';

// 서버와 실제 데이터 통신을 담당하는 클래스
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient().dio;

  Future<void> socialLogin(
    String provider,
    SocialLoginRequestDto requestDto,
  ) async {
    try {
      final response = await _dio.post(
        ApiPath.authSocialLogin,
        queryParameters: {'oauthProvider': provider},
        data: requestDto.toJson(),
      );

      // 200번대 응답 코드는 모두 성공으로 간주하고, 별도의 처리를 하지 않음
      // Dio는 2xx가 아닐 경우 자동으로 Exception을 발생시키므로, 이 try 블록은 성공이 보장됨
      return; // 성공 시 그냥 리턴
    } on DioException catch (e) {
      // Dio에서 발생한 모든 에러는 여기서 잡아서 처리
      throw ErrorHandler.handle(e);
    }
  }
}
