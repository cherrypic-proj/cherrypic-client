import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

import '../../screens/my_page/album_payment_info/album_payment_info_view_model.dart';

/// ✨ 토글 모드 (정보 / 관리)
enum ToggleMode { info, manage }

class TypeToggle extends StatelessWidget {
  final AlbumFilterType selected;
  final ValueChanged<AlbumFilterType> onChanged;
  final ToggleMode mode;

  const TypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
    this.mode = ToggleMode.info,
  });

  @override
  Widget build(BuildContext context) {
    // ✨ 모드별 텍스트 지정
    final type1Text = mode == ToggleMode.manage ? '이용중' : 'pro';
    final type2Text = mode == ToggleMode.manage ? '결제대기' : 'premium';

    // ✨ 모드별 색상 지정
    final isInfoMode = mode == ToggleMode.info;
    final activeColor1 =
    isInfoMode ? AppColor.mainLightRed : Colors.black; // pro or 이용중
    final activeColor2 =
    isInfoMode ? AppColor.mainRed : Colors.black; // premium or 결제대기
    final textColorActive =
    isInfoMode ? Colors.white : Colors.white; // 둘 다 white 유지
    final textColorInactive =
    isInfoMode ? AppColor.subLightGrey : Colors.black54;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isInfoMode ? AppColor.mainRed : Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onChanged(AlbumFilterType.pro),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: selected == AlbumFilterType.pro
                    ? activeColor1
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                type1Text,
                style: AppFont.size14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected == AlbumFilterType.pro
                      ? (isInfoMode ? AppColor.subDarkGrey : Colors.white)
                      : textColorInactive,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(AlbumFilterType.premium),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: selected == AlbumFilterType.premium
                    ? activeColor2
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                type2Text,
                style: AppFont.size14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected == AlbumFilterType.premium
                      ? textColorActive
                      : textColorInactive,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}