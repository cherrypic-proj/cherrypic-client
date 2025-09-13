import 'package:flutter/material.dart';
import '../../../widgets/album/album_badge_type.dart';
import 'album_payment_info_model.dart';

/// Pro / Premium 타입
enum AlbumFilterType {
  pro,
  premium,
}

class AlbumPaymentInfoViewModel extends ChangeNotifier {
  /// 전체 항목 리스트
  final List<AlbumPaymentInfoModel> allItems = const [
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.basic,
      title: '음식(양식, 중식, 한식, 일식) 음식 음식',
      createDate: '2025/06/23',
      price: '무료',
    ),
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.pro,
      title: '프랑스 여행_2025. 06. 24',
      createDate: '2025/06/23',
      startDate: '2025/05/25',
      nextDate: '2025/08/25',
      price: '월 3,900원',
    ),
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.premium,
      title: '호주 여행',
      createDate: '2025/06/23',
      startDate: '2025/06/28',
      nextDate: '2025/08/25',
      price: '월 5,900원',
    ),
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.pro,
      title: '등반',
      createDate: '2025/06/23',
      startDate: '2025/07/01',
      nextDate: '2025/09/01',
      price: '월 3,900원',
    ),
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.premium,
      title: '호주 여행',
      createDate: '2025/06/23',
      startDate: '2025/06/28',
      nextDate: '2025/08/25',
      price: '월 5,900원',
    ),
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.pro,
      title: '프랑스 여행_2025. 06. 24',
      createDate: '2025/06/23',
      startDate: '2025/05/25',
      nextDate: '2025/08/25',
      price: '월 3,900원',
    ),
  ];

  /// 전체 보기 여부
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  /// 현재 선택된 필터 (기본값: Pro)
  AlbumFilterType _selectedFilter = AlbumFilterType.pro;
  AlbumFilterType get selectedFilter => _selectedFilter;

  /// 전체 항목 개수 기준 토글 표시 여부
  bool get shouldShowToggle => allItems.length > 3;

  /// 현재 선택된 토글(Pro/Premium)에 맞게 필터링된 항목
  List<AlbumPaymentInfoModel> get displayedItems {
    final filtered = allItems.where((item) {
      if (_selectedFilter == AlbumFilterType.pro) {
        return item.badgeType == AlbumBadgeType.pro;
      } else {
        return item.badgeType == AlbumBadgeType.premium;
      }
    }).toList();

    return _isExpanded ? filtered : filtered.take(3).toList();
  }

  /// 전체 보기 토글
  void toggleExpand() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  /// 필터 변경 (Pro/Premium 토글 클릭 시 호출)
  void changeFilter(AlbumFilterType type) {
    _selectedFilter = type;
    _isExpanded = false; // 토글 바꿀 때마다 초기화
    notifyListeners();
  }
}