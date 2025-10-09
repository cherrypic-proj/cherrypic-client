import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album_event/dto/request/event_add_images_request_dto.dart';
import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:flutter/material.dart';

// --- 데이터 모델 정의 (CreateEventViewModel과 동일) ---
class AlbumImage {
  final int imageId;
  final String imageUrl;
  AlbumImage({required this.imageId, required this.imageUrl});
}

class AlbumDayGroup {
  final String date;
  final List<AlbumImage> images;
  final Set<int> selectedIndexes;
  bool isAllSelected;

  AlbumDayGroup({
    required this.date,
    required this.images,
    Set<int>? selectedIndexes,
    this.isAllSelected = false,
  }) : selectedIndexes = selectedIndexes ?? <int>{};
}

// --- ViewModel ---

class AddImagesViewModel extends ChangeNotifier {
  final int albumId;
  final int eventId; // 이미지를 추가할 대상 이벤트 ID
  final AlbumRepository _albumRepository;
  final EventRepository _eventRepository;

  AddImagesViewModel({
    required this.albumId,
    required this.eventId,
    AlbumRepository? albumRepository,
    EventRepository? eventRepository,
  }) : _albumRepository = albumRepository ?? AlbumRepository(),
       _eventRepository = eventRepository ?? EventRepository() {
    loadImages();
  }

  // --- 상태 변수 ---
  List<AlbumDayGroup> groups = [];
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;

  String _sortParameter = 'UPLOAD';
  String _sortDirection = 'DESC';

  // --- Getters ---
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;
  String get sortParameter => _sortParameter;
  String get sortDirection => _sortDirection;

  int get selectedPhotosCount =>
      groups.fold(0, (sum, group) => sum + group.selectedIndexes.length);

  bool get isAnythingSelected => selectedPhotosCount > 0;

  // --- 로직 (CreateEventViewModel과 대부분 동일) ---

  Future<void> toggleSort(String newParameter) async {
    if (_sortParameter == newParameter) {
      _sortDirection = _sortDirection == 'DESC' ? 'ASC' : 'DESC';
    } else {
      _sortParameter = newParameter;
      _sortDirection = 'DESC';
    }
    notifyListeners();
    await loadImages();
  }

  Future<void> loadImages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _albumRepository.getAlbumImages(
        albumId,
        size: 200,
        parameter: _sortParameter,
        direction: _sortDirection,
      );
      groups = _groupImagesByDate(response.content);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<AlbumDayGroup> _groupImagesByDate(List<dynamic> imageDtos) {
    final Map<String, List<AlbumImage>> dateMap = {};
    for (final dto in imageDtos) {
      final date = (dto.date as String).replaceAll('-', '.');
      if (!dateMap.containsKey(date)) {
        dateMap[date] = [];
      }
      dateMap[date]!.add(
        AlbumImage(imageId: dto.imageId, imageUrl: dto.imageUrl),
      );
    }
    return dateMap.entries
        .map((entry) => AlbumDayGroup(date: entry.key, images: entry.value))
        .toList();
  }

  void togglePhotoSelection(int groupIndex, int imageIndex) {
    final group = groups[groupIndex];
    if (group.selectedIndexes.contains(imageIndex)) {
      group.selectedIndexes.remove(imageIndex);
    } else {
      group.selectedIndexes.add(imageIndex);
    }
    group.isAllSelected = group.selectedIndexes.length == group.images.length;
    notifyListeners();
  }

  void toggleAll(int groupIndex) {
    final group = groups[groupIndex];
    group.isAllSelected = !group.isAllSelected;
    group.selectedIndexes.clear();
    if (group.isAllSelected) {
      group.selectedIndexes.addAll(
        List.generate(group.images.length, (i) => i),
      );
    }
    notifyListeners();
  }

  // --- [핵심] 이미지 추가 로직 ---
  Future<bool> addImagesToEvent() async {
    final List<int> selectedImageIds = [];
    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        selectedImageIds.add(group.images[index].imageId);
      }
    }

    if (selectedImageIds.isEmpty) {
      _error = '이미지를 하나 이상 선택해주세요.';
      notifyListeners();
      return false;
    }

    _isUploading = true;
    _error = null;
    notifyListeners();

    try {
      // 이벤트 생성 API가 아닌, 이미지 추가 API를 바로 호출
      await _eventRepository.addImagesToEvent(
        eventId,
        EventAddImagesRequestDto(imageIds: selectedImageIds),
      );
      return true;
    } catch (e) {
      _error = '이미지 추가 실패: $e';
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
