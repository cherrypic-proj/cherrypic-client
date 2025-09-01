import 'package:cherrypic/core/constants/color.dart';
import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_address/select_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/font.dart';
import '../../../../../../core/router/route_path.dart';
import '../../../../../widgets/address_box_card.dart';
import '../../../../../widgets/custom_sub_app_bar.dart';
import '../../../components/fixed_button_footer.dart';

class SelectAddressScreen extends StatelessWidget {
  const SelectAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectAddressViewModel(),
      builder: (context, child) {
        final viewModel = context.watch<SelectAddressViewModel>();

        return Scaffold(
          appBar: const CustomSubAppBar(title: '사진 인화 서비스'),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 46),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/circle_four.png',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '배송지를 선택하세요.',
                          style: AppFont.size18.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 53.5),

                    /// 배송지 정보
                    ...viewModel.addresses.map((address) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AddressBoxCard(
                        isFixed: address.isFixed,
                        title: address.title,
                        label: address.label,
                        receiver: address.receiver,
                        phone: address.phone,
                        address: address.address,
                        isSelected: false,
                      ),
                    )),

                    /// 배송지 변경 버튼
                    GestureDetector(
                      onTap: () {
                        context.push(RoutePath.change_address);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '배송지 변경',
                            style: AppFont.size14.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.highlightBlue,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.chevron_right_sharp,
                            size: 16,
                            color: AppColor.highlightBlue,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),

              /// 고정 버튼
              FixedButtonFooter(
                text: '다음',
                isEnabled: viewModel.isChecked,
                onPressed: viewModel.isChecked
                    ? () {
                  context.push(
                    RoutePath.select_payment,
                    extra: 22200,
                  );
                }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}