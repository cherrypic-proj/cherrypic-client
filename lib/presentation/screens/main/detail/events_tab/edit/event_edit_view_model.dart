import 'dart:io';
import 'package:cherrypic/data/album_event/dto/request/event_update_request_dto.dart';
import 'package:cherrypic/data/album_event/repositories/event_repository.dart';
import 'package:cherrypic/data/album_event/services/event_cover_image_service.dart';
import 'package:cherrypic/presentation/screens/main/detail/events_tab/event_album.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 이벤트 수정을 위한 ViewModel
class EventEditViewModel extends ChangeNotifier {
  final EventAlbum event; // 수정할 기존 이벤트 정보
  final EventRepository _eventRepository;
  final EventCoverImageService _coverImageService;

  EventEditViewModel({
    required this.event,
    EventRepository? eventRepository,
    EventCoverImageService? coverImageService,
  }) : _eventRepository = eventRepository ?? EventRepository(),
       _coverImageService = coverImageService ?? EventCoverImageService() {
    // 기존 이벤트 제목으로 컨트롤러 초기화
    titleController = TextEditingController(text: event.title);
    // 기존 커버 이미지 URL 설정
    _coverImageUrl = event.imageUrl;
  }

  // --- 상태 변수 ---
  late final TextEditingController titleController;

  File? _coverImage; // 새로 선택한 커버 이미지 파일
  File? get coverImage => _coverImage;

  String? _coverImageUrl; // 현재 적용된 커버 이미지 URL (기존 또는 신규)
  String? get coverImageUrl => _coverImageUrl;

  bool _isUploading = false; // 커버 이미지 업로드 중 상태
  bool _isSaving = false; // 최종 저장 중 상태
  String? _error;

  bool get isUploading => _isUploading;
  bool get isSaving => _isSaving;
  String? get error => _error;

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

    final File? imageFile = await assets.first.file;
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
      debugPrint('새 커버 이미지 업로드 성공: $_coverImageUrl');
    } catch (e) {
      _error = '커버 이미지 업로드 실패: $e';
      debugPrint(_error);
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// 이벤트 정보 수정
  Future<bool> updateEvent() async {
    // 유효성 검사
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

    // 변경사항이 있는지 확인
    final isTitleChanged = titleController.text != event.title;
    final isCoverChanged = _coverImageUrl != event.imageUrl;

    if (!isTitleChanged && !isCoverChanged) {
      _error = '변경된 내용이 없습니다.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final requestDto = EventUpdateRequestDto(
        title: isTitleChanged ? titleController.text : null,
        coverUrl: isCoverChanged ? _coverImageUrl : null,
      );

      await _eventRepository.updateEvent(event.eventId, requestDto);

      debugPrint('이벤트 수정 성공');
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = '이벤트 수정 실패: $e';
      debugPrint(_error);
      _isSaving = false;
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
