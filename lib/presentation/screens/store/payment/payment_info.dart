import 'package:cherrypic/presentation/screens/store/payment/payment_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import '../../../widgets/custom_box_card.dart';

class PaymentInfo extends StatelessWidget {
  final PaymentInfoViewModel viewModel;

  const PaymentInfo({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.5),
          child: Column(
            children: [
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
                    viewModel.formattedProductPrice,
                    style: AppFont.size14.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '구독 정보',
                          style: AppFont.size12.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.subGrey,
                          ),
                        ),
                        Text(
                          viewModel.formattedSubscriptionValue,
                          style: AppFont.size12.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.subGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '다음 결제 날짜',
                          style: AppFont.size12.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.subGrey,
                          ),
                        ),
                        Text(
                          viewModel.nextPaymentDate,
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
            ],
          ),
        ),
        const SizedBox(height: 21),
        SizedBox(
          width: double.infinity,
          height: 1,
          child: CustomPaint(
            painter: DottedLinePainter(AppColor.mainRed),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '총 결제 금액',
                style: AppFont.size16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                viewModel.formattedTotalPrice,
                style: AppFont.size16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
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