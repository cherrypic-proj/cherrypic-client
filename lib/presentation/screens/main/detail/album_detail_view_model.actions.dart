part of 'album_detail_view_model.dart';

/// 이미지 업로드, 삭제 등 사용자 액션 관련 로직을 담당하는 Mixin
mixin AlbumActionsLogic on ChangeNotifier {
  // 이 Mixin이 AlbumDetailViewModel에 적용될 것을 명시하여
  // ViewModel의 멤버 변수와 메소드에 접근할 수 있도록 함
  AlbumDetailViewModel get _vm => this as AlbumDetailViewModel;

  // --- 상태 변수 ---
  bool _isUploading = false;
  String _uploadProgress = '';
  String? _uploadError;

  bool get isUploading => _isUploading;
  String get uploadProgress => _uploadProgress;
  String? get uploadError => _uploadError;

  /// 이미지 업로드 프로세스
  Future<bool> uploadImages(List<AssetEntity> assets) async {
    if (assets.isEmpty) return false;

    _isUploading = true;
    _uploadError = null;
    _uploadProgress = '준비 중... 0/${assets.length * 2}';
    notifyListeners();

    try {
      await _vm._uploadService.uploadImagesToAlbum(
        _vm.albumId,
        assets,
        onProgress: (current, total) {
          _uploadProgress = '업로드 중... $current/$total';
          notifyListeners();
        },
      );

      _isUploading = false;
      notifyListeners();

      // 업로드 완료 후 이미지 목록 새로고침
      await _vm.loadImages();
      return true;
    } catch (e) {
      _isUploading = false;
      _uploadError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// 선택된 이미지들 삭제
  Future<void> deleteSelectedImages() async {
    final List<int> idsToDelete = [];
    for (final group in _vm.groups) {
      for (final index in group.selectedIndexes) {
        idsToDelete.add(group.images[index].imageId);
      }
    }

    if (idsToDelete.isEmpty) return;

    try {
      await _vm._repository.deleteAlbumImages(
        _vm.albumId,
        AlbumImageDeleteRequestDto(imageIds: idsToDelete),
      );

      _vm.exitSelectionMode(); // AlbumSelectionLogic의 메소드 호출
      await _vm.loadImages();
    } catch (e) {
      debugPrint('이미지 삭제 실패: $e');
      // TODO: 사용자에게 에러 알림
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    _uploadError = null;
    notifyListeners();
  }
}
