import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  final Dio dio;

  DioClient._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://your.api.base.url',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}
