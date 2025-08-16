import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MyPageViewModel extends ChangeNotifier {
  /// 선택된 이미지 데이터
  Uint8List? _coverImage;

  /// View에서 데이터를 사용할 수 있도록 Getter 제공
  Uint8List? get coverImage => _coverImage;

  /// 갤러리에서 이미지를 선택하는 메소드
  Future<void> pickImage(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );

    /// 사용자가 이미지를 선택하고 확인을 눌렀을 경우
    if (assets != null && assets.isNotEmpty) {
      final AssetEntity selectedAsset = assets.first;
      final Uint8List? imageData = await selectedAsset.thumbnailDataWithSize(
        const ThumbnailSize(500, 500),
      );

      _coverImage = imageData;
      notifyListeners();
    }
  }
}