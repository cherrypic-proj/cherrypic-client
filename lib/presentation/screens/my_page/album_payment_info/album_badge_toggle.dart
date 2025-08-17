import 'package:flutter/material.dart';

import '../../../../core/constants/font.dart';
import '../../../widgets/album/album_badge_type.dart';

class AlbumBadgeToggle extends StatelessWidget {
  final AlbumBadgeType selectedBadgeType;
  final void Function(AlbumBadgeType) onBadgeTypeChanged;
  final Map<AlbumBadgeType, int> badgeCounts;

  const AlbumBadgeToggle({
    super.key,
    required this.selectedBadgeType,
    required this.onBadgeTypeChanged,
    required this.badgeCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AlbumBadgeType.values
          .where((type) => type != AlbumBadgeType.none)
          .map((type) {
        final bool isSelected = selectedBadgeType == type;
        final count = badgeCounts[type] ?? 0;

        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onBadgeTypeChanged(type),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? type.borderColor : type.borderColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(999),
                boxShadow: isSelected
                    ? [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 6, offset: const Offset(0, 2))]
                    : [],
              ),
              child: Text(
                '${type.name} ($count)',
                style: AppFont.size14.copyWith(
                  color: isSelected ? type.textColor : type.textColor.withOpacity(0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}