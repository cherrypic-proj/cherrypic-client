import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/album/dto/response/album_dto.dart';
import '../../../../data/album/repositories/album_repository.dart';
import '../../../widgets/album/album_badge_type.dart';

import 'album_payment_info_model.dart';

/// Pro / Premium 타입
enum AlbumFilterType {
  pro,
  premium,
}

class AlbumPaymentInfoViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;

  AlbumPaymentInfoViewModel({AlbumRepository? albumRepository})
      : _albumRepository = albumRepository ?? AlbumRepository() {
    fetchAlbums();
  }

  List<AlbumDto> _proAlbums = [];
  List<AlbumDto> _premiumAlbums = [];

  List<AlbumPaymentInfoModel> _paymentInfoModels = [];
  List<AlbumPaymentInfoModel> get filteredItems => _paymentInfoModels;

  /// 전체 보기 여부
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 현재 선택된 필터 (기본값: Pro)
  AlbumFilterType _selectedFilter = AlbumFilterType.pro;
  AlbumFilterType get selectedFilter => _selectedFilter;

  Future<void> fetchAlbums() async {
    _isLoading = true;
    notifyListeners();
    try {
      final proResponse = await _albumRepository.getAlbums(type: 'PRO');
      _proAlbums = proResponse.albums;

      final premiumResponse = await _albumRepository.getAlbums(type: 'PREMIUM');
      _premiumAlbums = premiumResponse.albums;

      await _loadFilteredItems();

    } catch (e) {
      debugPrint('Error fetching albums: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFilteredItems() async {
    final List<AlbumDto> albums = _selectedFilter == AlbumFilterType.pro
        ? _proAlbums
        : _premiumAlbums;

    final List<AlbumDto> displayAlbums = _isExpanded || albums.length <= 5
        ? albums
        : albums.take(5).toList();

    fetchAndMap(dto) async {
      AlbumBadgeType badgeType;
      if (dto.type.toUpperCase() == 'PRO') {
        badgeType = AlbumBadgeType.pro;
      } else if (dto.type.toUpperCase() == 'PREMIUM') {
        badgeType = AlbumBadgeType.premium;
      } else {
        badgeType = AlbumBadgeType.none;
      }

      final priceFormatted = NumberFormat.currency(
          locale: 'ko_KR',
          symbol: '원',
          decimalDigits: 0
      ).format(dto.price);

      final String formattedCreateDate = dto.createdAt.split('T').first.replaceAll('-', '/');

      String? startDate;
      String? nextDate;

      if (dto.type.toUpperCase() == 'PRO' || dto.type.toUpperCase() == 'PREMIUM') {
        try {
          final subscriptionInfo = await _albumRepository.getAlbumSubscriptionInfo(dto.albumId);

          startDate = subscriptionInfo.subscriptionStartAt.split('T').first.replaceAll('-', '/');

          nextDate = subscriptionInfo.subscriptionNextBillingAt.split('T').first.replaceAll('-', '/');

        } catch (e) {
          debugPrint('Error fetching subscription info for album ${dto.albumId}: $e');
        }
      }

      // 3. 최종 모델 생성
      return AlbumPaymentInfoModel(
        albumId: dto.albumId,
        badgeType: badgeType,
        title: dto.title,
        createDate: formattedCreateDate,
        startDate: startDate,
        nextDate: nextDate,
        price: '월 $priceFormatted',
        status: null,
      );
    }

    _paymentInfoModels = await Future.wait(displayAlbums.map(fetchAndMap));

    notifyListeners();
  }


  /// 전체 항목 개수 기준 토글 표시 여부
  bool get shouldShowToggle {
    final bool proExceeds = _proAlbums.length > 5;
    final bool premiumExceeds = _premiumAlbums.length > 5;
    return proExceeds || premiumExceeds;
  }

  /// 필터 변경
  void onToggleType(AlbumFilterType type) async {
    if (_selectedFilter != type) {
      _selectedFilter = type;
      _isExpanded = false;
      _isLoading = true;
      notifyListeners();

      await _loadFilteredItems();

      _isLoading = false;
      notifyListeners();
    }
  }

  /// 전체 보기 토글
  void toggleExpansion() async {
    _isExpanded = !_isExpanded;
    _isLoading = true;
    notifyListeners();

    await _loadFilteredItems();

    _isLoading = false;
    notifyListeners();
  }
}