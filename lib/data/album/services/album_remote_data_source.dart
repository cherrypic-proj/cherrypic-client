import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/album/dto/response/album_dto.dart';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:dio/dio.dart';

class AlbumRemoteDataSource {
  final Dio _dio;

  AlbumRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient().dio;

  Future<AlbumListResponseDto> getAlbums({
    String? type,
    String? status,
    String? keyword,
    int? lastAlbumId,
    required int size,
    String direction = 'DESC',
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'size': size,
        'direction': direction,
      };

      // 선택적 파라미터들 추가
      if (type != null) queryParameters['type'] = type;
      if (status != null) queryParameters['status'] = status;
      if (keyword != null) queryParameters['keyword'] = keyword;
      if (lastAlbumId != null) queryParameters['lastAlbumId'] = lastAlbumId;

      final response = await _dio.get(
        '/albums',
        queryParameters: queryParameters,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => AlbumListResponseDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // 앨범 좋아요 토글
  Future<void> toggleAlbumLike(int albumId) async {
    try {
      await _dio.post('/albums/$albumId/like');
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // 앨범 생성
  Future<AlbumDto> createAlbum(AlbumCreateRequestDto requestDto) async {
    try {
      final response = await _dio.post('/albums', data: requestDto.toJson());

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => AlbumDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
