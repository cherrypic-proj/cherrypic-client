import 'package:flutter/foundation.dart';

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
  /// 화면에서 사용 중인 날짜별 그룹 리스트 (API 연결 전: picsum mock)
  List<AlbumDayGroup> groups;

  AlbumDetailViewModel({List<AlbumDayGroup>? initialGroups})
    : groups = initialGroups ?? [];

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
          // 필요하면 더 추가
        ],
      ),
    ];
  }
}
