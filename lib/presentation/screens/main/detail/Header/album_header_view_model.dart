import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_model.dart';
import 'package:flutter/foundation.dart';

class AlbumHeaderViewModel extends ChangeNotifier {
  final int albumId;
  final AlbumRepository _albumRepository;

  AlbumHeaderData? header;
  bool isLoading = false;
  String? error;

  AlbumHeaderViewModel(this.albumId, {AlbumRepository? albumRepository})
    : _albumRepository = albumRepository ?? AlbumRepository() {
    loadAlbumDetail();
  }

  /// 앨범 상세 정보 로드
  Future<void> loadAlbumDetail() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final dto = await _albumRepository.getAlbumDetail(albumId);
      header = AlbumHeaderData(
        albumId: albumId,
        title: dto.title,
        coverUrl: dto.coverUrl ?? '',
        photoCount: 0,
        progress: dto.capacityUsed / dto.totalCapacity,
        badgeText: _getBadgeText(dto.type),
        hostName: dto.hostName,
        numOfParticipants: dto.numOfParticipants,
        capacityUsed: dto.capacityUsed,
        totalCapacity: dto.totalCapacity,
      );
    } catch (e) {
      error = e.toString();
      debugPrint('앨범 상세 정보 로드 실패: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 앨범 타입에 따른 배지 텍스트 반환
  String _getBadgeText(String type) {
    switch (type) {
      case 'PRO':
        return 'PRO';
      case 'BASIC':
        return 'BASIC';
      default:
        return type;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadAlbumDetail();
  }
}
