import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/album/album_group_section.dart';

class AlbumGroupTestScreen extends StatefulWidget {
  const AlbumGroupTestScreen({super.key});

  @override
  State<AlbumGroupTestScreen> createState() => _AlbumGroupTestScreenState();
}

class _AlbumGroupTestScreenState extends State<AlbumGroupTestScreen> {
  // 예시 이미지 URL들
  final List<String> imageUrls = [
    'https://picsum.photos/id/1/200',
    'https://picsum.photos/id/2/200',
    'https://picsum.photos/id/3/200',
    'https://picsum.photos/id/4/200',
    'https://picsum.photos/id/5/200',
  ];

  // 선택된 인덱스들
  final Set<int> selectedIndexes = {};

  bool get isAllSelected => selectedIndexes.length == imageUrls.length;

  void toggleAll() {
    setState(() {
      if (isAllSelected) {
        selectedIndexes.clear();
      } else {
        selectedIndexes.addAll(
          List.generate(imageUrls.length, (index) => index),
        );
      }
    });
  }

  void toggleOne(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Group 테스트')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: AlbumGroupSection(
            date: '2025.06.18',
            isAllSelected: isAllSelected,
            onToggleAll: toggleAll,
            imageUrls: imageUrls,
            selectedIndexes: selectedIndexes,
            onImageTap: toggleOne,
          ),
        ),
      ),
    );
  }
}
