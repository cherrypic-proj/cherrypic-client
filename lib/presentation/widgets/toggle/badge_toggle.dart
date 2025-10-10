import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:cherrypic/presentation/widgets/album/album_badge_type.dart';

class BadgeToggle extends StatelessWidget {
  final AlbumBadgeType selected;
  final List<AlbumBadgeType> availableBadges;
  final ValueChanged<AlbumBadgeType> onChanged;

  const BadgeToggle({
    super.key,
    required this.selected,
    required this.availableBadges,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      if (availableBadges.contains(AlbumBadgeType.basic))
        {'label': 'Basic', 'type': AlbumBadgeType.basic},
      if (availableBadges.contains(AlbumBadgeType.pro))
        {'label': 'Pro', 'type': AlbumBadgeType.pro},
      if (availableBadges.contains(AlbumBadgeType.premium))
        {'label': 'Premium', 'type': AlbumBadgeType.premium},
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) {
        final type = item['type'] as AlbumBadgeType;
        final label = item['label'] as String;
        final isSelected = selected == type;

        return GestureDetector(
          onTap: () => onChanged(type),
          behavior: HitTestBehavior.translucent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppFont.size14.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.black : AppColor.subLightGrey,
                ),
              ),

              const SizedBox(height: 4),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.mainRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}