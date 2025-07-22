class ApiResponse<T> {
  final bool success;
  final int status;
  final String timestamp;
  final T data;

  ApiResponse({
    required this.success,
    required this.status,
    required this.timestamp,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'],
      status: json['status'],
      timestamp: json['timestamp'],
      data: fromJsonT(json['data']),
    );
  }
}
