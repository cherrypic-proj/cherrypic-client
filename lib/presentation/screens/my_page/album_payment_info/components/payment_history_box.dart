import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/constants/font.dart';
import 'package:flutter/material.dart';

import '../info/payment_info_model.dart';

class PaymentHistoryBox extends StatelessWidget {
  final PaymentInfoModel model;

  const PaymentHistoryBox({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 날짜
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  model.date,
                  style: AppFont.size10.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.subGrey
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // 금액
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  model.amount,
                  style: AppFont.size16.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Divider(height: 1, thickness: 0.5, color:AppColor.subSlicer),
        const SizedBox(height: 20),
      ],
    );
  }
}