import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/my_page/address_management/address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/font.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import '../../../widgets/text/horizontal_labeled_text_field.dart';


/// 배송지 추가/수정 화면
class AddAddressScreen extends StatelessWidget {
  final bool isEdit;

  const AddAddressScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddressViewModel(),
      child: Scaffold(
        appBar: const CustomSubAppBar(title: '실물사진 배송지 관리'),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 30.29),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(isEdit),
                  const SizedBox(height: 25),
                  const HorizontalLabeledTextField(
                    title: '배송지명',
                    hintText: '집',
                  ),
                  const SizedBox(height: 25),
                  const HorizontalLabeledTextField(
                    title: '수령인',
                    hintText: '홍길동',
                  ),
                  const SizedBox(height: 25),
                  const HorizontalLabeledTextField(
                    title: '연락처',
                    hintText: '010-1234-5678',
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Expanded(
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
                  const SizedBox(height: 25),
                  const HorizontalLabeledTextField(
                    title: '',
                    hintText: '서울 동작구 상도로 369',
                  ),
                  const SizedBox(height: 36.97),
                  Consumer<AddressViewModel>(
                    builder: (context, viewModel, child) {
                      return Row(
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
                            onTap: viewModel.toggleCheck,
                            child: Icon(
                              viewModel.isChecked
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              size: 26,
                              color: Colors.pink.shade100,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 53.45),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Consumer<AddressViewModel>(
                builder: (context, viewModel, child) {
                  return GestureDetector(
                    onTapDown: (_) => viewModel.setButtonPressed(true),
                    onTapUp: (_) => viewModel.setButtonPressed(false),
                    onTapCancel: viewModel.cancelButtonPress,
                    child: CustomButton(
                      variant: viewModel.isChecked
                          ? (viewModel.buttonPressed
                          ? AppButtonVariant.filled
                          : AppButtonVariant.outlined)
                          : AppButtonVariant.disabled,
                      text: '배송지 저장',
                      onPressed: viewModel.isChecked
                          ? viewModel.onSavePressed
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(bool isEdit) {
    return Text(
      isEdit ? '배송지 수정' : '새 배송지 추가',
      style: AppFont.size18.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}