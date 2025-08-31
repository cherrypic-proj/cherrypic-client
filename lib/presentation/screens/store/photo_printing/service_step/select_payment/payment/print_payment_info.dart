import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/payment/print_payment_info_model.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/payment/print_payment_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';

import '../../../../../../widgets/custom_box_card.dart';

/// 인화 결제 정보
class PrintPaymentInfo extends StatelessWidget {
  final PrintPaymentInfoViewModel viewModel;
  final PrintPaymentInfoModel model;

  const PrintPaymentInfo({super.key, required this.viewModel, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.5),
          child: Column(
            children: [
              /// 상품 금액 Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '상품 금액',
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    viewModel.formatPrice(model.productPrice),
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              /// 구독 정보 Row
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '사진',
                          style: AppFont.size12.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.subGrey,
                          ),
                        ),
                        Text(
                          viewModel.formatPrice(model.photoPrice),
                          style: AppFont.size12.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.subGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    /// 다음 결제 날짜 Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '프레임',
                          style: AppFont.size12.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.subGrey,
                          ),
                        ),
                        Text(
                          viewModel.formatPrice(model.framePrice),
                          style: AppFont.size12.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.subGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '이벤트',
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    viewModel.discountPrice(model.eventPrice),
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColor.mainRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '프로모션',
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    viewModel.discountPrice(model.promotionPrice),
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColor.mainRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '베송비',
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    viewModel.formatPrice(model.deliveryPrice),
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 21),
        /// 점선
        SizedBox(
          width: double.infinity,
          height: 1,
          child: CustomPaint(
            painter: DottedLinePainter(AppColor.mainRed),
          ),
        ),
        const SizedBox(height: 10),
        /// 총 결제 금액 Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '총 결제 예상 금액',
              style: AppFont.size16.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text(
              viewModel.formatPrice(model.totalPrice),
              style: AppFont.size16.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        /// 점선
        SizedBox(
          width: double.infinity,
          height: 1,
          child: CustomPaint(
            painter: DottedLinePainter(AppColor.mainRed),
          ),
        ),
      ],
    );
  }
}