import 'package:flutter/material.dart';
import 'dart:io';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 새 이벤트 생성 시트의 상태를 관리하는 ViewModel
class CreateEventViewModel extends ChangeNotifier {
  // 선택된 커버 이미지 파일
  File? _coverImage;
  File? get coverImage => _coverImage;

  // 이벤트 제목 입력을 위한 컨트롤러
  final TextEditingController titleController = TextEditingController();

  // 갤러리에서 가져온 전체 사진 목록 (Mock 데이터)
  final List<String> _allPhotos = List.generate(
    18,
    (index) => 'https://picsum.photos/seed/${index + 50}/400/400',
  );
  List<String> get allPhotos => _allPhotos;

  // 사용자가 선택한 사진의 인덱스 집합
  final Set<int> _selectedPhotoIndexes = {};
  Set<int> get selectedPhotoIndexes => _selectedPhotoIndexes;

  /// 선택된 사진 개수
  int get selectedPhotosCount => _selectedPhotoIndexes.length;

  /// 사진이 하나라도 선택되었는지 여부
  bool get isAnythingSelected => _selectedPhotoIndexes.isNotEmpty;

  /// 사진 선택/해제 토글
  void togglePhotoSelection(int index) {
    if (_selectedPhotoIndexes.contains(index)) {
      _selectedPhotoIndexes.remove(index);
    } else {
      _selectedPhotoIndexes.add(index);
    }
    // 상태 변경을 UI에 알림
    notifyListeners();
  }

  /// 커버 사진 선택 로직 (wechat_assets_picker 연동)
  Future<void> pickCoverImage(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );

    // 사용자가 이미지를 선택했을 경우
    if (assets != null && assets.isNotEmpty) {
      final AssetEntity selectedAsset = assets.first;
      // AssetEntity를 File 객체로 변환
      final File? imageFile = await selectedAsset.file;

      if (imageFile != null) {
        _coverImage = imageFile;
        notifyListeners();
      }
    }
  }

  /// 이벤트 생성 로직 (API 연동 위치)
  void createEvent() {
    // TODO: API 연동 로직 구현
    if (titleController.text.isEmpty) {
      print("이벤트 제목을 입력해주세요.");
      return;
    }
    if (_selectedPhotoIndexes.isEmpty) {
      print("사진을 하나 이상 선택해주세요.");
      return;
    }
    print("이벤트 생성 요청!");
    print(" - 제목: ${titleController.text}");
    print(" - 커버 이미지: ${_coverImage?.path ?? '없음'}");
    print(" - 선택된 사진: $selectedPhotosCount개");
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
