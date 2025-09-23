import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AlbumCoverViewModel extends ChangeNotifier {
  Uint8List? _coverImage;
  String? _coverImageUrl;
  String _albumName = ''; // 실제 데이터는 항상 ''로 초기화
  bool _isDefaultSelected = true;
  static const int maxAlbumNameLength = 20;

  Uint8List? get coverImage => _coverImage;
  String? get coverImageUrl => _coverImageUrl;
  String get albumName => _albumName; // TextField 컨트롤러가 사용할 실제 데이터
  bool get isDefaultSelected => _isDefaultSelected;

  // ✨ 1. UI 표시용 getter를 새로 추가했습니다.
  // _albumName이 비어있으면 안내 문구를, 아니면 입력된 값을 반환합니다.
  String get albumDisplayName =>
      _albumName.isEmpty ? '앨범 이름이 표시됩니다' : _albumName;

  void selectImageType(bool isDefault) {
    if (_isDefaultSelected == isDefault) return;
    _isDefaultSelected = isDefault;
    if (isDefault) {
      _coverImage = null;
    }
    notifyListeners();
  }

  void setCoverImageUrl(String url) {
    _coverImageUrl = url;
    _coverImage = null;
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );

    if (assets != null && assets.isNotEmpty) {
      final AssetEntity selectedAsset = assets.first;
      final Uint8List? imageData = await selectedAsset.thumbnailDataWithSize(
        const ThumbnailSize(500, 500),
      );
      _coverImage = imageData;
      notifyListeners();
    }
  }

  /// 텍스트 필드의 입력에 따라 앨범 이름을 실시간으로 업데이트하는 메소드
  void updateAlbumName(String newName) {
    if (newName.length > maxAlbumNameLength) return;

    // ✨ 2. 복잡한 로직을 제거하고, 입력된 값을 그대로 _albumName에 저장합니다.
    _albumName = newName;
    notifyListeners();
  }
}
