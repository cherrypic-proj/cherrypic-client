import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sub_app_bar.dart';

class PaymentCompleteScreen extends StatelessWidget {
  const PaymentCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: 'CherryPic 정기 구독'),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 앨범 구독 시작 로고
                  Image.asset(
                    'assets/images/payment_complete.png',
                    width: 240.61,
                    height: 197.75,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 51.75),
                  /// 앨범 생성하기 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CustomButton(
                      onPressed: () {
                      },
                      variant: AppButtonVariant.filled,
                      type: CustomButtonType.createAlbum,
                      text: '앨범 생성하기',
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
