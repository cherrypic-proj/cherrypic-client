import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/models/error_response.dart';

class ApiResponse<T> {
  final bool success;
  final int status;
  final String timestamp;
  final T? data;

  ApiResponse({
    required this.success,
    required this.status,
    required this.timestamp,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final isSuccess = json['success'] as bool;

    if (isSuccess) {
      return ApiResponse(
        success: isSuccess,
        status: json['status'],
        timestamp: json['timestamp'],
        data: fromJsonT(json['data']),
      );
    } else {
      final errorResponse = ErrorResponse.fromJson(json['data']);
      throw ApiBusinessException(errorResponse.code, errorResponse.message);
    }
  }
}
