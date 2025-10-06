import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album_event/dto/request/event_add_images_request_dto.dart';
import 'package:cherrypic/data/album_event/dto/response/event_create_response_dto.dart';
import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:cherrypic/data/album_event/services/event_cover_image_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 새 이벤트 생성 시트의 상태를 관리하는 ViewModel
class CreateEventViewModel extends ChangeNotifier {
  final int albumId;
  final AlbumRepository _albumRepository;
  final EventRepository _eventRepository;
  final EventCoverImageService _coverImageService;

  CreateEventViewModel({
    required this.albumId,
    AlbumRepository? albumRepository,
    EventRepository? eventRepository,
    EventCoverImageService? coverImageService,
  }) : _albumRepository = albumRepository ?? AlbumRepository(),
       _eventRepository = eventRepository ?? EventRepository(),
       _coverImageService = coverImageService ?? EventCoverImageService() {
    _loadAlbumImages();
  }

  // 선택된 커버 이미지 파일
  File? _coverImage;
  File? get coverImage => _coverImage;

  // 업로드된 커버 이미지 URL
  String? _coverImageUrl;
  String? get coverImageUrl => _coverImageUrl;

  // 이벤트 제목 입력을 위한 컨트롤러
  final TextEditingController titleController = TextEditingController();

  // 앨범의 전체 이미지 목록 (API로 받아온 실제 데이터)
  List<AlbumImage> _allPhotos = [];
  List<AlbumImage> get allPhotos => _allPhotos;

  // 사용자가 선택한 이미지 ID 집합
  final Set<int> _selectedImageIds = {};
  Set<int> get selectedImageIds => _selectedImageIds;

  // 로딩 상태
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;

  /// 선택된 이미지 개수
  int get selectedPhotosCount => _selectedImageIds.length;

  /// 이미지가 하나라도 선택되었는지 여부
  bool get isAnythingSelected => _selectedImageIds.isNotEmpty;

  /// 앨범의 이미지 목록 로드
  Future<void> _loadAlbumImages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _albumRepository.getAlbumImages(
        albumId,
        size: 100, // 충분히 많이 가져오기
        parameter: 'UPLOAD',
        direction: 'DESC', // 최신순
      );

      _allPhotos = response.content
          .map(
            (img) => AlbumImage(imageId: img.imageId, imageUrl: img.imageUrl),
          )
          .toList();
    } catch (e) {
      _error = e.toString();
      debugPrint('이미지 목록 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 이미지 선택/해제 토글 (imageId 기반)
  void togglePhotoSelection(int imageId) {
    if (_selectedImageIds.contains(imageId)) {
      _selectedImageIds.remove(imageId);
    } else {
      _selectedImageIds.add(imageId);
    }
    notifyListeners();
  }

  /// 커버 사진 선택 및 업로드
  Future<void> pickCoverImage(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );

    if (assets == null || assets.isEmpty) return;

    final AssetEntity selectedAsset = assets.first;
    final File? imageFile = await selectedAsset.file;

    if (imageFile != null) {
      _coverImage = imageFile;
      notifyListeners();

      // 즉시 S3에 업로드
      await _uploadCoverImage(imageFile);
    }
  }

  /// 커버 이미지를 S3에 업로드하고 URL 저장
  Future<void> _uploadCoverImage(File imageFile) async {
    _isUploading = true;
    _error = null;
    notifyListeners();

    try {
      final imageBytes = await imageFile.readAsBytes();
      final uploadedUrl = await _coverImageService.uploadEventCoverImage(
        imageBytes,
      );

      _coverImageUrl = uploadedUrl;
      debugPrint('커버 이미지 업로드 성공: $_coverImageUrl');
    } catch (e) {
      _error = '커버 이미지 업로드 실패: $e';
      debugPrint(_error);
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// 이벤트 생성 로직
  Future<bool> createEvent() async {
    // 유효성 검사
    if (titleController.text.isEmpty) {
      _error = '이벤트 제목을 입력해주세요.';
      notifyListeners();
      return false;
    }

    if (_coverImageUrl == null) {
      _error = '커버 이미지를 업로드해주세요.';
      notifyListeners();
      return false;
    }

    if (_selectedImageIds.isEmpty) {
      _error = '이미지를 하나 이상 선택해주세요.';
      notifyListeners();
      return false;
    }

    _isUploading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. 이벤트 생성
      final createRequest = EventCreateRequestDto(
        albumId: albumId,
        title: titleController.text,
        coverUrl: _coverImageUrl!,
      );

      final createResponse = await _eventRepository.createEvent(createRequest);
      final eventId = createResponse.eventId;

      debugPrint('이벤트 생성 성공: eventId=$eventId');

      // 2. 이벤트에 이미지 추가
      final addImagesRequest = EventAddImagesRequestDto(
        imageIds: _selectedImageIds.toList(),
      );

      await _eventRepository.addImagesToEvent(eventId, addImagesRequest);

      debugPrint('이미지 추가 성공: ${_selectedImageIds.length}개');

      _isUploading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = '이벤트 생성 실패: $e';
      debugPrint(_error);
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}

/// 앨범 이미지 모델
class AlbumImage {
  final int imageId;
  final String imageUrl;

  AlbumImage({required this.imageId, required this.imageUrl});
}
