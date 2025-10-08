import 'package:cherrypic/data/album_event/dto/request/event_add_images_request_dto.dart';
import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:flutter/material.dart';
import 'event_album.dart';

/// '이벤트에 추가' 시트의 상태를 관리하는 ViewModel
class AddToEventViewModel extends ChangeNotifier {
  final int albumId;
  final int imageId; // 이벤트에 추가할 사진의 ID
  final EventRepository _eventRepository;

  AddToEventViewModel({
    required this.albumId,
    required this.imageId,
    EventRepository? eventRepository,
  }) : _eventRepository = eventRepository ?? EventRepository() {
    loadEvents();
  }

  List<EventAlbum> _events = [];
  List<EventAlbum> get events => _events;

  int? _selectedEventId;
  int? get selectedEventId => _selectedEventId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// 앨범에 속한 이벤트 목록 불러오기
  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _eventRepository.getEvents(
        albumId: albumId,
        size: 100,
      );

      // [수정] API 응답(List<EventDto>)을 UI 모델(List<EventAlbum>)로 변환합니다.
      _events = response.content.map((dto) {
        return EventAlbum(
          eventId: dto.eventId,
          title: dto.title,
          imageUrl: dto.coverUrl, // DTO의 coverUrl을 모델의 imageUrl로 매핑
          photoCount:
              dto.numberOfImages, // DTO의 numberOfImages를 모델의 photoCount로 매핑
        );
      }).toList();
    } catch (e) {
      _error = '이벤트 목록을 불러오는 데 실패했습니다.';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 특정 이벤트 선택
  void selectEvent(int eventId) {
    // 이미 선택된 이벤트를 다시 탭하면 선택 해제
    if (_selectedEventId == eventId) {
      _selectedEventId = null;
    } else {
      _selectedEventId = eventId;
    }
    notifyListeners();
  }

  /// 선택된 이벤트에 현재 사진 추가
  Future<bool> addPhotoToSelectedEvent() async {
    if (_selectedEventId == null) {
      _error = '이벤트를 선택해주세요.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = EventAddImagesRequestDto(imageIds: [imageId]);
      await _eventRepository.addImagesToEvent(_selectedEventId!, request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = '사진을 이벤트에 추가하는 데 실패했습니다.';
      debugPrint(_error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
