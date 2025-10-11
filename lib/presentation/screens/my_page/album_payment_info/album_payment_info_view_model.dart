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
  // ✨ [추가] AlbumRepository 주입
  final AlbumRepository _albumRepository;

  AlbumPaymentInfoViewModel({AlbumRepository? albumRepository})
      : _albumRepository = albumRepository ?? AlbumRepository() {
    // ViewModel 생성 시점에 데이터 로딩 시작
    fetchAlbums();
  }

  // ✨ [수정] API에서 받아온 PRO/PREMIUM 앨범 목록을 저장할 상태 변수
  List<AlbumDto> _proAlbums = [];
  List<AlbumDto> _premiumAlbums = [];

  /// 전체 보기 여부
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  /// 현재 선택된 필터 (기본값: Pro)
  AlbumFilterType _selectedFilter = AlbumFilterType.pro;
  AlbumFilterType get selectedFilter => _selectedFilter;

  Future<void> fetchAlbums() async {
    try {
      // PRO 앨범 목록 조회
      final proResponse = await _albumRepository.getAlbums(type: 'PRO');
      _proAlbums = proResponse.albums;

      // PREMIUM 앨범 목록 조회
      final premiumResponse = await _albumRepository.getAlbums(type: 'PREMIUM');
      _premiumAlbums = premiumResponse.albums;

    } catch (e) {
      debugPrint('Error fetching albums: $e');
      // 에러 처리 로직
    } finally {
      notifyListeners();
    }
  }

  /// 전체 항목 개수 기준 토글 표시 여부
  bool get shouldShowToggle {
    final bool proExceeds = _proAlbums.length > 5;

    final bool premiumExceeds = _premiumAlbums.length > 5;

    return proExceeds || premiumExceeds;
  }

  List<AlbumPaymentInfoModel> get filteredItems {
    final List<AlbumDto> albums = _selectedFilter == AlbumFilterType.pro
        ? _proAlbums
        : _premiumAlbums;

    final List<AlbumDto> displayAlbums = _isExpanded || albums.length <= 5
        ? albums
        : albums.take(5).toList();

    return displayAlbums.map((dto) {
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

      String formattedCreateDate = dto.createdAt.split('T').first.replaceAll('-', '/');

      return AlbumPaymentInfoModel(
        badgeType: badgeType,
        title: dto.title,
        createDate: formattedCreateDate,
        price: '월 $priceFormatted',
      );
    }).toList();
  }

  /// 필터 변경
  void onToggleType(AlbumFilterType type) {
    if (_selectedFilter != type) {
      _selectedFilter = type;
      _isExpanded = false;
      notifyListeners();
    }
  }

  /// 전체 보기 토글
  void toggleExpansion() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}