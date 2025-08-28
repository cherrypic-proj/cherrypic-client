import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AlbumCoverViewModel extends ChangeNotifier {
  Uint8List? _coverImage; // 선택된 이미지 데이터 (메모리에 보관)
  String? _coverImageUrl;
  String _albumName = '앨범 이름이 표시됩니다'; // 앨범 이름 초기값
  bool _isDefaultSelected = true; // '기존 이미지' vs '사진 업로드' 버튼 상태
  static const int maxAlbumNameLength = 20;

  // View에서 데이터를 사용할 수 있도록 Getter 제공
  Uint8List? get coverImage => _coverImage;
  String? get coverImageUrl => _coverImageUrl;
  String get albumName => _albumName;
  bool get isDefaultSelected => _isDefaultSelected;

  /// '기존 이미지' 또는 '사진 업로드' 버튼을 선택하는 메소드
  void selectImageType(bool isDefault) {
    if (_isDefaultSelected == isDefault) return;

    _isDefaultSelected = isDefault;
    if (isDefault) {
      _coverImage = null;
    }
    notifyListeners();
  }

  // 네트워크 이미지 URL을 설정하는 메소드 추가
  void setCoverImageUrl(String url) {
    _coverImageUrl = url;
    _coverImage = null; // 새로 업로드한 이미지가 있다면 초기화
    notifyListeners();
  }

  /// 갤러리에서 이미지를 선택하는 메소드
  Future<void> pickImage(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );

    // 사용자가 이미지를 선택하고 확인을 눌렀을 경우
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
    // 20자를 초과하는 입력은 상태를 업데이트하지 않습니다.
    if (newName.length > maxAlbumNameLength) return;

    _albumName = newName.isEmpty ? '앨범 이름이 표시됩니다' : newName;
    notifyListeners();
  }
}
