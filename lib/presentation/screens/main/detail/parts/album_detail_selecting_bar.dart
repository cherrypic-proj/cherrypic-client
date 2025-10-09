import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

class SelectingBar extends StatelessWidget {
  final int count;
  //   다시 원래의 VoidCallback 형태로 변경합니다.
  final VoidCallback onMore;
  final VoidCallback onCancel;

  const SelectingBar({
    super.key,
    required this.count,
    required this.onMore,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 56,
      decoration: BoxDecoration(
        color: AppColor.mainRed,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count개 선택됨',
            style: AppFont.size18.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              //   Builder를 제거하고 다시 심플하게 onMore를 호출합니다.
              GestureDetector(
                onTap: onMore,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.transparent, // 터치 영역 확보
                  child: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onCancel,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.transparent, // 터치 영역 확보
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
