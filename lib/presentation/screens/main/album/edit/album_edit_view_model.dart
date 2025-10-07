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
  bool get isLoadingParticipants => _isLoadingParticipants; // 초기 데이터 설정
  String? get error => _error;

  void _initializeData() {
    _albumName = initialData.title;
    _coverImageUrl = initialData.coverUrl;

    // API 값(BASIC, PRO, PREMIUM)을 AlbumType enum으로 변환
    _albumType = AlbumType.values.firstWhere(
      (type) => type.apiValue == initialData.type,
      orElse: () => AlbumType.basic,
    );

    // Basic 체크 제거 - 항상 참가자 목록 로드
    loadParticipants();
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
    // 1. 앨범 이름이 비어있으면 비활성화
    final isNameValid = _albumName.trim().isNotEmpty;

    // 2. 앨범 유형이 선택되어 있어야 함 (항상 선택되어 있긴 함)
    final isTypeSelected = _albumType != null;

    // 3. 로딩 중이 아니어야 함
    final notLoading = !_isLoading;

    // 필수 조건만 체크, 변경사항 여부는 체크 안 함
    return isNameValid && isTypeSelected && notLoading;
  }

  // 참가자 목록 로드
  Future<void> loadParticipants() async {
    // Basic 체크 제거
    _isLoadingParticipants = true;
    notifyListeners();

    try {
      final response = await _albumRepository.getParticipants(
        albumId,
        size: 100,
      );
      _participants = response.content;

      // 디버그 로그 추가
      debugPrint('✅ 참가자 로드 성공: ${_participants.length}명');
      for (var p in _participants) {
        debugPrint('  - ${p.nickname} (${p.role})');
      }
    } catch (e) {
      debugPrint('❌ 참가자 로드 실패: $e');
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

  // 앨범 유형 변경
  void setAlbumType(AlbumType? type) {
    _albumType = type;
    notifyListeners();
  }

  // 참가자 강퇴
  Future<bool> kickParticipant(int participantId) async {
    try {
      await _albumRepository.kickParticipant(albumId, participantId);

      // 로컬 리스트에서도 제거
      _participants.removeWhere((p) => p.participantId == participantId);
      notifyListeners();

      debugPrint('참가자 강퇴 성공: $participantId');
      return true;
    } catch (e) {
      debugPrint('참가자 강퇴 실패: $e');
      _error = '권한이 없습니다.';
      notifyListeners();
      return false;
    }
  }
}
