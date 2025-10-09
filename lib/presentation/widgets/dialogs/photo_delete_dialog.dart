import 'package:cherrypic/presentation/widgets/dialogs/dialog_action_button.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';

class PhotoDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const PhotoDeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 340,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- 헤더 ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '사진 삭제',
                      style: AppFont.size18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColor.mainRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.delete_outline,
                      color: AppColor.mainRed,
                      size: 22,
                    ),
                  ],
                ),
                IconButton(
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- 안내 문구 ---
            Text(
              '해당 사진을 앨범에서 삭제하시겠습니까?',
              style: AppFont.size16.copyWith(
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // --- 버튼 ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DialogActionButton(
                  text: '취소',
                  isConfirm: false,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                DialogActionButton(
                  text: '삭제',
                  isConfirm: true,
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    onConfirm(); // 삭제 로직 실행
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
