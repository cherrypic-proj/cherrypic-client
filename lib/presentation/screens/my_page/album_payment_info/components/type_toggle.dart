import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';
import '../album_payment_info_view_model.dart';

class TypeToggle extends StatelessWidget {
  final AlbumFilterType selected;
  final ValueChanged<AlbumFilterType> onChanged;  

  const TypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.mainRed, width: 2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pro 버튼
          GestureDetector(
            onTap: () => onChanged(AlbumFilterType.pro),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: selected == AlbumFilterType.pro
                    ? AppColor.mainLightRed
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                "Pro",
                style: AppFont.size14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected == AlbumFilterType.pro
                      ? AppColor.subDarkGrey
                      : AppColor.subLightGrey,
                ),
              ),
            ),
          ),

          // Premium 버튼
          GestureDetector(
            onTap: () => onChanged(AlbumFilterType.premium),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: selected == AlbumFilterType.premium
                    ? AppColor.mainRed
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                "Premium",
                style: AppFont.size14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected == AlbumFilterType.premium
                      ? Colors.white
                      : AppColor.subLightGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}