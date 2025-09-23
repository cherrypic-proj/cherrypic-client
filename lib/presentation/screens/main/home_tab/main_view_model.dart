import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;

  MainViewModel({AlbumRepository? albumRepository})
    : _albumRepository = albumRepository ?? AlbumRepository();

  // 상태 변수들
  List<Map<String, dynamic>> _albums = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  String _searchKeyword = '';

  // Getters
  List<Map<String, dynamic>> get albums => _albums;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String get searchKeyword => _searchKeyword;

  // 앨범 목록 로드 (초기 로드)
  Future<void> loadAlbums({
    String? type,
    String? status,
    String? keyword,
    bool refresh = false,
  }) async {
    if (refresh) {
      _albums.clear();
      _hasMore = true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _albumRepository.getAlbums(
        type: type,
        status: status ?? 'ACTIVE',
        keyword: keyword ?? (_searchKeyword.isNotEmpty ? _searchKeyword : null),
        size: 20,
        direction: 'DESC',
      );

      final albumData = response.albums
          .map((album) => album.toAlbumData())
          .toList();

      if (refresh) {
        _albums = albumData;
      } else {
        _albums.addAll(albumData);
      }

      // isLast가 true이면 더 이상 불러올 데이터가 없음
      _hasMore = !response.isLast;
    } catch (e) {
      _error = e.toString();
      debugPrint('앨범 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 추가 앨범 로드 (무한 스크롤용)
  Future<void> loadMoreAlbums() async {
    if (_isLoadingMore || !_hasMore || _albums.isEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final lastAlbumId = _albums.last['id']; // 마지막 앨범의 ID

      final response = await _albumRepository.getAlbums(
        status: 'ACTIVE',
        keyword: _searchKeyword.isNotEmpty ? _searchKeyword : null,
        lastAlbumId: lastAlbumId,
        size: 20,
        direction: 'DESC',
      );

      final albumData = response.albums
          .map((album) => album.toAlbumData())
          .toList();

      _albums.addAll(albumData);
      _hasMore = !response.isLast;
    } catch (e) {
      _error = e.toString();
      debugPrint('추가 앨범 로드 실패: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // 앨범 좋아요 토글
  Future<void> toggleAlbumLike(int albumId) async {
    try {
      await _albumRepository.toggleAlbumLike(albumId);

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
