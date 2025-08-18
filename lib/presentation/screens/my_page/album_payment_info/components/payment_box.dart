import 'package:flutter/material.dart';

import '../../../../../core/constants/font.dart';
import '../../../../widgets/album/album_badge_type.dart';
import 'album_payment_info_model.dart';

class PaymentBox extends StatelessWidget {
  final AlbumPaymentInfoModel model;

  const PaymentBox({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final badgeType = model.badgeType;

    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 14),
      decoration: BoxDecoration(
        color: badgeType.borderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: Text(
                  badgeType.label,
                  style: AppFont.size14.copyWith(
                    color: badgeType.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              /// 월 결제 금액
              Text(
                model.price,
                style: AppFont.size14.copyWith(
                  color: badgeType.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                /// 구독한 앨범명
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    model.title,
                    style: AppFont.size14.copyWith(
                      color: badgeType.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 9),

                /// 앨범 생성일
                _buildInfoRow('앨범 생성일', model.createDate, badgeType),

                const SizedBox(height: 4),

                /// 구독 시작일 + 다음 결제일
                if (badgeType != AlbumBadgeType.basic && model.nextDate != null) ...[
                  _buildInfoRow('구독 시작일', model.startDate!, badgeType),
                  const SizedBox(height: 4),
                  _buildInfoRow('다음 결제일', model.nextDate!, badgeType),
                  const SizedBox(height: 4),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AlbumBadgeType badgeType) {
    return Row(
      children: [
        Text(
          label,
          style: AppFont.size12.copyWith(
            color: badgeType.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 30),
        Text(
          value,
          style: AppFont.size12.copyWith(
            color: badgeType.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}