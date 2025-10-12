import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/album/dto/response/album_dto.dart';
import '../../../../data/album/repositories/album_repository.dart';
import '../../../widgets/album/album_badge_type.dart';
import '../album_payment_info/album_payment_info_model.dart';
import '../album_payment_info/album_payment_info_view_model.dart';

enum PaymentStatusType { using, pending }

class AlbumManagementViewModel extends ChangeNotifier {
  List<AlbumPaymentInfoModel> _allAlbums = [];
  List<AlbumPaymentInfoModel> get allItems => _allAlbums;

  final AlbumRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PaymentStatusType _selectedStatus = PaymentStatusType.using;
  PaymentStatusType get selectedStatus => _selectedStatus;

  AlbumBadgeType _selectedBadge = AlbumBadgeType.basic;
  AlbumBadgeType get selectedBadge => _selectedBadge;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  AlbumManagementViewModel({AlbumRepository? repository})
      : _repository = repository ?? AlbumRepository() {
    fetchAlbums();
  }

  PaymentStatusType _mapSubscriptionStatus(String? dtoStatus) {
    if (dtoStatus == null) return PaymentStatusType.pending;
    switch (dtoStatus.toUpperCase()) {
      case 'ACTIVE':
        return PaymentStatusType.using;
      case 'CANCELED':
      case 'EXPIRED':
        return PaymentStatusType.pending;
      default:
        return PaymentStatusType.pending;
    }
  }

  Future<AlbumPaymentInfoModel> _mapDtoToModel(AlbumDto dto) async {
    AlbumBadgeType badgeType = switch (dto.type.toUpperCase()) {
      'PRO' => AlbumBadgeType.pro,
      'PREMIUM' => AlbumBadgeType.premium,
      _ => AlbumBadgeType.basic,
    };

    final priceFormatter = NumberFormat.currency(locale: 'ko_KR', symbol: '원', decimalDigits: 0);
    final priceFormatted = priceFormatter.format(dto.price);
    final String price = badgeType == AlbumBadgeType.basic ? '무료' : '월 $priceFormatted';

    final String formattedCreateDate = dto.createdAt.split('T').first.replaceAll('-', '/');

    String? startDate;
    String? nextDate;
    PaymentStatusType status = PaymentStatusType.using;

    if (badgeType != AlbumBadgeType.basic) {
      status = _mapSubscriptionStatus(dto.status);

      try {
        final subscriptionInfo = await _repository.getAlbumSubscriptionInfo(dto.albumId);

        startDate = subscriptionInfo.subscriptionStartAt.split('T').first.replaceAll('-', '/');
        nextDate = subscriptionInfo.subscriptionNextBillingAt.split('T').first.replaceAll('-', '/');

      } catch (e) {
        debugPrint('Error fetching subscription info for album ${dto.albumId}: $e');
      }
    }

    return AlbumPaymentInfoModel(
      albumId: dto.albumId,
      badgeType: badgeType,
      title: dto.title,
      createDate: formattedCreateDate,
      startDate: startDate,
      nextDate: nextDate,
      price: price,
      status: status,
    );
  }

  /// 앨범 목록 및 구독 정보를 비동기로 가져오는 메인 함수
  Future<void> fetchAlbums() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      final Future<AlbumListResponseDto> basicFuture = _repository.getAlbums(type: 'BASIC');
      final Future<AlbumListResponseDto> proFuture = _repository.getAlbums(type: 'PRO');
      final Future<AlbumListResponseDto> premiumFuture = _repository.getAlbums(type: 'PREMIUM');

      final List<AlbumListResponseDto> responses = await Future.wait([basicFuture, proFuture, premiumFuture]);

      final List<AlbumDto> allDtos = [
        ...responses[0].albums,
        ...responses[1].albums,
        ...responses[2].albums,
      ];

      _allAlbums = await Future.wait(allDtos.map(_mapDtoToModel));

      _ensureSelectedBadge();

    } catch (e) {
      debugPrint('Error during fetchAlbums in AlbumManagementViewModel: $e');
      _allAlbums = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<AlbumBadgeType> get availableBadges {
    if (_selectedStatus == PaymentStatusType.pending) {
      return [AlbumBadgeType.pro, AlbumBadgeType.premium];
    }

    return [
      AlbumBadgeType.basic,
      AlbumBadgeType.pro,
      AlbumBadgeType.premium
    ];
  }

  List<AlbumPaymentInfoModel> get displayedItems {
    var filtered = _allAlbums.where((e) => e.status == _selectedStatus).toList();

    filtered = filtered.where((e) => e.badgeType == _selectedBadge).toList();

    if (!_isExpanded && filtered.length > 5) {
      return filtered.take(5).toList();
    }
    return filtered;
  }

  void _ensureSelectedBadge() {
    final avail = availableBadges;

    if (_selectedStatus == PaymentStatusType.using) {
      if (!avail.contains(_selectedBadge)) {
        _selectedBadge = AlbumBadgeType.basic;
      }
    } else if (_selectedStatus == PaymentStatusType.pending) {
      if (!avail.contains(_selectedBadge)) {
        _selectedBadge = AlbumBadgeType.pro;
      }
    }
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
}