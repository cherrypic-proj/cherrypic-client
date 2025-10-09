import 'dart:io';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album_event/dto/request/event_add_images_request_dto.dart';
import 'package:cherrypic/data/album_event/dto/response/event_create_response_dto.dart';
import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:cherrypic/data/album_event/services/event_cover_image_service.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// --- 데이터 모델 정의 ---

/// 앨범 이미지 모델
class AlbumImage {
  final int imageId;
  final String imageUrl;
  AlbumImage({required this.imageId, required this.imageUrl});
}

/// 날짜별 이미지 그룹 모델 (ViewModel 내부용)
class AlbumDayGroup {
  final String date;
  final List<AlbumImage> images;
  final Set<int> selectedIndexes;
  bool isAllSelected;

  AlbumDayGroup({
    required this.date,
    required this.images,
    Set<int>? selectedIndexes,
    this.isAllSelected = false,
  }) : selectedIndexes = selectedIndexes ?? <int>{};
}

// --- ViewModel ---

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
    loadImages();
  }

  // --- 상태 변수 ---

  // UI 상태
  List<AlbumDayGroup> groups = [];
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;

  // 커버 이미지 관련
  File? _coverImage;
  String? _coverImageUrl;

  // 이벤트 제목
  final TextEditingController titleController = TextEditingController();

  // 정렬 관련
  String _sortParameter = 'UPLOAD'; // 촬영일 'GENERATE', 업로드 'UPLOAD'
  String _sortDirection = 'DESC';

  // --- Getters ---

  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;
  File? get coverImage => _coverImage;
  String? get coverImageUrl => _coverImageUrl;
  String get sortParameter => _sortParameter;
  String get sortDirection => _sortDirection;

  /// 선택된 총 이미지 개수
  int get selectedPhotosCount =>
      groups.fold(0, (sum, group) => sum + group.selectedIndexes.length);

  /// 이미지가 하나라도 선택되었는지 여부
  bool get isAnythingSelected => selectedPhotosCount > 0;

  // --- 핵심 로직 ---

  /// 정렬 기준 변경 및 데이터 새로고침
  Future<void> toggleSort(String newParameter) async {
    if (_sortParameter == newParameter) {
      _sortDirection = _sortDirection == 'DESC' ? 'ASC' : 'DESC';
    } else {
      _sortParameter = newParameter;
      _sortDirection = 'DESC';
    }
    notifyListeners();
    await loadImages(); // 정렬 기준이 바뀌었으니 데이터를 다시 로드
  }

  /// 앨범 이미지 목록 로드 및 그룹핑
  Future<void> loadImages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 페이지네이션 없이 모든 이미지를 가져온다고 가정 (혹은 size를 매우 크게 설정)
      final response = await _albumRepository.getAlbumImages(
        albumId,
        size: 200, // 충분히 많은 이미지 가져오기
        parameter: _sortParameter,
        direction: _sortDirection,
      );
      // API 응답 데이터를 날짜별 그룹으로 변환
      groups = _groupImagesByDate(response.content);
    } catch (e) {
      _error = e.toString();
      debugPrint('이미지 목록 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// API 응답 데이터를 날짜별 그룹으로 가공
  List<AlbumDayGroup> _groupImagesByDate(List<dynamic> imageDtos) {
    final Map<String, List<AlbumImage>> dateMap = {};
    for (final dto in imageDtos) {
      // API 응답의 날짜 포맷에 맞게 수정 필요
      final date = (dto.date as String).replaceAll('-', '.');
      if (!dateMap.containsKey(date)) {
        dateMap[date] = [];
      }
      dateMap[date]!.add(
        AlbumImage(imageId: dto.imageId, imageUrl: dto.imageUrl),
      );
    }
    return dateMap.entries
        .map((entry) => AlbumDayGroup(date: entry.key, images: entry.value))
        .toList();
  }

  /// 이미지 선택/해제 토글 (그룹 인덱스와 이미지 인덱스 기반)
  void togglePhotoSelection(int groupIndex, int imageIndex) {
    final group = groups[groupIndex];
    if (group.selectedIndexes.contains(imageIndex)) {
      group.selectedIndexes.remove(imageIndex);
    } else {
      group.selectedIndexes.add(imageIndex);
    }
    // 전체 선택 여부 업데이트
    group.isAllSelected = group.selectedIndexes.length == group.images.length;
    notifyListeners();
  }

  /// 날짜 그룹 전체 선택/해제 토글
  void toggleAll(int groupIndex) {
    final group = groups[groupIndex];
    group.isAllSelected = !group.isAllSelected; // 상태 반전

    group.selectedIndexes.clear();
    if (group.isAllSelected) {
      // 전체 선택이면 모든 인덱스 추가
      group.selectedIndexes.addAll(
        List.generate(group.images.length, (i) => i),
      );
    }
    notifyListeners();
  }

  /// 커버 사진 선택 및 업로드 (기존과 동일)
  Future<void> pickCoverImage(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );
    if (assets == null || assets.isEmpty) return;
    final File? imageFile = await assets.first.file;
    if (imageFile != null) {
      _coverImage = imageFile;
      notifyListeners();
      await _uploadCoverImage(imageFile);
    }
  }

  Future<void> _uploadCoverImage(File imageFile) async {
    _isUploading = true;
    _error = null;
    notifyListeners();
    try {
      final imageBytes = await imageFile.readAsBytes();
      _coverImageUrl = await _coverImageService.uploadEventCoverImage(
        imageBytes,
      );
    } catch (e) {
      _error = '커버 이미지 업로드 실패: $e';
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// 이벤트 생성 로직
  Future<bool> createEvent() async {
    // 1. 모든 그룹을 순회하며 선택된 이미지 ID 목록 추출
    final List<int> selectedImageIds = [];
    for (final group in groups) {
      for (final index in group.selectedIndexes) {
        selectedImageIds.add(group.images[index].imageId);
      }
    }

    // 2. 유효성 검사
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
    if (selectedImageIds.isEmpty) {
      _error = '이미지를 하나 이상 선택해주세요.';
      notifyListeners();
      return false;
    }

    _isUploading = true;
    _error = null;
    notifyListeners();

    try {
      // 3. 이벤트 생성 API 호출
      final createResponse = await _eventRepository.createEvent(
        EventCreateRequestDto(
          albumId: albumId,
          title: titleController.text,
          coverUrl: _coverImageUrl!,
        ),
      );

      // 4. 생성된 이벤트에 이미지 추가 API 호출
      await _eventRepository.addImagesToEvent(
        createResponse.eventId,
        EventAddImagesRequestDto(imageIds: selectedImageIds),
      );

      return true;
    } catch (e) {
      _error = '이벤트 생성 실패: $e';
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
