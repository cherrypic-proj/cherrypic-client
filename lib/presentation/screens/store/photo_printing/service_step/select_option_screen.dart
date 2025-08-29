import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/print_option_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/font.dart';
import '../../../../../core/router/route_path.dart';
import '../../../../widgets/custom_box_card.dart';
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

  late PrintOptionViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = PrintOptionViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 36.5),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                      text: '사진 사이즈',
                      style: AppFont.size18.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: AppColor.mainRed),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                ...List.generate(viewModel.options.length, (index) {
                  final model = viewModel.options[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CustomBoxCard(
                      selected: viewModel.isSelected(index),
                      // borderColor: AppColor.subGrey,
                      model: model,
                        onTap: () {
                          setState(() {
                            viewModel.selectOption(index);
                          });
                        }
                    ),
                  );
                }),

                const SizedBox(height: 59.08),

                /// 구분선
                Container(height: 2, color: AppColor.subSlicer),

                const SizedBox(height: 33.75),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '프레임 (선택)',
                    style: AppFont.size18.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20.75),

                AspectRatio(
                  aspectRatio: 330 / 162,
                  child: Image.asset(
                    'assets/images/frame_size.png',
                    fit: BoxFit.contain,
                  ),
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