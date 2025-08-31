import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/font.dart';

/// 결제수단 선택 박스
class PaymentMethodBox extends StatelessWidget {
  final PaymentMethodType type;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodBox({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 전체 터치 시 실행
      child: Column(
        children: [
          Container(
            padding: type.padding,
            height: 54,
            width: 101,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColor.mainRed : AppColor.subSlicer,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.asset(
              type.imagePath,
              width: 73,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            type.label,
            style: AppFont.size12.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// 결제수단 타입
enum PaymentMethodType { kakao, toss }

extension PaymentMethodExtension on PaymentMethodType {
  String get imagePath {
    switch (this) {
      case PaymentMethodType.kakao:
        return 'assets/images/kakao_pay.png';
      case PaymentMethodType.toss:
        return 'assets/images/toss_pay.png';
    }
  }

  String get label {
    switch (this) {
      case PaymentMethodType.kakao:
        return '카카오페이';
      case PaymentMethodType.toss:
        return '토스페이';
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case PaymentMethodType.kakao:
        return const EdgeInsets.symmetric(vertical: 15, horizontal: 15.5);
      case PaymentMethodType.toss:
        return const EdgeInsets.symmetric(vertical: 12, horizontal: 14);
    }
  }
}