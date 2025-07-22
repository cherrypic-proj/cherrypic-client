import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException ($statusCode): $message';
}

class ErrorHandler {
  static ApiException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('서버에 연결할 수 없습니다.', statusCode: error.response?.statusCode);
      case DioExceptionType.sendTimeout:
        return ApiException('요청 시간이 초과되었습니다.', statusCode: error.response?.statusCode);
      case DioExceptionType.receiveTimeout:
        return ApiException('서버 응답이 지연되었습니다.', statusCode: error.response?.statusCode);
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode ?? 0;
        final msg = error.response?.data['message'] ?? '알 수 없는 오류입니다.';
        return ApiException(msg, statusCode: status);
      case DioExceptionType.cancel:
        return ApiException('요청이 취소되었습니다.');
      case DioExceptionType.unknown:
      default:
        return ApiException('네트워크 오류가 발생했습니다.');
    }
  }
}
