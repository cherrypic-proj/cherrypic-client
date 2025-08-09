import 'package:flutter/material.dart';

import '../../../../core/constants/font.dart';
import '../../../widgets/album/album_badge_type.dart';

class SubscriptionBox extends StatelessWidget {
  final AlbumBadgeType badgeType;
  final String title;
  final String startDate;
  final String? nextDate;
  final String price;

  const SubscriptionBox({
    super.key,
    required this.badgeType,
    required this.title,
    required this.startDate,
    this.nextDate,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final label = _resolveLabel(badgeType);

    /// 구독 및 결제 정보 박스
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: badgeType.borderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 구독 정보 상자
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: badgeType.borderColor,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(label, style: TextStyle(color: badgeType.textColor)),
          ),
          const SizedBox(height: 9),

          /// 구독한 앨범명
          Text(
            title,
            style: AppFont.size14.copyWith(
              color: badgeType.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),

          /// 구독 시작일
          _buildInfoRow(
            '구독 시작일',
            startDate,
            AppFont.size12.copyWith(
              color: badgeType.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),

          /// 다음 결제일
          if (badgeType != AlbumBadgeType.basic && nextDate != null) ...[
            _buildInfoRow(
              '다음 결제일',
              nextDate!,
              AppFont.size12.copyWith(
                color: badgeType.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
          ],

          /// 월 결제 금액
          Text(
            price,
            style: AppFont.size14.copyWith(
              color: badgeType.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 구독 시작일 + 다음 결제일
  Widget _buildInfoRow(String label, String value, TextStyle style) {
    return Row(
      children: [
        Text(label, style: style),
        const SizedBox(width: 30),
        Text(value, style: style),
      ],
    );
  }

  /// 구독 Type
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
