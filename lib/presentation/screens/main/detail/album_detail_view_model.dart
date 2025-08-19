import 'package:flutter/foundation.dart';
import 'album_detail_models.dart';

class AlbumDetailViewModel extends ChangeNotifier {
  final int albumId;
  AlbumDetailViewModel(this.albumId) {
    _loadMock(); // API 전까지 예시 데이터
  }

  final List<AlbumDayGroup> _groups = [];
  List<AlbumDayGroup> get groups => List.unmodifiable(_groups);

  void _loadMock() {
    _groups
      ..clear()
      ..addAll([
        AlbumDayGroup(
          date: '2025.06.20',
          imageUrls: [
            'https://picsum.photos/id/1015/600/600',
            'https://picsum.photos/id/1035/600/600',
            'https://picsum.photos/id/1059/600/600',
            'https://picsum.photos/id/1080/600/600',
            'https://picsum.photos/id/1084/600/600',
            'https://picsum.photos/id/1081/600/600',
          ],
        ),
        AlbumDayGroup(
          date: '2025.06.18',
          imageUrls: [
            'https://picsum.photos/id/1062/600/600',
            'https://picsum.photos/id/1074/600/600',
            'https://picsum.photos/id/1082/600/600',
          ],
        ),
      ]);
    notifyListeners();
  }

  void toggleAll(int groupIndex) {
    final g = _groups[groupIndex];
    if (g.isAllSelected) {
      g.selectedIndexes.clear();
    } else {
      g.selectedIndexes
        ..clear()
        ..addAll(List.generate(g.imageUrls.length, (i) => i));
    }
    notifyListeners();
  }

  void toggleImage(int groupIndex, int imageIndex) {
    final g = _groups[groupIndex];
    if (g.selectedIndexes.contains(imageIndex)) {
      g.selectedIndexes.remove(imageIndex);
    } else {
      g.selectedIndexes.add(imageIndex);
    }
    notifyListeners();
  }
}
