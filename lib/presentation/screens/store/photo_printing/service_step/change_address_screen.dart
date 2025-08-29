import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/address_box_card.dart';
import '../../../../widgets/common_popup_dialog.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_sub_app_bar.dart';
import 'change_address_view_model.dart';
import '../../../my_page/address_management/add_address_screen.dart';

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen({super.key});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  bool isChecked = true;
  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangeAddressViewModel()..loadAddresses(),
      child: Scaffold(
        appBar: const CustomSubAppBar(title: '배송지 변경'),
        body: Consumer<ChangeAddressViewModel>(
          builder: (context, viewModel, _) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: List.generate(
                      viewModel.addressItems.length,
                          (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextButton(
                          onPressed: () => viewModel.selectAddress(index),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.zero,
                          ),
                          child: AddressBoxCard(
                            title: viewModel.addressItems[index].title,
                            label: viewModel.addressItems[index].label,
                            receiver: viewModel.addressItems[index].receiver,
                            phone: viewModel.addressItems[index].phone,
                            address: viewModel.addressItems[index].address,
                            isFixed: viewModel.addressItems[index].isFixed,
                            isSelected: viewModel.selectedIndex == index,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddAddressScreen(isEdit: true),
                                ),
                              );
                            },
                            onDelete: () {
                              showDialog(
                                context: context,
                                builder: (_) => CommonPopupDialog(
                                  title: '배송지 삭제',
                                  messages: const ['해당 배송지 정보를 삭제하시겠습니까?'],
                                  leftButtonText: '취소',
                                  rightButtonText: '삭제',
                                  onLeftTap: () => Navigator.of(context).pop(),
                                  onRightTap: () {
                                    Navigator.of(context).pop();
                                    viewModel.deleteAddress(index);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
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
                        text: '변경 완료',
                        onPressed: (){
                          context.pop();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}