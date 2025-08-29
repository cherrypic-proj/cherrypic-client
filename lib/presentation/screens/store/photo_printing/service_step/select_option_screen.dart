import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/font.dart';
import '../../../../../core/router/route_path.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_sub_app_bar.dart';

class SelectOptionScreen extends StatefulWidget {
  const SelectOptionScreen({super.key});

  @override
  State<SelectOptionScreen> createState() => _SelectOptionScreenState();
}

class _SelectOptionScreenState extends State<SelectOptionScreen> {
  bool isChecked = true;
  bool _buttonPressed = false;

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
                      'assets/images/circle_three.png',
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '인화 옵션을 선택하세요.',
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
                  text: '다음',
                  onPressed: isChecked
                      ? () {
                    context.push(RoutePath.select_address);
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