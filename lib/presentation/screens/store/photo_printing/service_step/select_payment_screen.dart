import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/font.dart';
import '../../../../../core/router/route_path.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_sub_app_bar.dart';

class SelectPaymentScreen extends StatefulWidget {
  final int totalAmount;

  const SelectPaymentScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  bool isChecked = true;
  bool _buttonPressed = false;

  String get formattedAmount => NumberFormat('#,###').format(widget.totalAmount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '사진 인화 서비스'),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                const SizedBox(height: 53.5),

                /// 테스트용
                Container(
                  height: 2000,
                  color: Colors.red,
                ),

                const SizedBox(height: 150),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 126, left: 30, right: 30),
              child: GestureDetector(
                onTapDown: (_) {
                  if (isChecked) setState(() => _buttonPressed = true);
                },
                onTapUp: (_) {
                  if (isChecked) setState(() => _buttonPressed = false);
                },
                onTapCancel: () {
                  if (isChecked) setState(() => _buttonPressed = false);
                },
                child: CustomButton(
                  variant: isChecked
                      ? (_buttonPressed
                      ? AppButtonVariant.filled
                      : AppButtonVariant.outlinedStatic)
                      : AppButtonVariant.disabled,
                  text: '$formattedAmount원 결제하기',
                  onPressed: isChecked
                      ? () {
                    context.push(RoutePath.select_payment);
                  }
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}