import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/screens/store/payment/payment_info_model.dart';
import 'package:cherrypic/presentation/screens/store/payment/payment_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/font.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_sub_app_bar.dart';
import '../../widgets/menu_button.dart';
import 'payment/payment_info.dart';
import 'components/payment_method_box.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = PaymentInfoModel(
      productPrice: 3900,
      subscriptionValue: 'CherryPic Pro',
      nextPaymentDate: '2025년 9월 20일',
      totalPrice: 3900,
    );
    final viewModel = PaymentInfoViewModel(model);

    return Scaffold(
      body: Column(
        children: [
          MenuButton(iconType: EventStoreIconType.store, title: '스토어'),
          const CustomSubAppBar(title: ''),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 38.8),
                Container(height: 4, color: AppColor.subSlicer),
                const SizedBox(height: 46.28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '결제 정보',
                          style: AppFont.size16.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      PaymentInfo(viewModel: viewModel),
                      const SizedBox(height: 92.45),
                      CustomButton(
                        onPressed: () {
                          context.push(RoutePath.payment_complete);
                        },
                        variant: AppButtonVariant.filled,
                        type: CustomButtonType.createAlbum,
                        text: '${viewModel.formattedTotalPrice} 결제하기',
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}