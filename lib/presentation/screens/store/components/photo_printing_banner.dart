import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/font.dart';

/// 인화 서비스 배너
class PhotoPrintingBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const PhotoPrintingBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColor.lightCyan,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.asset(
              'assets/images/printing_banner_image.png',
              width: 77,
              height: 100,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '사진 인화 서비스',
                    style: AppFont.size18.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '서비스 홍보 멘트가 들어갈 자리입니다.',
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
