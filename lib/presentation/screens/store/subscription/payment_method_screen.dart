import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/presentation/screens/store/subscription/payment/payment_info.dart';

import 'package:cherrypic/presentation/screens/store/subscription/payment/payment_info_model.dart';
import 'package:cherrypic/presentation/screens/store/subscription/payment/payment_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/font.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import '../components/payment_method_box.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethodType _selectedMethod = PaymentMethodType.kakao;

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
      appBar: const CustomSubAppBar(title: 'CherryPic 정기 구독'),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 39.5),
                      /// Title
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
                      /// 결제 수단 방식 Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaymentMethodBox(
                            type: PaymentMethodType.kakao,
                            isSelected: _selectedMethod == PaymentMethodType.kakao,
                            onTap: () {
                              setState(() {
                                _selectedMethod = PaymentMethodType.kakao;
                              });
                            },
                          ),
                          const SizedBox(width: 70),
                          PaymentMethodBox(
                            type: PaymentMethodType.toss,
                            isSelected: _selectedMethod == PaymentMethodType.toss,
                            onTap: () {
                              setState(() {
                                _selectedMethod = PaymentMethodType.toss;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 38.8),
                /// 구분선
                Container(height: 4, color: AppColor.subSlicer),
                const SizedBox(height: 46.28),
                /// 결제 정보
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
                      /// 결제 세부 정보
                      PaymentInfo(viewModel: viewModel),
                      const SizedBox(height: 92.45),
                      /// 결제하기 버튼
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