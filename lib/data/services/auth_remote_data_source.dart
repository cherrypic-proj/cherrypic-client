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

  // 소셜 로그인 API 호출
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

      // 공통 응답 규격 처리
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => LoginResponseDto.fromJson(json as Map<String, dynamic>),
      );

      // 성공 시 데이터 반환
      return apiResponse.data!;
    } on DioException catch (e) {
      // Dio 에러(네트워크, 타임아웃 등) 발생 시 ErrorHandler로 예외 통일
      throw ErrorHandler.handle(e);
    }
    // ApiBusinessException(서버 정의 에러)은 ApiResponse에서 자동으로 throw 처리
  }
}
