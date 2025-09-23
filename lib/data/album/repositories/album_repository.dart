import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_dto.dart';
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

  // 앨범 생성
  Future<AlbumDto> createAlbum(AlbumCreateRequestDto requestDto) async {
    return await _remoteDataSource.createAlbum(requestDto);
  }
}
