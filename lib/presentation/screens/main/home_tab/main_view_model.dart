import 'package:cherrypic/presentation/screens/main/home_tab/album_repository.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;

  MainViewModel({AlbumRepository? albumRepository})
    : _albumRepository = albumRepository ?? AlbumRepository();

  // 상태 변수들
  List<Map<String, dynamic>> _albums = [];
  bool _isLoading = false;
  String? _error;
  String _searchKeyword = '';

  // Getters
  List<Map<String, dynamic>> get albums => _albums;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchKeyword => _searchKeyword;

  // 앨범 목록 로드
  Future<void> loadAlbums({
    String? type,
    String? status,
    String? keyword,
    bool refresh = false,
  }) async {
    if (refresh) {
      _albums.clear();
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _albumRepository.getAlbums(
        type: type,
        status: status ?? 'ACTIVE', // 기본적으로 활성화된 앨범만 조회
        keyword: keyword ?? _searchKeyword.isNotEmpty ? _searchKeyword : null,
        size: 20,
        direction: 'DESC',
      );

      // DTO를 UI용 데이터로 변환
      final albumData = response.albums
          .map((album) => album.toAlbumData())
          .toList();

      if (refresh) {
        _albums = albumData;
      } else {
        _albums.addAll(albumData);
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('앨범 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 앨범 좋아요 토글
  Future<void> toggleAlbumLike(int albumId) async {
    try {
      await _albumRepository.toggleAlbumLike(albumId);

      // 로컬 상태 업데이트
      final index = _albums.indexWhere((album) => album['id'] == albumId);
      if (index != -1) {
        _albums[index]['isLiked'] = !_albums[index]['isLiked'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('좋아요 토글 실패: $e');
      notifyListeners();
    }
  }

  // 검색어 설정 및 검색
  Future<void> searchAlbums(String keyword) async {
    _searchKeyword = keyword;
    await loadAlbums(keyword: keyword, refresh: true);
  }

  // 검색어 초기화
  void clearSearch() {
    _searchKeyword = '';
    loadAlbums(refresh: true);
  }

  // 새로고침
  Future<void> refresh() async {
    await loadAlbums(refresh: true);
  }
}
