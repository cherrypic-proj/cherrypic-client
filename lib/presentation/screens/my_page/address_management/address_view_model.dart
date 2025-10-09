import 'package:flutter/material.dart';

class AddressViewModel extends ChangeNotifier {

  bool _isChecked = false;
  bool _buttonPressed = false;

  bool get isChecked => _isChecked;
  bool get buttonPressed => _buttonPressed;

  void toggleCheck() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  /// 버튼 눌림 상태 설정
  void setButtonPressed(bool pressed) {
    if (_isChecked) {
      _buttonPressed = pressed;
      notifyListeners();
    }
  }

  /// 버튼 터치 취소
  void cancelButtonPress() {
    if (_isChecked) {
      _buttonPressed = false;
      notifyListeners();
    }
  }

  /// 저장 버튼 클릭
  void onSavePressed() {
    if (_isChecked) {

    }
  }
}