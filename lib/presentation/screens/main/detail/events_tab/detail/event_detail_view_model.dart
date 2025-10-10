import 'package:cherrypic/data/album_event/dto/request/event_delete_images_request_dto.dart';
import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:cherrypic/presentation/screens/main/detail/components/image_action_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// [신규] 이미지의 ID와 URL을 함께 관리하기 위한 모델
class EventImageModel {
  final int id;
  final String imageUrl;

  EventImageModel({required this.id, required this.imageUrl});
}

/// 날짜별 이벤트 이미지 묶음 상태
class EventDayGroup {
  final String date;
  //   String List 대신 EventImageModel List를 사용합니다.
  final List<EventImageModel> images;
  final Set<int> selectedIndexes;
  bool isAllSelected;

  EventDayGroup({
    required this.date,
    required this.images,
    Set<int>? selectedIndexes,
    this.isAllSelected = false,
  }) : selectedIndexes = selectedIndexes ?? <int>{};
}

/// 이벤트 상세 화면 전역 상태
class EventDetailViewModel extends ChangeNotifier {
  final EventRepository _repository;
  final int eventId;

  EventDetailViewModel({required this.eventId, EventRepository? repository})
    : _repository = repository ?? EventRepository() {
    loadImages();
  }

  List<EventDayGroup> groups = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int? _lastEventImageId;
  bool _isLast = false;
  bool _isSelectionMode = false;
  bool get isSelectionMode => _isSelectionMode;
  String _sortParameter = 'UPLOAD';
  String _sortDirection = 'DESC';
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => !_isLast;
  String get sortParameter => _sortParameter;
  String get sortDirection => _sortDirection;

  // ... enterSelectionMode, exitSelectionMode, toggleSort 함수는 기존과 동일 ...
  void enterSelectionMode() {
    _isSelectionMode = true;
    notifyListeners();
  }

  void exitSelectionMode() {
    _isSelectionMode = false;
    clearAllSelection();
    notifyListeners();
  }

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
  // ---

  Future<void> loadImages() async {
    if (_isLoading) return;
    _isLoading = true;
    _lastEventImageId = null;
    _isLast = false;
    notifyListeners();

    try {
      final response = await _repository.getEventImages(
        eventId: eventId,
        size: 20,
        parameter: _sortParameter,
        direction: _sortDirection,
      );
      //   API 응답을 새로운 모델에 맞게 그룹화합니다.
      groups = _groupImagesByDate(response.content);
      _isLast = response.isLast;
      if (response.content.isNotEmpty) {
        _lastEventImageId = response.content.last.eventImageId;
      }
    } catch (e) {
      debugPrint('이벤트 이미지 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreImages() async {
    if (_isLoadingMore || _isLast || _lastEventImageId == null) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await _repository.getEventImages(
        eventId: eventId,
        lastEventImageId: _lastEventImageId,
        size: 20,
        parameter: _sortParameter,
        direction: _sortDirection,
      );
      //   API 응답을 새로운 모델에 맞게 그룹화합니다.
      final newGroups = _groupImagesByDate(response.content);
      _mergeGroups(newGroups);
      _isLast = response.isLast;
      if (response.content.isNotEmpty) {
        _lastEventImageId = response.content.last.eventImageId;
      }
    } catch (e) {
      debugPrint('추가 이벤트 이미지 로드 실패: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  ///   API 응답(dynamic)을 EventImageModel로 변환하고 날짜별로 그룹화
  List<EventDayGroup> _groupImagesByDate(List<dynamic> images) {
    // `images`의 각 요소는 eventImageId, imageUrl, date 등을 포함한 객체라고 가정합니다.
    final Map<String, List<EventImageModel>> dateMap = {};
    for (final image in images) {
      final date = _formatDate(image.date);
      if (!dateMap.containsKey(date)) {
        dateMap[date] = [];
      }
      dateMap[date]!.add(
        EventImageModel(id: image.eventImageId, imageUrl: image.imageUrl),
      );
    }
    return dateMap.entries
        .map((entry) => EventDayGroup(date: entry.key, images: entry.value))
        .toList();
  }

  String _formatDate(String apiDate) {
    return apiDate.replaceAll('-', '.');
  }

  ///   새로운 그룹 병합 로직
  void _mergeGroups(List<EventDayGroup> newGroups) {
    for (final newGroup in newGroups) {
      final existingIndex = groups.indexWhere((g) => g.date == newGroup.date);
      if (existingIndex != -1) {
        groups[existingIndex].images.addAll(newGroup.images);
      } else {
        groups.add(newGroup);
      }
    }
  }

  int get selectedCount =>
      groups.fold(0, (sum, g) => sum + g.selectedIndexes.length);

  bool get isSelecting => selectedCount > 0;

  void toggleImage(int dayIndex, int imgIndex) {
    final g = groups[dayIndex];
    if (g.selectedIndexes.contains(imgIndex)) {
      g.selectedIndexes.remove(imgIndex);
    } else {
      g.selectedIndexes.add(imgIndex);
    }
    //   images.length로 전체 선택 여부 확인
    g.isAllSelected = g.selectedIndexes.length == g.images.length;
    notifyListeners();
  }

  void toggleAll(int dayIndex) {
    final g = groups[dayIndex];
    if (g.isAllSelected) {
      g.selectedIndexes.clear();
      g.isAllSelected = false;
    } else {
      if (!_isSelectionMode) _isSelectionMode = true;
      g.selectedIndexes
        ..clear()
        //   images.length 만큼 인덱스 생성
        ..addAll(List<int>.generate(g.images.length, (i) => i));
      g.isAllSelected = true;
    }
    notifyListeners();
  }

  void clearAllSelection() {
    for (final g in groups) {
      g.selectedIndexes.clear();
      g.isAllSelected = false;
    }
    notifyListeners();
  }

  Future<void> downloadSelectedImages(BuildContext context) async {
    final service = ImageActionService();
    final List<String> urlsToDownload = [];
    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        //   모델에서 imageUrl을 추출
        urlsToDownload.add(group.images[index].imageUrl);
      }
    }
    if (urlsToDownload.isNotEmpty) {
      await service.downloadImages(context, urlsToDownload);
    }
    exitSelectionMode();
  }

  Future<void> shareSelectedImages(BuildContext context) async {
    final service = ImageActionService();
    final List<String> urlsToShare = [];
    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        //   모델에서 imageUrl을 추출
        urlsToShare.add(group.images[index].imageUrl);
      }
    }
    if (urlsToShare.isNotEmpty) {
      await service.shareImages(context, urlsToShare);
    }
    exitSelectionMode();
  }

  ///   선택된 이미지들 삭제 기능 구현
  Future<void> deleteSelectedImages(BuildContext context) async {
    // 1. 삭제할 이미지 ID 목록 추출
    final List<int> idsToDelete = [];
    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        idsToDelete.add(group.images[index].id);
      }
    }

    if (idsToDelete.isEmpty) {
      exitSelectionMode();
      return;
    }

    try {
      // 2. API 요청 DTO 생성 및 전송
      final requestDto = EventDeleteImagesRequestDto(
        eventImageIds: idsToDelete,
      );
      await _repository.deleteImagesFromEvent(eventId, requestDto);

      // 3. (성공 시) UI에서 즉시 반영. 서버 데이터를 다시 불러오지 않아 UX 개선
      for (int i = groups.length - 1; i >= 0; i--) {
        final group = groups[i];
        // 선택된 인덱스를 내림차순으로 정렬하여 삭제 시 인덱스 변경 문제 방지
        final sortedIndexes = group.selectedIndexes.toList()
          ..sort((a, b) => b.compareTo(a));
        for (final index in sortedIndexes) {
          group.images.removeAt(index);
        }
        // 그룹에 이미지가 모두 삭제되었다면 그룹 자체를 제거
        if (group.images.isEmpty) {
          groups.removeAt(i);
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('선택한 사진이 삭제되었습니다.')));
    } catch (e) {
      debugPrint('이미지 삭제 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('사진 삭제에 실패했습니다: $e')));
    } finally {
      // 4. 선택 모드 종료
      exitSelectionMode();
    }
  }
}
