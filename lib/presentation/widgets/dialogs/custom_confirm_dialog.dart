import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;

  const CustomConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmButtonText = '확인',
    this.cancelButtonText = '취소',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    String memberName = '';
    String remainingContent = content;
    final nameMatch = RegExp(r'^(.*?)\s님을').firstMatch(content);
    if (nameMatch != null) {
      memberName = nameMatch.group(1)!;
      remainingContent = content.substring(nameMatch.end);
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 타이틀 및 닫기 버튼 ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppFont.size18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColor.mainRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/door_open.png',
                      width: 28,
                      height: 28,
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
            const SizedBox(height: 30),

            Text.rich(
              TextSpan(
                style: AppFont.size16.copyWith(
                  height: 1.5,
                  color: Colors.black,
                ),
                children: [
                  if (memberName.isNotEmpty)
                    TextSpan(
                      text: memberName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  TextSpan(text: remainingContent),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // --- 버튼 ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  context: context,
                  text: cancelButtonText,
                  isConfirm: false,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                _buildButton(
                  context: context,
                  text: confirmButtonText,
                  isConfirm: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required bool isConfirm,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 120,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isConfirm ? AppColor.mainRed : Colors.white,
          foregroundColor: isConfirm ? Colors.white : AppColor.mainRed,
          side: isConfirm
              ? BorderSide.none
              : const BorderSide(color: AppColor.mainRed, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppFont.size14.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
