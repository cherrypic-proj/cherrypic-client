import 'package:flutter/material.dart';

import '../../../core/constants/color.dart';
import '../../../core/constants/font.dart';

class CommonPopupDialog extends StatelessWidget {
  final String title;
  final List<String> messages;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const CommonPopupDialog({
    super.key,
    required this.title,
    required this.messages,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftTap,
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 팝업창 Title
                  Text(
                    title,
                    style: AppFont.size18.copyWith(
                      color: AppColor.mainRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// 팝업창 메시지
                  ...messages.map(
                    (msg) => Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Text(
                        msg,
                        style: AppFont.size14.copyWith(
                          color: AppColor.subDarkGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(leftButtonText, onLeftTap),
                        const SizedBox(width: 40),
                        _buildButton(rightButtonText, onRightTap),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// 닫기 버튼
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColor.mainRed,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 팝업창 버튼 위젯
  Widget _buildButton(String text, VoidCallback onTap) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.mainRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            text,
            style: AppFont.size14.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
