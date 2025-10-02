import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/services/album_image_upload_service.dart';

/// 날짜별 앨범 묶음 상태
class AlbumDayGroup {
  final String date; // 예: 2025.06.20
  final List<String> imageUrls; // 썸네일 URL 목록
  final Set<int> selectedIndexes; // 선택된 이미지 인덱스
  bool isAllSelected; // 전체선택 표시용

  AlbumDayGroup({
    required this.date,
    required this.imageUrls,
    Set<int>? selectedIndexes,
    this.isAllSelected = false,
  }) : selectedIndexes = selectedIndexes ?? <int>{};
}

/// 앨범 디테일 화면 전역 상태
class AlbumDetailViewModel extends ChangeNotifier {
  final AlbumImageUploadService _uploadService;
  final AlbumRepository _repository;
  final int albumId;

  /// 화면에서 사용 중인 날짜별 그룹 리스트
  List<AlbumDayGroup> groups = [];

  /// 로딩 상태
  bool _isLoading = false;
  bool _isLoadingMore = false;

  /// 업로드 상태
  bool _isUploading = false;
  String _uploadProgress = '';
  String? _uploadError;

  /// 페이지네이션
  int? _lastImageId;
  bool _isLast = false;

  /// 정렬 기준 (UPLOAD: 업로드순, GENERATED: 촬영일순)
  String _sortParameter = 'UPLOAD';

  /// 정렬 방향 (ASC: 오름차순, DESC: 내림차순)
  String _sortDirection = 'DESC';

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isUploading => _isUploading;
  String get uploadProgress => _uploadProgress;
  String? get uploadError => _uploadError;
  bool get hasMore => !_isLast;
  String get sortParameter => _sortParameter;
  String get sortDirection => _sortDirection;

  AlbumDetailViewModel({
    required this.albumId,
    AlbumImageUploadService? uploadService,
    AlbumRepository? repository,
  }) : _uploadService = uploadService ?? AlbumImageUploadService(),
       _repository = repository ?? AlbumRepository() {
    loadImages();
  }

  /// 정렬 순서 변경 후 새로고침 (같은 파라미터면 방향만 토글)
  Future<void> toggleSort(String newParameter) async {
    if (_sortParameter == newParameter) {
      // 같은 정렬 기준이면 방향만 토글
      _sortDirection = _sortDirection == 'DESC' ? 'ASC' : 'DESC';
    } else {
      // 다른 정렬 기준이면 파라미터 변경하고 내림차순으로 리셋
      _sortParameter = newParameter;
      _sortDirection = 'DESC';
    }

    notifyListeners();

    // 정렬 변경 시 처음부터 다시 로드
    await loadImages();
  }

  /// 이미지 목록 불러오기 (처음)
  Future<void> loadImages() async {
    if (_isLoading) return;

    _isLoading = true;
    _lastImageId = null;
    _isLast = false;
    notifyListeners();

    try {
      final response = await _repository.getAlbumImages(
        albumId,
        size: 20,
        parameter: _sortParameter,
        direction: _sortDirection,
      );

      groups = _groupImagesByDate(response.content);
      _isLast = response.isLast;

      if (response.content.isNotEmpty) {
        _lastImageId = response.content.last.imageId;
      }
    } catch (e) {
      debugPrint('이미지 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 이미지 더 불러오기 (페이지네이션)
  Future<void> loadMoreImages() async {
    if (_isLoadingMore || _isLast || _lastImageId == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await _repository.getAlbumImages(
        albumId,
        lastImageId: _lastImageId,
        size: 20,
        parameter: _sortParameter,
        direction: _sortDirection,
      );

      final newGroups = _groupImagesByDate(response.content);
      _mergeGroups(newGroups);

      _isLast = response.isLast;

      if (response.content.isNotEmpty) {
        _lastImageId = response.content.last.imageId;
      }
    } catch (e) {
      debugPrint('이미지 더 로드 실패: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// API 응답을 날짜별로 그룹화
  List<AlbumDayGroup> _groupImagesByDate(List<dynamic> images) {
    final Map<String, List<String>> dateMap = {};

    for (final image in images) {
      final date = _formatDate(image.date); // 2025-10-01 -> 2025.10.01
      if (!dateMap.containsKey(date)) {
        dateMap[date] = [];
      }
      dateMap[date]!.add(image.imageUrl);
    }

    return dateMap.entries
        .map((entry) => AlbumDayGroup(date: entry.key, imageUrls: entry.value))
        .toList();
  }

  /// 날짜 포맷 변환 (2025-10-01 -> 2025.10.01)
  String _formatDate(String apiDate) {
    return apiDate.replaceAll('-', '.');
  }

  /// 기존 그룹에 새 그룹 병합
  void _mergeGroups(List<AlbumDayGroup> newGroups) {
    for (final newGroup in newGroups) {
      final existingIndex = groups.indexWhere((g) => g.date == newGroup.date);

      if (existingIndex != -1) {
        // 같은 날짜 그룹이 있으면 이미지 추가
        groups[existingIndex].imageUrls.addAll(newGroup.imageUrls);
      } else {
        // 없으면 새 그룹 추가
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

    // 전체선택 상태 동기화
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

  /// 이미지 업로드 프로세스
  Future<bool> uploadImages(List<AssetEntity> assets) async {
    if (assets.isEmpty) return false;

    _isUploading = true;
    _uploadError = null;
    _uploadProgress = '준비 중... 0/${assets.length * 2}';
    notifyListeners();

    try {
      await _uploadService.uploadImagesToAlbum(
        albumId,
        assets,
        onProgress: (current, total) {
          _uploadProgress = '업로드 중... $current/$total';
          notifyListeners();
        },
      );

      _isUploading = false;
      notifyListeners();

      // 업로드 완료 후 이미지 목록 새로고침
      await loadImages();

      return true;
    } catch (e) {
      _isUploading = false;
      _uploadError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    _uploadError = null;
    notifyListeners();
  }
}
