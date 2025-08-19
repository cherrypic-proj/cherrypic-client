import 'package:flutter/material.dart';
import '../../../widgets/album/album_badge_type.dart';
import 'album_payment_info_screen.dart';
import 'components/album_badge_toggle_view_model.dart';
import 'components/album_payment_info_model.dart';

class AlbumPaymentInfoViewModel extends ChangeNotifier {
  final List<AlbumPaymentInfoModel> allItems = albumPaymentInfoItems;

  /// 토글 뷰모델
  final AlbumBadgeToggleViewModel badgeToggleViewModel;

  /// 전체 보기 여부
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  AlbumPaymentInfoViewModel()
    : badgeToggleViewModel = AlbumBadgeToggleViewModel({
        for (var type in AlbumBadgeType.values)
          type: albumPaymentInfoItems
              .where((e) => e.badgeType == type)
              .length,
      }) {
    badgeToggleViewModel.addListener(notifyListeners);
  }

  /// 리스트가 2개 초과인 경우만 토글 노출
  bool get shouldShowToggle {
    final filtered = allItems.where(
          (e) => e.badgeType == badgeToggleViewModel.selectedType,
    );
    return filtered.length > 2;
  }

  /// 토글 버튼 클릭 시 상태 반전
  void toggleExpand() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  /// 현재 선택된 뱃지 타입에 따라 보여줄 아이템
  List<AlbumPaymentInfoModel> get displayedItems {
    final filtered = allItems.where(
      (e) => e.badgeType == badgeToggleViewModel.selectedType,
    );
    return _isExpanded ? filtered.toList() : filtered.take(2).toList();
  }

  @override
  void dispose() {
    badgeToggleViewModel.removeListener(notifyListeners);
    badgeToggleViewModel.dispose();
    super.dispose();
  }
}
