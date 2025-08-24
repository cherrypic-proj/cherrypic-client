import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_sub_app_bar.dart';
import '../../widgets/menu_button.dart';

class PaymentCompleteScreen extends StatelessWidget {
  const PaymentCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MenuButton(iconType: EventStoreIconType.store, title: '스토어'),
          const CustomSubAppBar(title: ''),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/payment_complete.png',
                    width: 240.61,
                    height: 197.75,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 51.75),
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
