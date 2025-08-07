import 'package:flutter/material.dart';

import '../../../../core/constants/font.dart';
import '../../../widgets/album/album_badge_type.dart';

class SubscriptionBox extends StatelessWidget {
  final AlbumBadgeType badgeType;

  const SubscriptionBox({
    super.key,
    required this.badgeType,
  });

  @override
  Widget build(BuildContext context) {
    final label = _resolveLabel(badgeType);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      // margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: badgeType.borderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: badgeType.borderColor,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: badgeType.textColor,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '음식(양식, 중식, 한식, 일식) 음식 음식',
            style: AppFont.size14.copyWith(
              color: badgeType.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(
                '구독 시작일',
                style: AppFont.size12.copyWith(
                  color: badgeType.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 30,),
              Text(
                '2025/06/23',
                style: AppFont.size12.copyWith(
                  color: badgeType.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (badgeType != AlbumBadgeType.basic)
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      '다음 결제일',
                      style: AppFont.size12.copyWith(
                        color: badgeType.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Text(
                      '2025/06/23',
                      style: AppFont.size12.copyWith(
                        color: badgeType.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          Text(
            '월 0원',
            style: AppFont.size14.copyWith(
              color: badgeType.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _resolveLabel(AlbumBadgeType type) {
    switch (type) {
      case AlbumBadgeType.basic:
        return '무료 플랜 사용 중';
      case AlbumBadgeType.pro:
        return 'Chrerrypic Pro 구독 중';
      case AlbumBadgeType.premium:
        return 'Chrerrypic Premium 구독 중';
      default:
        return '';
    }
  }
}
