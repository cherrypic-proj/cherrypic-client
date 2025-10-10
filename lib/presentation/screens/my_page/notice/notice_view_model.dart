import 'package:flutter/material.dart';
import 'notice_model.dart';

class NoticeViewModel extends ChangeNotifier {

  final List<NoticeModel> _noticeItems = [
    const NoticeModel(date: '2025/08/04', title: '서비스 점검 안내'),
    const NoticeModel(date: '2025/07/20', title: '신규 기능 업데이트'),
    const NoticeModel(date: '2025/07/01', title: '이용약관 변경 안내'),
  ];

  List<NoticeModel> get noticeItems => _noticeItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NoticeModel? _selectedNotice;
  NoticeModel? get selectedNotice => _selectedNotice;

  Future<void> fetchNoticeItems() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _isLoading = false;
    notifyListeners();
  }

  void selectNotice(NoticeModel item) {
    _selectedNotice = item;
    notifyListeners();
  }
}