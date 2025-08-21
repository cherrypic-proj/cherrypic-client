part of '../album_detail_screen.dart';

/// 하단 토글: 사진 선택
class _SelectingBar extends StatelessWidget {
  final int count;
  final VoidCallback onMore;
  const _SelectingBar({super.key, required this.count, required this.onMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.mainRed.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "#장 선택됨" 캡슐(흰색 1px 테두리)
          Container(
            height: 28,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Text(
              '$count 장 선택됨',
              style: AppFont.size18.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 더보기 버튼
          GestureDetector(
            onTap: onMore,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColor.mainLightRed,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.more_horiz, size: 18, color: AppColor.mainRed),
            ),
          ),
        ],
      ),
    );
  }
}
