import 'package:flutter/material.dart';

class AlbumAddViewModel extends ChangeNotifier {
  bool _isPermissionEnabled = false;
  bool get isPermissionEnabled => _isPermissionEnabled;

  void togglePermission(bool value) {
    _isPermissionEnabled = value;
    notifyListeners();
  }
}
