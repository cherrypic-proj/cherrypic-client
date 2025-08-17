import 'package:flutter/material.dart';

import '../../../../../core/constants/font.dart';
import '../../../../widgets/album/album_badge_type.dart';
import 'album_badge_toggle_view_model.dart';

class AlbumBadgeToggle extends StatelessWidget {
  final AlbumBadgeToggleViewModel viewModel;

  const AlbumBadgeToggle({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Row(
          children: AlbumBadgeType.values
              .where((type) => type != AlbumBadgeType.none) /// 'none' 타입은 제외
              .map((type) {
            /// 현재 선택된 타입인지 확인
            final bool isSelected = viewModel.selectedType == type;
            /// 해당 타입의 개수 가져오기
            final count = viewModel.badgeCounts[type] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => viewModel.selectType(type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? type.borderColor : type.borderColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: isSelected
                        ? [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 6, offset: const Offset(0, 2))]
                        : [],
                  ),
                  child: Text(
                    /// 첫 글자 대문자로 표시 + 개수
                    '${type.name[0].toUpperCase()}${type.name.substring(1)} ($count)',
                    style: AppFont.size14.copyWith(
                      color: isSelected ? type.textColor : type.textColor.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}