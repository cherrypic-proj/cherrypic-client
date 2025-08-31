import 'package:cherrypic/presentation/screens/store/photo_printing/service_step/select_address/select_address_model.dart';
import 'package:flutter/material.dart';

class SelectAddressViewModel extends ChangeNotifier {
  final List<SelectAddressModel> _addresses = [
    /// 예시
    SelectAddressModel(
      title: '집',
      label: '기본 배송지',
      receiver: '홍길동',
      phone: '010 - 1234 - 5678',
      address: '서울 동작구 상도로 369 [06978]',
      isFixed: false,
    ),
  ];

  List<SelectAddressModel> get addresses => _addresses;

  bool _isChecked = true;
  bool get isChecked => _isChecked;

  void setChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  void addAddress(SelectAddressModel model) {
    _addresses.add(model);
    notifyListeners();
  }

  void clearAddress() {
    _addresses.clear();
    notifyListeners();
  }
}