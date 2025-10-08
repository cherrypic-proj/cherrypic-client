import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:cherrypic/presentation/screens/main/detail/components/image_action_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 날짜별 이벤트 이미지 묶음 상태
class EventDayGroup {
  final String date;
  final List<String> imageUrls;
  final Set<int> selectedIndexes;
  bool isAllSelected;

  EventDayGroup({
    required this.date,
    required this.imageUrls,
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

  /// 화면에서 사용 중인 날짜별 그룹 리스트
  List<EventDayGroup> groups = [];

  /// 로딩 상태
  bool _isLoading = false;
  bool _isLoadingMore = false;

  /// 페이지네이션
  int? _lastEventImageId;
  bool _isLast = false;

  /// 선택 모드 활성화 여부
  bool _isSelectionMode = false;
  bool get isSelectionMode => _isSelectionMode;

  /// 정렬 기준
  String _sortParameter = 'UPLOAD';
  String _sortDirection = 'DESC';

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => !_isLast;
  String get sortParameter => _sortParameter;
  String get sortDirection => _sortDirection;

  /// 선택 모드 진입
  void enterSelectionMode() {
    _isSelectionMode = true;
    notifyListeners();
  }

  /// 선택 모드 종료 및 선택 초기화
  void exitSelectionMode() {
    _isSelectionMode = false;
    clearAllSelection();
    notifyListeners();
  }

  /// 정렬 순서 변경 후 새로고침
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

  /// 이미지 목록 불러오기 (처음)
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

  /// 이미지 더 불러오기 (페이지네이션)
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

  /// API 응답을 날짜별로 그룹화
  List<EventDayGroup> _groupImagesByDate(List<dynamic> images) {
    final Map<String, List<String>> dateMap = {};

    for (final image in images) {
      final date = _formatDate(image.date);
      if (!dateMap.containsKey(date)) {
        dateMap[date] = [];
      }
      dateMap[date]!.add(image.imageUrl);
    }

    return dateMap.entries
        .map((entry) => EventDayGroup(date: entry.key, imageUrls: entry.value))
        .toList();
  }

  /// 날짜 포맷 변환 (2025-10-01 -> 2025.10.01)
  String _formatDate(String apiDate) {
    return apiDate.replaceAll('-', '.');
  }

  /// 기존 그룹에 새 그룹 병합
  void _mergeGroups(List<EventDayGroup> newGroups) {
    for (final newGroup in newGroups) {
      final existingIndex = groups.indexWhere((g) => g.date == newGroup.date);

      if (existingIndex != -1) {
        groups[existingIndex].imageUrls.addAll(newGroup.imageUrls);
      } else {
        groups.add(newGroup);
      }
    }
  }

  /// 총 선택 개수
  int get selectedCount =>
      groups.fold(0, (sum, g) => sum + g.selectedIndexes.length);

  /// 하나라도 선택돼 있으면 true
  bool get isSelecting => selectedCount > 0;

  /// 특정 날짜 그룹에서 이미지 선택/해제
  void toggleImage(int dayIndex, int imgIndex) {
    if (dayIndex < 0 || dayIndex >= groups.length) return;
    final g = groups[dayIndex];
    if (imgIndex < 0 || imgIndex >= g.imageUrls.length) return;

    if (g.selectedIndexes.contains(imgIndex)) {
      g.selectedIndexes.remove(imgIndex);
    } else {
      g.selectedIndexes.add(imgIndex);
    }

    g.isAllSelected = g.selectedIndexes.length == g.imageUrls.length;
    notifyListeners();
  }

  /// 특정 날짜 그룹 전체선택/해제
  void toggleAll(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= groups.length) return;
    final g = groups[dayIndex];

    if (g.isAllSelected) {
      g.selectedIndexes.clear();
      g.isAllSelected = false;
    } else {
      if (!_isSelectionMode) {
        _isSelectionMode = true;
      }

      g.selectedIndexes
        ..clear()
        ..addAll(List<int>.generate(g.imageUrls.length, (i) => i));
      g.isAllSelected = true;
    }

    notifyListeners();
  }

  /// 모든 날짜의 선택을 해제
  void clearAllSelection() {
    for (final g in groups) {
      g.selectedIndexes.clear();
      g.isAllSelected = false;
    }
    notifyListeners();
  }

  /// 선택된 이미지들 다운로드
  Future<void> downloadSelectedImages(BuildContext context) async {
    final service = ImageActionService();
    final List<String> urlsToDownload = [];
    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        urlsToDownload.add(group.imageUrls[index]);
      }
    }
    if (urlsToDownload.isNotEmpty) {
      await service.downloadImages(context, urlsToDownload);
    }
    exitSelectionMode();
  }

  /// 선택된 이미지들 공유
  Future<void> shareSelectedImages(BuildContext context) async {
    final service = ImageActionService();
    final List<String> urlsToShare = [];
    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        urlsToShare.add(group.imageUrls[index]);
      }
    }
    if (urlsToShare.isNotEmpty) {
      await service.shareImages(context, urlsToShare);
    }
    exitSelectionMode();
  }

  /// 선택된 이미지들 삭제
  Future<void> deleteSelectedImages(BuildContext context) async {
    // TODO: 이벤트 이미지 삭제 API 및 Repository 구현 필요.
    // 현재 EventDetailViewModel은 imageUrl만 알고 있고, 삭제에 필요한 imageId를 알 수 없습니다.
    // 이 기능을 구현하려면 API 명세 확인 후 EventRepository에 이미지 삭제 기능 추가 및
    // EventDayGroup 모델에 imageId를 포함하도록 수정해야 합니다.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('이벤트 사진 삭제 기능은 아직 지원되지 않습니다.')),
    );
    exitSelectionMode();
  }
}
