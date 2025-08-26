import 'package:flutter/material.dart';
import 'event_album.dart';

class EventTabViewModel extends ChangeNotifier {
  List<EventAlbum> _albums = [];
  List<EventAlbum> get albums => _albums;

  EventTabViewModel() {
    _loadMockData();
  }

  void _loadMockData() {
    // API 연결 없이 UI 확인을 위한 Mock 데이터
    _albums = [
      EventAlbum(
        // '면 요리' 이미지 URL 교체
        imageUrl: 'https://picsum.photos/seed/noodle/200/200',
        title: '면 요리',
        photoCount: 4,
      ),
      EventAlbum(
        // '한식' 이미지 URL 교체
        imageUrl: 'https://picsum.photos/seed/koreanfood/200/200',
        title: '한식',
        photoCount: 13,
      ),
      EventAlbum(
        // '디저트' 이미지 URL 교체
        imageUrl: 'https://picsum.photos/seed/dessert/200/200',
        title: '디저트',
        photoCount: 28,
      ),
      EventAlbum(
        // '여름 휴가' 이미지 URL 교체
        imageUrl: 'https://picsum.photos/seed/vacation/200/200',
        title: '여름 휴가',
        photoCount: 52,
      ),
    ];
  }
}
