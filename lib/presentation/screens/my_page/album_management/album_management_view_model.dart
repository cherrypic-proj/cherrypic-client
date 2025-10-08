import 'package:flutter/material.dart';
import '../../../widgets/album/album_badge_type.dart';
import '../album_payment_info/album_payment_info_model.dart';
// ✅ AlbumFilterType(pro/premium) 타입 가져오기 (TypeToggle이 이 타입을 받음)
import '../album_payment_info/album_payment_info_view_model.dart';

enum PaymentStatusType { using, pending }

class AlbumManagementViewModel extends ChangeNotifier {
  final List<AlbumPaymentInfoModel> allItems = const [
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.basic,
      title: '음식(양식, 중식, 한식, 일식) 음식 음식',
      createDate: '2025/06/23',
      price: '무료',
      status: PaymentStatusType.using,
    ),
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.pro,
      title: '프랑스 여행_2025.06.24',
      createDate: '2025/06/23',
      startDate: '2025/05/25',
      nextDate: '2025/08/25',
      price: '월 3,900원',
      status: PaymentStatusType.using,
    ),
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.premium,
      title: '호주 여행',
      createDate: '2025/06/23',
      startDate: '2025/06/28',
      nextDate: '2025/08/25',
      price: '월 5,900원',
      status: PaymentStatusType.pending,
    ),
  ];

  // 1차: 상태 선택
  PaymentStatusType _selectedFilter = PaymentStatusType.using;
  PaymentStatusType get selectedFilter => _selectedFilter;

  // ✅ TypeToggle용 매핑 Getter (PaymentStatusType → AlbumFilterType)
  AlbumFilterType get selectedFilterForToggle =>
      _selectedFilter == PaymentStatusType.using
          ? AlbumFilterType.pro          // '이용중' 라벨에 해당
          : AlbumFilterType.premium;     // '결제대기' 라벨에 해당

  // 2차: 배지 선택
  AlbumBadgeType _selectedBadge = AlbumBadgeType.basic;
  AlbumBadgeType get selectedBadge => _selectedBadge;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  AlbumManagementViewModel() {
    _ensureSelectedBadge();
  }

  List<AlbumBadgeType> get availableBadges {
    final set = <AlbumBadgeType>{};
    for (final item in allItems) {
      if (item.status == _selectedFilter) set.add(item.badgeType);
    }
    const order = [AlbumBadgeType.basic, AlbumBadgeType.pro, AlbumBadgeType.premium];
    return order.where(set.contains).toList();
  }

  List<AlbumPaymentInfoModel> get displayedItems {
    var filtered = allItems.where((e) => e.status == _selectedFilter).toList();
    if (availableBadges.contains(_selectedBadge)) {
      filtered = filtered.where((e) => e.badgeType == _selectedBadge).toList();
    }
    if (!_isExpanded && filtered.length > 3) return filtered.take(3).toList();
    return filtered;
  }

  // 기존 상태 변경
  void changeFilter(PaymentStatusType filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    _isExpanded = false;
    _ensureSelectedBadge();
    notifyListeners();
  }

  // ✅ TypeToggle onChanged용 매핑 (AlbumFilterType → PaymentStatusType)
  void changeFilterFromToggle(AlbumFilterType filterForToggle) {
    final mapped = (filterForToggle == AlbumFilterType.pro)
        ? PaymentStatusType.using
        : PaymentStatusType.pending;
    changeFilter(mapped);
  }

  void changeBadge(AlbumBadgeType badge) {
    if (_selectedBadge == badge) return;
    _selectedBadge = badge;
    _isExpanded = false;
    notifyListeners();
  }

  void toggleExpand() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void _ensureSelectedBadge() {
    final avail = availableBadges;
    if (avail.isEmpty) return;
    if (!avail.contains(_selectedBadge)) {
      _selectedBadge = avail.first;
    }
  }
}