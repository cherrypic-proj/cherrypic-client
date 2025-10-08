import 'package:flutter/material.dart';
import '../../../widgets/album/album_badge_type.dart';
import '../album_payment_info/album_payment_info_model.dart';
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
      title: '프랑스 여행_2025.06.24',
      createDate: '2025/06/23',
      startDate: '2025/05/25',
      nextDate: '2025/08/25',
      price: '월 3,900원',
      status: PaymentStatusType.using,
    ),
    AlbumPaymentInfoModel(
      badgeType: AlbumBadgeType.pro,
      title: '호주 여행',
      createDate: '2025/06/23',
      startDate: '2025/06/28',
      nextDate: '2025/08/25',
      price: '월 5,900원',
      status: PaymentStatusType.pending,
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

  PaymentStatusType _selectedStatus = PaymentStatusType.using;
  PaymentStatusType get selectedStatus => _selectedStatus;

  AlbumBadgeType _selectedBadge = AlbumBadgeType.basic;
  AlbumBadgeType get selectedBadge => _selectedBadge;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  AlbumManagementViewModel() {
    _ensureSelectedBadge();
  }

  List<AlbumBadgeType> get availableBadges {
    if (_selectedStatus == PaymentStatusType.pending) {
      return [AlbumBadgeType.pro, AlbumBadgeType.premium];
    }

    final set = <AlbumBadgeType>{};
    for (final item in allItems) {
      if (item.status == _selectedStatus) {
        set.add(item.badgeType);
      }
    }
    const order = [
      AlbumBadgeType.basic,
      AlbumBadgeType.pro,
      AlbumBadgeType.premium
    ];
    return order.where(set.contains).toList();
  }

  List<AlbumPaymentInfoModel> get displayedItems {
    var filtered = allItems.where((e) => e.status == _selectedStatus).toList();

    if (availableBadges.contains(_selectedBadge)) {
      filtered = filtered.where((e) => e.badgeType == _selectedBadge).toList();
    }

    if (!_isExpanded && filtered.length > 5) {
      return filtered.take(5).toList();
    }
    return filtered;
  }

  void changeStatus(PaymentStatusType status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _isExpanded = false;
    _ensureSelectedBadge();
    notifyListeners();
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

  AlbumFilterType get toggleTypeForSelectedStatus {
    switch (_selectedStatus) {
      case PaymentStatusType.using:
        return AlbumFilterType.pro;
      case PaymentStatusType.pending:
        return AlbumFilterType.premium;
    }
  }

  void onToggleTypeChanged(AlbumFilterType newToggleType) {
    final mappedStatus = _mapToggleTypeToStatus(newToggleType);
    changeStatus(mappedStatus);
  }

  PaymentStatusType _mapToggleTypeToStatus(AlbumFilterType toggleType) {
    switch (toggleType) {
      case AlbumFilterType.pro:
        return PaymentStatusType.using;
      case AlbumFilterType.premium:
        return PaymentStatusType.pending;
    }
  }

  void _ensureSelectedBadge() {
    final avail = availableBadges;
    if (avail.isEmpty) return;
    if (!avail.contains(_selectedBadge)) {
      _selectedBadge = avail.first;
    }
  }
}