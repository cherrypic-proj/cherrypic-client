import 'package:flutter/material.dart';
import '../../../../widgets/album/album_badge_type.dart';

/// 앨범 뱃지 토글 view에서 선택된 뱃지 타입 상태를 관리
class AlbumBadgeToggleViewModel extends ChangeNotifier {
  /// 현재 선택된 뱃지 타입
  AlbumBadgeType _selectedType = AlbumBadgeType.basic;

  /// 현재 선택된 뱃지 타입을 반환하는 getter
  AlbumBadgeType get selectedType => _selectedType;

  /// 각 뱃지 타입별 리스트 개수 저장
  final Map<AlbumBadgeType, int> badgeCounts;

  /// 뱃지 개수 초기화
  AlbumBadgeToggleViewModel(this.badgeCounts);

  /// 뱃지 타입 선택 후, 선택된 타입 변경 시 알리시
  void selectType(AlbumBadgeType type) {
    if (_selectedType != type) {
      _selectedType = type;
      notifyListeners();
    }
  }
}