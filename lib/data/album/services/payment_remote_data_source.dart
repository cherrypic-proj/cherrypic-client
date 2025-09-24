import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/album/dto/request/payment_ready_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/payment_ready_response_dto.dart';
import 'package:cherrypic/data/album/dto/request/payment_verify_request_dto.dart';
import 'package:dio/dio.dart';

class PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient().dio;

  // 결제 준비
  Future<PaymentReadyResponseDto> readyPayment(
    PaymentReadyRequestDto requestDto,
  ) async {
    try {
      final response = await _dio.post(
        '/payments/ready',
        data: requestDto.toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) =>
            PaymentReadyResponseDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // 결제 검증
  Future<PaymentVerifyResponseDto> verifyPayment(String impUid) async {
    try {
      final response = await _dio.post('/payments/verify/$impUid');

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) =>
            PaymentVerifyResponseDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
