import 'package:flutter/material.dart';

import '../../../widgets/address_box_card.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sub_app_bar.dart';
import '../../../widgets/common_popup_dialog.dart';
import 'add_address_screen.dart';

/// 실물 사진 배송지 Model
class AddressItem {
  final String title;
  final String label;
  final String receiver;
  final String phone;
  final String address;
  final bool isFixed;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  AddressItem({
    required this.title,
    required this.label,
    required this.receiver,
    required this.phone,
    required this.address,
    required this.isFixed,
    this.onEdit,
    this.onDelete,
  });
}

/// 실물 사진 배송지 리스트
final List<AddressItem> sampleAddressItems = [
  AddressItem(
    title: '집',
    label: '기본 배송지',
    receiver: '홍길동',
    phone: '010 - 1234 - 5678',
    address: '서울 동작구 상도로 369 [06978]',
    isFixed: true,
  ),
  AddressItem(
    title: '회사',
    label: '기본 배송지',
    receiver: '홍길동',
    phone: '010 - 1234 - 5678',
    address: '서울특별시 종로구 성균관 25-2 [03063]',
    isFixed: true,
  ),
];

/// 실물 사진 배송지 관리 화면
class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  /// 선택된 배송지 인덱스 상태
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: '실물사진 배송지 관리'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 26),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sampleAddressItems.length + 1,
              itemBuilder: (context, index) {
                if (index < sampleAddressItems.length) {
                  return _buildAddressCard(sampleAddressItems[index], index);
                } else {
                  return _buildAddNewAddressButton();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 배송지 카드 위젯
  Widget _buildAddressCard(AddressItem item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
        },
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
          isSelected: index == selectedIndex,
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
                  /// 삭제 로직 구현 예정
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// '새 배송지 추가' 버튼
  Widget _buildAddNewAddressButton() {
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
