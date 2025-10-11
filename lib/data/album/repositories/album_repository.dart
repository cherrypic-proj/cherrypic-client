import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/dto/request/album_image_delete_request_dto.dart';
import 'package:cherrypic/data/album/dto/request/album_image_upload_request_dto.dart';
import 'package:cherrypic/data/album/dto/request/album_update_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_image_list_response_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_payment_info_dto.dart';
import 'package:cherrypic/data/album/dto/response/invitation_link_dto.dart';
import 'package:cherrypic/data/album/dto/response/participant_dto.dart';
import 'package:cherrypic/data/album/dto/response/presigned_url_response_dto.dart';
import 'package:cherrypic/data/album/services/album_remote_data_source.dart';

import '../dto/response/album_subscription_info_dto.dart';

class AlbumRepository {
  final AlbumRemoteDataSource _remoteDataSource;

  AlbumRepository({AlbumRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? AlbumRemoteDataSource();

  Future<AlbumListResponseDto> getAlbums({
    String? type,
    String? status,
    String? keyword,
    int? lastAlbumId,
    int size = 20,
    String direction = 'DESC',
  }) async {
    return await _remoteDataSource.getAlbums(
      type: type,
      status: status,
      keyword: keyword,
      lastAlbumId: lastAlbumId,
      size: size,
      direction: direction,
    );
  }

  Future<void> toggleAlbumLike(int albumId) async {
    return await _remoteDataSource.toggleAlbumLike(albumId);
  }

  /// 앨범 생성
  Future<AlbumDto> createAlbum(AlbumCreateRequestDto requestDto) async {
    return await _remoteDataSource.createAlbum(requestDto);
  }

  /// 개별 앨범 조회
  Future<AlbumDetailDto> getAlbumDetail(int albumId) async {
    try {
      return await _remoteDataSource.getAlbumDetail(albumId);
    } catch (e) {
      rethrow;
    }
  }

  /// Presigned URL 받기
  Future<PresignedUrlResponseDto> getPresignedUrls(
    int albumId,
    AlbumImageUploadRequestDto requestDto,
  ) async {
    return await _remoteDataSource.getPresignedUrls(albumId, requestDto);
  }

  /// 업로드 완료 알림
  Future<void> notifyUploadComplete(int albumId, List<String> imageKeys) async {
    return await _remoteDataSource.notifyUploadComplete(albumId, imageKeys);
  }

  /// 참가자 목록 조회
  Future<ParticipantListResponseDto> getParticipants(
    int albumId, {
    String? lastNickname,
    int? lastParticipantId,
    int size = 20,
  }) async {
    return await _remoteDataSource.getParticipants(
      albumId,
      lastNickname: lastNickname,
      lastParticipantId: lastParticipantId,
      size: size,
    );
  }

  /// 앨범 초대 링크 생성
  Future<InvitationLinkDto> createInvitationLink(int albumId) async {
    return await _remoteDataSource.createInvitationLink(albumId);
  }

  /// 앨범 이미지 목록 조회
  Future<AlbumImageListResponseDto> getAlbumImages(
    int albumId, {
    int? lastImageId,
    int size = 20,
    String parameter = 'UPLOAD',
    String direction = 'DESC',
  }) async {
    return await _remoteDataSource.getAlbumImages(
      albumId,
      lastImageId: lastImageId,
      size: size,
      parameter: parameter,
      direction: direction,
    );
  }

  /// 앨범 이미지 삭제
  Future<void> deleteAlbumImages(
    int albumId,
    AlbumImageDeleteRequestDto requestDto,
  ) async {
    return await _remoteDataSource.deleteAlbumImages(albumId, requestDto);
  }

  /// 앨범 수정
  Future<AlbumDto> updateAlbum(
    int albumId,
    AlbumUpdateRequestDto requestDto,
  ) async {
    return await _remoteDataSource.updateAlbum(albumId, requestDto);
  }

  /// 참가자 강퇴
  Future<void> kickParticipant(int albumId, int participantId) async {
    return await _remoteDataSource.kickParticipant(albumId, participantId);
  }

  /// 앨범 삭제
  Future<void> deleteAlbum(int albumId) async {
    return await _remoteDataSource.deleteAlbum(albumId);
  }

  /// 구독 정보 조회
  Future<AlbumSubscriptionInfoDto> getAlbumSubscriptionInfo(int albumId) async {
    try {
      return await _remoteDataSource.getAlbumSubscriptionInfo(albumId);
    } catch (e) {
      rethrow;
    }
  }

  Future<AlbumPaymentInfoResponseDto> getAlbumPaymentInfo(
      {
        int? albumId,
        int? lastPaymentId,
        int size = 20,
        String direction = 'DESC',
      }) async {
    return await _remoteDataSource.getAlbumPaymentInfo(
      albumId: albumId,
      lastPaymentId: lastPaymentId,
      size: size,
      direction: direction,
    );
  }
}
