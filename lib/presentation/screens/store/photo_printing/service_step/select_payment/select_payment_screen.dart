import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/payment/print_payment_info.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/payment/print_payment_info_model.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_payment/payment/print_payment_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/color.dart';
import '../../../../../../core/constants/font.dart';
import '../../../../../../core/router/route_path.dart';
import '../../../../../widgets/custom_sub_app_bar.dart';
import '../../../components/fixed_button_footer.dart';
import '../../../components/payment_method_box.dart';

class SelectPaymentScreen extends StatefulWidget {

  const SelectPaymentScreen({
    super.key,
  });

  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  bool isChecked = true;

  PaymentMethodType _selectedMethod = PaymentMethodType.kakao;

  late final PrintPaymentInfoModel model;
  late final PrintPaymentInfoViewModel viewModel;

  @override
  void initState() {
    super.initState();

    model = PrintPaymentInfoModel(
      productPrice: 25000,
      photoPrice: 5000,
      framePrice: 20000,
      eventPrice: 2800,
      promotionPrice: 1500,
      deliveryPrice: 1500,
      totalPrice: 22000,
    );

    viewModel = PrintPaymentInfoViewModel(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '사진 인화 서비스'),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 46),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/circle_five.png',
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(width: 10),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '결제 수단을 선택하세요.',
                              style: AppFont.size18.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
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
                      PrintPaymentInfo(viewModel: viewModel, model: model,),

                    ],
                  ),
                ),

                const SizedBox(height: 150),
              ],
            ),
          ),

          FixedButtonFooter(
            text: '다음',
            isEnabled: isChecked,
            onPressed: isChecked
                ? () {
              context.go(RoutePath.home);
            }
                : null,
          ),
        ],
      ),
    );
  }
}