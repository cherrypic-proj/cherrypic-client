import 'dart:io';
import 'package:cherrypic/data/album_event/dto/request/event_update_request_dto.dart';
import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:cherrypic/data/album_event/services/event_cover_image_service.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class EventEditViewModel extends ChangeNotifier {
  final EventAlbum event;
  final EventRepository _eventRepository;
  final EventCoverImageService _coverImageService;

  EventEditViewModel({
    required this.event,
    EventRepository? eventRepository,
    EventCoverImageService? coverImageService,
  }) : _eventRepository = eventRepository ?? EventRepository(),
       _coverImageService = coverImageService ?? EventCoverImageService() {
    titleController = TextEditingController(text: event.title);
    _coverImageUrl = event.imageUrl;

    // [추가] 텍스트 필드의 변경을 감지하기 위해 리스너를 추가합니다.
    titleController.addListener(() {
      notifyListeners(); // 텍스트가 변경될 때마다 UI를 갱신하여 버튼 상태를 업데이트
    });
  }

  late final TextEditingController titleController;
  File? _coverImage;
  File? get coverImage => _coverImage;
  String? _coverImageUrl;
  String? get coverImageUrl => _coverImageUrl;
  bool _isUploading = false;
  bool _isDeleting = false;
  bool _isSaving = false;
  String? _error;

  bool get isUploading => _isUploading;
  bool get isDeleting => _isDeleting;
  bool get isSaving => _isSaving;
  String? get error => _error;

  // [추가] 변경사항이 있는지 확인하는 getter
  bool get hasChanges {
    // 제목이 다르거나, 커버 이미지 URL이 다르면 변경된 것으로 간주
    return titleController.text != event.title ||
        _coverImageUrl != event.imageUrl;
  }

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

  /// 이벤트 정보 수정
  Future<bool> updateEvent() async {
    // [수정] 유효성 검사 및 변경사항 확인 로직 강화
    if (!hasChanges) {
      _error = '변경된 내용이 없습니다.';
      notifyListeners();
      return false;
    }
    if (titleController.text.isEmpty) {
      _error = '이벤트 제목을 입력해주세요.';
      notifyListeners();
      return false;
    }
    if (_coverImageUrl == null || _coverImageUrl!.isEmpty) {
      _error = '커버 이미지를 업로드해주세요.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final isTitleChanged = titleController.text != event.title;
      final isCoverChanged = _coverImageUrl != event.imageUrl;

      // DTO를 만들 때, 변경된 필드만 포함하여 생성
      final requestDto = EventUpdateRequestDto(
        title: isTitleChanged ? titleController.text : null,
        coverUrl: isCoverChanged ? _coverImageUrl : null,
      );

      await _eventRepository.updateEvent(event.eventId, requestDto);

      debugPrint('이벤트 수정 성공');
      return true;
    } catch (e) {
      _error = '이벤트 수정 실패: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // [신규] 이벤트 삭제 함수
  Future<bool> deleteEvent() async {
    _isDeleting = true;
    _error = null;
    notifyListeners();

    try {
      await _eventRepository.deleteEvent(event.eventId);
      return true;
    } catch (e) {
      _error = '이벤트 삭제에 실패했습니다: $e';
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
