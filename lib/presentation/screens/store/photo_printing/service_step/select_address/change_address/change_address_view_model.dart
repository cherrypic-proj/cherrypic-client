import 'package:flutter/material.dart';

import '../../../../../my_page/address_management/address_model.dart';

class ChangeAddressViewModel extends ChangeNotifier {
  final List<AddressItem> _addressItems = [];

  int selectedIndex = 0;

  List<AddressItem> get addressItems => _addressItems;

  void loadAddresses() {
    _addressItems.clear();
    _addressItems.addAll([
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
        label: '회사 배송지',
        receiver: '홍길동',
        phone: '010 - 1234 - 5678',
        address: '서울 종로구 성균관로 25-2 [03063]',
        isFixed: true,
      ),
    ]);
    notifyListeners();
  }

  void selectAddress(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void deleteAddress(int index) {
    _addressItems.removeAt(index);
    if (selectedIndex >= _addressItems.length) {
      selectedIndex = _addressItems.isEmpty ? 0 : _addressItems.length - 1;
    }
    notifyListeners();
  }
}