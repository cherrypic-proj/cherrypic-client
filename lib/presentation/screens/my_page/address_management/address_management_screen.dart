import 'package:cherrypic/presentation/screens/my_page/address_management/address_list_view_model.dart';
import 'package:cherrypic/presentation/screens/my_page/address_management/address_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/address_box_card.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import '../../../widgets/common_popup_dialog.dart';
import 'add_address_screen.dart';

class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddressListViewModel(),
      child: Scaffold(
        appBar: const CustomSubAppBar(title: '실물사진 배송지 관리'),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 26),
            Expanded(
              child: Consumer<AddressListViewModel>(
                builder: (context, viewModel, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: viewModel.sampleAddressItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index < viewModel.sampleAddressItems.length) {
                        return _buildAddressCard(
                          context,
                          viewModel,
                          viewModel.sampleAddressItems[index],
                          index,
                        );
                      } else {
                        return _buildAddNewAddressButton(context);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 배송지 카드 위젯
  Widget _buildAddressCard(
      BuildContext context,
      AddressListViewModel viewModel,
      AddressItem item,
      int index,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextButton(
        onPressed: () => viewModel.selectAddress(index),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
        ),
        child: AddressBoxCard(
          title: item.title,
          label: item.label,
          receiver: item.receiver,
          phone: item.phone,
          address: item.address,
          isFixed: item.isFixed,
          isSelected: index == viewModel.selectedIndex,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddAddressScreen(isEdit: true),
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
                  viewModel.deleteAddress(index);
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// '새 배송지 추가' 버튼
  Widget _buildAddNewAddressButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 137),
      child: CustomButton(
        variant: AppButtonVariant.outlinedStatic,
        text: '새 배송지 추가',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAddressScreen(isEdit: false),
            ),
          );
        },
      ),
    );
  }
}