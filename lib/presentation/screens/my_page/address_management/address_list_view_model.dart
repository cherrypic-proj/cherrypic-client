import 'package:flutter/material.dart';

import 'address_model.dart';

class AddressListViewModel extends ChangeNotifier {
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

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  /// 배송지 선택
  void selectAddress(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// 배송지 삭제
  void deleteAddress(int index) {
    notifyListeners();
  }
}