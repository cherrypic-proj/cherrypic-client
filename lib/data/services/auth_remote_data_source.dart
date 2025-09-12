import 'package:cherrypic/core/network/api_path.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/dto/request/social_login_request_dto.dart';
import 'package:cherrypic/data/dto/response/login_response_dto.dart';
import 'package:dio/dio.dart';

// 서버와 실제 데이터 통신을 담당하는 클래스
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient().dio;

  Future<LoginResponseDto> socialLogin(
    String provider,
    SocialLoginRequestDto requestDto,
  ) async {
    try {
      final response = await _dio.post(
        ApiPath.authSocialLogin,
        queryParameters: {'oauthProvider': provider},
        data: requestDto.toJson(),
      );

      // [수정] statusCode를 확인하는 로직 추가
      if (response.statusCode == 204) {
        // 성공했지만 본문이 없으므로, 비어있는 성공 객체를 반환하여 앱이 멈추지 않도록 함
        return LoginResponseDto(
          accessToken: 'success',
          refreshToken: 'success',
        );
      } else {
        // 204가 아닌 다른 성공 코드(200 등)의 경우 기존 로직대로 처리
        final apiResponse = ApiResponse.fromJson(
          response.data,
          (json) => LoginResponseDto.fromJson(json as Map<String, dynamic>),
        );
        return apiResponse.data!;
      }
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
