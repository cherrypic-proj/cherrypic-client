import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
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
  final int albumId;

  /// 화면에서 사용 중인 날짜별 그룹 리스트
  List<AlbumDayGroup> groups;

  /// 업로드 상태
  bool _isUploading = false;
  String _uploadProgress = '';
  String? _uploadError;

  bool get isUploading => _isUploading;
  String get uploadProgress => _uploadProgress;
  String? get uploadError => _uploadError;

  AlbumDetailViewModel({
    required this.albumId,
    List<AlbumDayGroup>? initialGroups,
    AlbumImageUploadService? uploadService,
  }) : groups = initialGroups ?? [],
       _uploadService = uploadService ?? AlbumImageUploadService();

  /// 외부에서 데이터 세팅하고 싶을 때 사용
  void setGroups(List<AlbumDayGroup> newGroups) {
    groups = newGroups;
    notifyListeners();
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

      // TODO: 업로드 완료 후 이미지 목록 새로고침
      // await loadImages();

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

  /// --- Mock 데이터 (API 연결 전 유지) ---
  static List<AlbumDayGroup> _mockGroups() {
    return [
      AlbumDayGroup(
        date: '2025.06.20',
        imageUrls: const [
          'https://picsum.photos/id/1011/600/600',
          'https://picsum.photos/id/1015/600/600',
          'https://picsum.photos/id/1025/600/600',
          'https://picsum.photos/id/1035/600/600',
          'https://picsum.photos/id/1024/600/600',
          'https://picsum.photos/id/1043/600/600',
        ],
      ),
      AlbumDayGroup(
        date: '2025.06.18',
        imageUrls: const [
          'https://picsum.photos/id/1062/600/600',
          'https://picsum.photos/id/1050/600/600',
        ],
      ),
    ];
  }
}
