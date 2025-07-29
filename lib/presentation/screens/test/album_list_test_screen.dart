import 'package:flutter/material.dart';
import 'package:cherrypic/presentation/widgets/album/album_list_item.dart';

class AlbumListTestScreen extends StatelessWidget {
  const AlbumListTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final albums = List.generate(4, (i) => '임시 앨범명 ${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('앨범 리스트 테스트')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) => AlbumListItem(title: albums[i]),
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemCount: albums.length,
      ),
    );
  }
}
