import 'dart:typed_data';
import 'package:cherrypic/data/album/dto/request/album_update_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/album_detail_dto.dart';
import 'package:cherrypic/data/album/dto/response/participant_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/services/album_cover_image_service.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:flutter/material.dart';

class AlbumEditViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;
  final ImageUploadService _imageUploadService;
  final int albumId;
  final AlbumDetailDto initialData;

  AlbumEditViewModel({
    required this.albumId,
    required this.initialData,
    AlbumRepository? albumRepository,
    ImageUploadService? imageUploadService,
  }) : _albumRepository = albumRepository ?? AlbumRepository(),
       _imageUploadService = imageUploadService ?? ImageUploadService() {
    _initializeData();
  }

  // 상태 변수들
  String _albumName = '';
  String? _coverImageUrl;
  Uint8List? _newCoverImage;
  AlbumType? _albumType;
  bool _isPermissionEnabled = false;
  List<ParticipantDto> _participants = [];

  bool _isLoading = false;
  bool _isLoadingParticipants = false;
  String? _error;

  // Getters
  String get albumName => _albumName;
  String? get coverImageUrl => _coverImageUrl;
  Uint8List? get newCoverImage => _newCoverImage;
  AlbumType? get albumType => _albumType;
  bool get isPermissionEnabled => _isPermissionEnabled;
  List<ParticipantDto> get participants => _participants;
  bool get isLoading => _isLoading;
  bool get isLoadingParticipants => _isLoadingParticipants;
  String? get error => _error;

  // 초기 데이터 설정
  void _initializeData() {
    _albumName = initialData.title;
    _coverImageUrl = initialData.coverUrl;

    // API 값(BASIC, PRO, PREMIUM)을 AlbumType enum으로 변환
    _albumType = AlbumType.values.firstWhere(
      (type) => type.apiValue == initialData.type,
      orElse: () => AlbumType.basic,
    );

    // Basic 타입이 아닌 경우에만 참가자 목록 로드
    if (_albumType != AlbumType.basic) {
      loadParticipants();
    }
  }

  // 앨범 이름 변경
  void setAlbumName(String name) {
    _albumName = name;
    notifyListeners();
  }

  // 커버 이미지 변경
  void setCoverImage(Uint8List? image) {
    _newCoverImage = image;
    notifyListeners();
  }

  // 수정 버튼 활성화 여부
  bool get isUpdateButtonEnabled {
    final isNameValid = _albumName.trim().isNotEmpty;
    final hasChanges =
        _albumName != initialData.title || _newCoverImage != null;
    return isNameValid && hasChanges && !_isLoading;
  }

  // 참가자 목록 로드
  Future<void> loadParticipants() async {
    if (_albumType == AlbumType.basic) return;

    _isLoadingParticipants = true;
    notifyListeners();

    try {
      final response = await _albumRepository.getParticipants(
        albumId,
        size: 100,
      );
      _participants = response.content;
    } catch (e) {
      debugPrint('참가자 로드 실패: $e');
    } finally {
      _isLoadingParticipants = false;
      notifyListeners();
    }
  }

  // 앨범 수정 실행
  Future<bool> updateAlbum() async {
    if (_albumName.trim().isEmpty) {
      _error = '앨범 이름을 입력해주세요.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String? coverUrl = _coverImageUrl;

      // 새로운 커버 이미지가 있으면 업로드
      if (_newCoverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(_newCoverImage!);
      }

      final requestDto = AlbumUpdateRequestDto(
        title: _albumName.trim() != initialData.title
            ? _albumName.trim()
            : null,
        coverUrl: coverUrl != initialData.coverUrl ? coverUrl : null,
      );

      await _albumRepository.updateAlbum(albumId, requestDto);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
