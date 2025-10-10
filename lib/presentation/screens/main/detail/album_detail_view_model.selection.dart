part of 'album_detail_view_model.dart';

/// 사진 선택 관련 상태와 로직을 담당하는 Mixin
mixin AlbumSelectionLogic on ChangeNotifier {
  AlbumDetailViewModel get _vm => this as AlbumDetailViewModel;

  // --- 상태 변수 ---
  bool _isSelectionMode = false;
  bool get isSelectionMode => _isSelectionMode;

  // --- Computed Properties ---
  int get selectedCount =>
      _vm.groups.fold(0, (sum, g) => sum + g.selectedIndexes.length);
  bool get isSelecting => selectedCount > 0;

  // --- 메소드 ---
  void enterSelectionMode() {
    _isSelectionMode = true;
    notifyListeners();
  }

  void exitSelectionMode() {
    _isSelectionMode = false;
    clearAllSelection();
    // notifyListeners()는 clearAllSelection 내부에서 호출됨
  }

  void toggleImage(int dayIndex, int imgIndex) {
    final g = _vm.groups[dayIndex];
    if (imgIndex < 0 || imgIndex >= g.images.length) return;

    if (g.selectedIndexes.contains(imgIndex)) {
      g.selectedIndexes.remove(imgIndex);
    } else {
      g.selectedIndexes.add(imgIndex);
    }
    g.isAllSelected = g.selectedIndexes.length == g.images.length;
    notifyListeners();
  }

  void toggleAll(int dayIndex) {
    final g = _vm.groups[dayIndex];
    if (g.isAllSelected) {
      g.selectedIndexes.clear();
      g.isAllSelected = false;
    } else {
      if (!_isSelectionMode) {
        _isSelectionMode = true;
      }
      g.selectedIndexes
        ..clear()
        ..addAll(List<int>.generate(g.images.length, (i) => i));
      g.isAllSelected = true;
    }
    notifyListeners();
  }

  void clearAllSelection() {
    for (final g in _vm.groups) {
      g.selectedIndexes.clear();
      g.isAllSelected = false;
    }
    notifyListeners();
  }
}
