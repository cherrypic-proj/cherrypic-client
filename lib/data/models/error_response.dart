class ErrorResponse {
  final String code;
  final String message;

  ErrorResponse({required this.code, required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json['code'] ?? 'UNKNOWN_CODE',
      message: json['message'] ?? '알 수 없는 오류가 발생했습니다.',
    );
  }
}
