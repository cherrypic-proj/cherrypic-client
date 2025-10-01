import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/dto/request/album_image_upload_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:cherrypic/data/album/dto/response/presigned_url_response_dto.dart';
import 'package:cherrypic/data/album/services/album_remote_data_source.dart';

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
}
