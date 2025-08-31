import 'package:flutter/material.dart';
import 'album_box.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({super.key});

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  final List<Map<String, dynamic>> albums = [
    {'id': 1, 'title': '가족여행', 'isLiked': false},
    {'id': 2, 'title': '맛집탐방', 'isLiked': true},
    {'id': 3, 'title': '반려동물', 'isLiked': false},
    {'id': 4, 'title': '운동기록', 'isLiked': true},
    {'id': 5, 'title': '데일리룩', 'isLiked': false},
  ];

  /// 선택 상태를 추적하는 리스트
  late List<bool> isSelectedList;

  @override
  void initState() {
    super.initState();
    isSelectedList = List.generate(albums.length, (_) => false); /// 모두 false로 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 35,
      alignment: WrapAlignment.start,
      children: List.generate(albums.length, (index) {
        final album = albums[index];
        return SizedBox(
          width: 150,
          /// 앨범
          child: AlbumBox(
            imageUrl: '',
            title: album['title'],
            isLiked: album['isLiked'],
            isSelected: isSelectedList[index],
            onTap: () {
              /// 앨범 1개만 선택되도록 설정
              setState(() {
                for (int i = 0; i < isSelectedList.length; i++) {
                  isSelectedList[i] = i == index;
                }
              });
            },
            /// 일단 남겨둠
            onLikeToggle: () {
              setState(() {
                album['isLiked'] = !album['isLiked'];
              });
            },
          ),
        );
      }),
    );
  }
}