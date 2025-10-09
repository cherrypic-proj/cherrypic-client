import 'package:flutter/material.dart';
import 'album_subscription_history_model.dart';
import 'album_subscription_history_list.dart';

class AlbumSubscriptionHistoryViewModel extends ChangeNotifier {

  final List<AlbumSubscriptionHistoryModel> _items = [
    const AlbumSubscriptionHistoryModel(
      date: '2025.08.04',
      title: '서비스 점검 안내',
      iconType: NoticeIconType.subscribeIn,
    ),
    const AlbumSubscriptionHistoryModel(
      date: '2025.08.04',
      title: '정기 구독 해지 완료',
      iconType: NoticeIconType.subscribeOut,
    ),
    const AlbumSubscriptionHistoryModel(
      date: '2025.08.04',
      title: '신규 구독 시작',
      iconType: NoticeIconType.subscribeIn,
    ),
  ];

  List<AlbumSubscriptionHistoryModel> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AlbumSubscriptionHistoryModel? _selectedItem;
  AlbumSubscriptionHistoryModel? get selectedItem => _selectedItem;

  Future<void> fetchSubscriptionHistory() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500)); // Mock delay

    _isLoading = false;
    notifyListeners();
  }

  void selectItem(AlbumSubscriptionHistoryModel item) {
    _selectedItem = item;
    notifyListeners();
  }
}