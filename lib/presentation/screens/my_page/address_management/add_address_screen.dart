import 'package:cherrypic/core/constants/color.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/font.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_tab_bar.dart';
import '../../../widgets/text/horizontal_labeled_text_field.dart';

class AddAddressScreen extends StatefulWidget {
  final bool isEdit;

  const AddAddressScreen({super.key, this.isEdit = false});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  bool isChecked = false;
  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEdit;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomTabBar(title: '실물사진 배송지 관리'),
          const SizedBox(height: 30.29),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? '배송지 수정' : '새 배송지 추가',
                  style: AppFont.size18.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 25,),
                HorizontalLabeledTextField(
                  title: '배송지명',
                  hintText: '집',
                ),
                const SizedBox(height: 25,),
                HorizontalLabeledTextField(
                  title: '수령인',
                  hintText: '홍길동',
                ),
                const SizedBox(height: 25,),
                HorizontalLabeledTextField(
                  title: '연락처',
                  hintText: '010-1234-5678',
                ),
                const SizedBox(height: 25,),
                Row(
                  children: [
                    Expanded(
                      child: HorizontalLabeledTextField(
                        title: '주소',
                        hintText: '06978',
                      ),
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      shape: AppButtonShape.capsule,
                      variant: AppButtonVariant.address,
                      type: CustomButtonType.addAddress,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 25,),
                HorizontalLabeledTextField(
                  title: '',
                  hintText: '서울 동작구 상도로 369',
                ),
                const SizedBox(height: 36.97,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '기본 배송지로 설정',
                      style: AppFont.size16.copyWith(
                        color: AppColor.subDarkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 11),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Icon(
                        isChecked ? Icons.check_circle : Icons.check_circle_outline,
                        size: 26,
                        color: Colors.pink.shade100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 53.45),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: GestureDetector(
                onTapDown: (_) {
                  if (isChecked) {
                    setState(() => _buttonPressed = true);
                  }
                },
                onTapUp: (_) {
                  if (isChecked) {
                    setState(() => _buttonPressed = false);
                  }
                },
                onTapCancel: () {
                  if (isChecked) {
                    setState(() => _buttonPressed = false);
                  }
                },
                child: CustomButton(
                  variant: isChecked
                      ? (_buttonPressed ? AppButtonVariant.filled : AppButtonVariant.outlined)
                      : AppButtonVariant.disabled,
                  text: '배송지 저장',
                  onPressed: isChecked ? () {} : null,
                ),
              )
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
