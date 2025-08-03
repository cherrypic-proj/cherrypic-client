import 'package:flutter/material.dart';

import '../../../core/constants/color.dart';
import '../../../core/constants/font.dart';

class LogoutPopupScreen extends StatelessWidget {
  const LogoutPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '로그아웃',
                  style: AppFont.size18.copyWith(
                    color: AppColor.mainRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: AppColor.mainRed, size: 20,),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '지금 로그아웃하면 앨범을 더 이상 확인할 수 없어요.',
              style: AppFont.size14.copyWith(
                color: AppColor.subDarkGrey,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '계속 로그아웃하시겠어요?',
              style: AppFont.size14.copyWith(
                color: AppColor.subDarkGrey,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                      '취소',
                    style: AppFont.size14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    debugPrint('로그아웃');
                  },
                  child: Text(
                      '로그아웃',
                    style: AppFont.size14.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
