import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:flutter/material.dart';
import 'event_album.dart';

class EventTabViewModel extends ChangeNotifier {
  final EventRepository _eventRepository;
  final int albumId;

  EventTabViewModel({required this.albumId, EventRepository? eventRepository})
    : _eventRepository = eventRepository ?? EventRepository() {
    loadEvents();
  }

  // 상태 변수들
  List<EventAlbum> _albums = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;

  // Getters
  List<EventAlbum> get albums => _albums;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  /// 이벤트 목록 초기 로드 또는 새로고침
  Future<void> loadEvents({bool refresh = false}) async {
    if (refresh) {
      _albums = [];
      _hasMore = true;
    }
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    if (!refresh) {
      notifyListeners();
    }

    try {
      final response = await _eventRepository.getEvents(
        albumId: albumId,
        size: 20,
        direction: 'DESC',
      );

      final eventAlbums = response.content
          .map((dto) => EventAlbum.fromDto(dto, albumId: albumId))
          .toList();

      _albums = eventAlbums;
      _hasMore = !response.isLast;
    } catch (e) {
      _error = e.toString();
      debugPrint('이벤트 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 추가 이벤트 로드 (무한 스크롤)
  Future<void> loadMoreEvents() async {
    if (_isLoadingMore || !_hasMore || _albums.isEmpty) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final lastEventId = _albums.last.eventId;
      final response = await _eventRepository.getEvents(
        albumId: albumId,
        lastEventId: lastEventId,
        size: 20,
        direction: 'DESC',
      );

      final eventAlbums = response.content
          .map((dto) => EventAlbum.fromDto(dto, albumId: albumId))
          .toList();

      _albums.addAll(eventAlbums);
      _hasMore = !response.isLast;
    } catch (e) {
      _error = e.toString();
      debugPrint('추가 이벤트 로드 실패: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 목록을 새로고침하는 함수
  Future<void> refresh() async {
    await loadEvents(refresh: true);
  }
}
