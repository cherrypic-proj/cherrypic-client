import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'image_list_model.dart';

class ImageListViewModel extends ChangeNotifier {
  final int albumId;
  ImageListViewModel({required this.albumId}) {
    fetchPhotos();
  }

  List<ImageListModel> photoGroups = [];

  final Set<String> _selectedImageUrls = {};

  bool isSelected(String url) => _selectedImageUrls.contains(url);

  Set<String> get selectedImages => _selectedImageUrls;

  void toggleImageSelection(String url) {
    if (_selectedImageUrls.contains(url)) {
      _selectedImageUrls.remove(url);
    } else {
      _selectedImageUrls.add(url);
    }
    notifyListeners();
  }

  void fetchPhotos() {
    /// 임시 데이터
    if (albumId == 1) {
      photoGroups = [
        ImageListModel(
          date: '2025.06.20',
          imageUrls: [
            'https://picsum.photos/id/1011/600/600',
            'https://picsum.photos/id/1015/600/600',
            'https://picsum.photos/id/1025/600/600',
            'https://picsum.photos/id/1035/600/600',
            'https://picsum.photos/id/1024/600/600',
            'https://picsum.photos/id/1043/600/600',
          ],
        ),
        ImageListModel(
          date: '2025.06.18',
          imageUrls: [
            'https://picsum.photos/id/1062/600/600',
            'https://picsum.photos/id/1050/600/600',
          ],
        ),
      ];
    } else {
      /// 다른 albumId에 대한 처리
    }

    notifyListeners();
  }
}