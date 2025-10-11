import 'package:cherrypic/core/network/api_path.dart';
import 'package:cherrypic/core/network/api_response.dart';
import 'package:cherrypic/core/network/dio_client.dart';
import 'package:cherrypic/core/network/error_handler.dart';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/dto/request/album_image_delete_request_dto.dart'; // 추가
import 'package:cherrypic/data/album/dto/request/album_image_upload_request_dto.dart';
import 'package:cherrypic/data/album/dto/request/album_update_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_image_list_response_dto.dart';
import 'package:cherrypic/data/album/dto/response/invitation_link_dto.dart';
import 'package:cherrypic/data/album/dto/response/participant_dto.dart';
import 'package:cherrypic/data/album/dto/response/presigned_url_response_dto.dart';
import 'package:dio/dio.dart';

import '../dto/response/album_subscription_info_dto.dart';

class AlbumRemoteDataSource {
  final Dio _dio = DioClient().dio;

  /// 앨범 목록 조회
  Future<AlbumListResponseDto> getAlbums({
    String? type,
    String? status,
    String? keyword,
    int? lastAlbumId,
    int size = 20,
    String direction = 'DESC',
  }) async {
    try {
      final response = await _dio.get(
        ApiPath.albums,
        queryParameters: {
          if (type != null) 'type': type,
          if (status != null) 'status': status,
          if (keyword != null) 'keyword': keyword,
          if (lastAlbumId != null) 'lastAlbumId': lastAlbumId,
          'size': size,
          'direction': direction,
        },
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

  /// 앨범 좋아요 토글
  Future<void> toggleAlbumLike(int albumId) async {
    try {
      await _dio.post('${ApiPath.albums}/$albumId/like');
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 앨범 생성
  Future<AlbumDto> createAlbum(AlbumCreateRequestDto requestDto) async {
    try {
      final response = await _dio.post(
        ApiPath.albums,
        data: requestDto.toJson(),
      );

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

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 앨범 이미지 목록 조회
  Future<AlbumImageListResponseDto> getAlbumImages(
    int albumId, {
    int? lastImageId,
    int size = 20,
    String parameter = 'UPLOAD',
    String direction = 'DESC',
  }) async {
    try {
      final response = await _dio.get(
        ApiPath.albumImages(albumId),
        queryParameters: {
          if (lastImageId != null) 'lastImageId': lastImageId,
          'size': size,
          'parameter': parameter,
          'direction': direction,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) =>
            AlbumImageListResponseDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Presigned URL 받기
  Future<PresignedUrlResponseDto> getPresignedUrls(
    int albumId,
    AlbumImageUploadRequestDto requestDto,
  ) async {
    try {
      final response = await _dio.post(
        ApiPath.albumImages(albumId),
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
        '${ApiPath.albumDetail(albumId)}/images/upload-complete',
        data: {'imageKeys': imageKeys},
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 앨범 이미지 삭제
  Future<void> deleteAlbumImages(
    int albumId,
    AlbumImageDeleteRequestDto requestDto,
  ) async {
    try {
      await _dio.delete(
        ApiPath.albumImages(albumId),
        data: requestDto.toJson(),
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
      final response = await _dio.get(
        '${ApiPath.albumDetail(albumId)}/participants',
        queryParameters: {
          if (lastNickname != null) 'lastNickname': lastNickname,
          if (lastParticipantId != null) 'lastParticipantId': lastParticipantId,
          'size': size,
        },
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

  /// 앨범 초대 링크 생성
  Future<InvitationLinkDto> createInvitationLink(int albumId) async {
    try {
      final response = await _dio.post(ApiPath.albumInvitationLink(albumId));

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => InvitationLinkDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 앨범 수정
  Future<AlbumDto> updateAlbum(
    int albumId,
    AlbumUpdateRequestDto requestDto,
  ) async {
    try {
      final response = await _dio.patch(
        ApiPath.albumDetail(albumId),
        data: requestDto.toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => AlbumDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 참가자 강퇴
  Future<void> kickParticipant(int albumId, int participantId) async {
    try {
      await _dio.delete(
        '${ApiPath.albumDetail(albumId)}/participants/$participantId',
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 앨범 삭제
  Future<void> deleteAlbum(int albumId) async {
    try {
      await _dio.delete(ApiPath.albumDetail(albumId));
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// 구독 정보 조회
  Future<AlbumSubscriptionInfoDto> getAlbumSubscriptionInfo(int albumId) async {
    try {
      final response = await _dio.get(ApiPath.albumSubscription(albumId));

      final apiResponse = ApiResponse.fromJson(
        response.data,
            (json) => AlbumSubscriptionInfoDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
