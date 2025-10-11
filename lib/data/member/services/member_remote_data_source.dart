import 'package:cherrypic/core/network/api_path.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/member/dto/response/member_info_dto.dart';
import 'package:dio/dio.dart';

class MemberRemoteDataSource {
  final Dio _dio = DioClient().dio;

  /// 회원 정보 조회
  Future<MemberInfoDto> getMemberInfo() async {
    try {
      final response = await _dio.get(ApiPath.memberInfo());

      final apiResponse = ApiResponse.fromJson(
        response.data,
          (json) => MemberInfoDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e){
      throw ErrorHandler.handle(e);
    }
  }
}
