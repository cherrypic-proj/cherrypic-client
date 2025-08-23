import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/font.dart';
import '../../widgets/custom_sub_app_bar.dart';
import '../../widgets/menu_button.dart';
import 'components/payment_method_box.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MenuButton(iconType: EventStoreIconType.store, title: '스토어'),
          const CustomSubAppBar(title: ''),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 39.5),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '결제수단을 선택하세요',
                          style: AppFont.size18.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 38.8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaymentMethodBox(type: PaymentMethodType.kakao),
                          const SizedBox(width: 70),
                          PaymentMethodBox(type: PaymentMethodType.toss),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 38.8),
                Container(
                  height: 4,
                  color: AppColor.subSlicer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
