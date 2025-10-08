import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

/// 각 메뉴 아이템의 데이터를 정의하는 모델 클래스
class ActionMenuItem {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  ActionMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

/// 커스텀 액션 메뉴 위젯
class CustomActionMenu extends StatelessWidget {
  final List<ActionMenuItem> items;
  final double itemWidth;
  final double itemHeight;

  const CustomActionMenu({
    super.key,
    required this.items,
    this.itemWidth = 130.0,
    this.itemHeight = 35.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: itemWidth,
      // ClipRRect를 사용하여 자식 위젯(메뉴 아이템)들이 부모의 둥근 모서리를 벗어나지 않도록 합니다.
      decoration: BoxDecoration(
        color: AppColor.mainLightRed,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          // Column의 크기를 자식들의 크기에 맞게 조절합니다.
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isLastItem = index == items.length - 1;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 각 메뉴 아이템
                _buildMenuItem(context, item),
                // 마지막 아이템이 아니라면 구분선을 추가합니다.
                if (!isLastItem)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColor.mainRed.withOpacity(0.15),
                    indent: 8,
                    endIndent: 8,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// 개별 메뉴 아이템을 생성하는 위젯
  Widget _buildMenuItem(BuildContext context, ActionMenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Container(
          width: itemWidth,
          height: itemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 타이틀
              Text(
                item.title,
                style: AppFont.size16.copyWith(
                  color: AppColor.subDarkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // 아이콘
              SizedBox(width: 14, height: 16, child: Center(child: item.icon)),
            ],
          ),
        ),
      ),
    );
  }
}
