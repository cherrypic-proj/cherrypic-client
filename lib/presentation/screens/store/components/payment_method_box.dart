import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/font.dart';

enum PaymentMethodType { kakao, toss }

class PaymentMethodInfo {
  final String imagePath;
  final String label;

  const PaymentMethodInfo({required this.imagePath, required this.label});
}

PaymentMethodInfo getPaymentMethodInfo(PaymentMethodType type) {
  switch (type) {
    case PaymentMethodType.kakao:
      return const PaymentMethodInfo(
        imagePath: 'assets/images/kakao_pay.png',
        label: '카카오페이',
      );
    case PaymentMethodType.toss:
      return const PaymentMethodInfo(
        imagePath: 'assets/images/toss_pay.png',
        label: '토스페이',
      );
  }
}

class PaymentMethodBox extends StatelessWidget {
  final PaymentMethodType type;

  const PaymentMethodBox({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final info = getPaymentMethodInfo(type);

    return Column(
      children: [
        Container(
          padding: type == PaymentMethodType.kakao
              ? const EdgeInsets.symmetric(vertical: 15, horizontal: 15.5)
              : const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          height: 54,
          width: 101,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.subSlicer),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Image.asset(
            info.imagePath,
            width: 73,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          info.label,
          style: AppFont.size12.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}