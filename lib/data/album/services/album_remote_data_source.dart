import 'package:cherrypic/core/network/api_path.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/album/dto/request/album_image_upload_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/participant_dto.dart';
import 'package:cherrypic/data/album/dto/response/presigned_url_response_dto.dart';
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

  /// 개별 앨범 조회
  Future<AlbumDetailDto> getAlbumDetail(int albumId) async {
    try {
      final response = await _dio.get(ApiPath.albumDetail(albumId));

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => AlbumDetailDto.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data == null) {
        throw ApiException('앨범 정보를 불러올 수 없습니다.');
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Presigned URL 요청
  Future<PresignedUrlResponseDto> getPresignedUrls(
    int albumId,
    AlbumImageUploadRequestDto requestDto,
  ) async {
    try {
      final response = await _dio.post(
        '${ApiPath.albums}/$albumId/images',
        data: requestDto.toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) =>
            PresignedUrlResponseDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 업로드 완료 알림
  Future<void> notifyUploadComplete(int albumId, List<String> imageKeys) async {
    try {
      await _dio.post(
        '${ApiPath.albums}/$albumId/images/complete',
        data: {'imageKeys': imageKeys},
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 참가자 목록 조회
  Future<ParticipantListResponseDto> getParticipants(
    int albumId, {
    String? lastNickname,
    int? lastParticipantId,
    int size = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'size': size};

      if (lastNickname != null) queryParameters['lastNickname'] = lastNickname;
      if (lastParticipantId != null) {
        queryParameters['lastParticipantId'] = lastParticipantId;
      }

      final response = await _dio.get(
        '/albums/$albumId/participants',
        queryParameters: queryParameters,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) =>
            ParticipantListResponseDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
