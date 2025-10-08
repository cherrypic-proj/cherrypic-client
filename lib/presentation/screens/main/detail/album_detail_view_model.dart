import 'package:cherrypic/data/album/dto/request/album_image_delete_request_dto.dart';
import 'package:cherrypic/presentation/screens/main/detail/components/image_action_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/services/album_images_upload_service.dart';

// Mixin 파일들을 현재 파일의 일부로 포함시킵니다.
part 'album_detail_view_model.selection.dart';
part 'album_detail_view_model.actions.dart';

// --- 데이터 모델 정의 (이전 답변에서 추가했던 부분) ---
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
// --- 데이터 모델 정의 끝 ---

/// 앨범 디테일 화면 전역 상태
class AlbumDetailViewModel extends ChangeNotifier
    with AlbumSelectionLogic, AlbumActionsLogic {
  // Mixin을 사용하여 기능 확장

  final AlbumImageUploadService _uploadService;
  final AlbumRepository _repository;
  final int albumId;

  List<AlbumDayGroup> groups = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;
  int? _lastImageId;
  bool _isLast = false;
  String _sortParameter = 'UPLOAD';
  String _sortDirection = 'DESC';

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
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
    if (_isLoading) return;
    _isLoading = true;
    _lastImageId = null;
    _isLast = false;
    groups.clear(); // 새로 로드할 때 기존 그룹 초기화
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

  List<AlbumDayGroup> _groupImagesByDate(List<dynamic> imageDtos) {
    final Map<String, List<AlbumImage>> dateMap = {};
    for (final dto in imageDtos) {
      final date = _formatDate(dto.date);
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

  String _formatDate(String apiDate) {
    return apiDate.replaceAll('-', '.');
  }

  void _mergeGroups(List<AlbumDayGroup> newGroups) {
    for (final newGroup in newGroups) {
      final existingIndex = groups.indexWhere((g) => g.date == newGroup.date);
      if (existingIndex != -1) {
        groups[existingIndex].images.addAll(newGroup.images);
      } else {
        groups.add(newGroup);
      }
    }
  }

  /// 선택된 이미지들 다운로드
  Future<void> downloadSelectedImages(BuildContext context) async {
    final service = ImageActionService();
    final List<String> urlsToDownload = [];

    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        urlsToDownload.add(group.images[index].imageUrl);
      }
    }

    if (urlsToDownload.isNotEmpty) {
      await service.downloadImages(context, urlsToDownload);
    }
  }

  /// 선택된 이미지들 공유
  Future<void> shareSelectedImages(BuildContext context) async {
    final service = ImageActionService();
    final List<String> urlsToShare = [];

    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        urlsToShare.add(group.images[index].imageUrl);
      }
    }

    if (urlsToShare.isNotEmpty) {
      await service.shareImages(context, urlsToShare);
    }
  }

  /// 단일 이미지 삭제 (Full Screen Viewer에서 사용)
  Future<bool> deleteSingleImage(int imageId) async {
    try {
      await _repository.deleteAlbumImages(
        albumId,
        AlbumImageDeleteRequestDto(imageIds: [imageId]),
      );
      // 중요: 삭제 후 전체 이미지 목록을 즉시 새로고침합니다.
      await loadImages();
      return true;
    } catch (e) {
      debugPrint('단일 이미지 삭제 실패: $e');
      return false;
    }
  }

  /// 단일 이미지 공유 (Full Screen Viewer에서 사용)
  Future<void> shareSingleImage(BuildContext context, String imageUrl) async {
    final service = ImageActionService();
    // 기존 서비스를 재사용하여 이미지 URL이 하나만 담긴 리스트를 전달합니다.
    await service.shareImages(context, [imageUrl]);
  }
}
