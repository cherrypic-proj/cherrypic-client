import 'package:cherrypic/presentation/screens/main/detail/Header/album_header_model.dart';
import 'package:flutter/foundation.dart';

class AlbumHeaderViewModel extends ChangeNotifier {
  final int albumId;
  late final AlbumHeaderData header;

  AlbumHeaderViewModel(this.albumId) {
    // TODO: 나중에 API 연동
    header = AlbumHeaderData(
      albumId: albumId,
      title: '일본 여행',
      coverUrl: 'assets/images/sample_photo.png',
      photoCount: 128,
      progress: 0.72,
      badgeText: '진행중',
    );
  }
}
