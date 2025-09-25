import 'dart:typed_data';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/services/image_upload_service.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:flutter/material.dart';

class AlbumAddViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;
  final ImageUploadService _imageUploadService;

  AlbumAddViewModel({
    AlbumRepository? albumRepository,
    ImageUploadService? imageUploadService,
  }) : _albumRepository = albumRepository ?? AlbumRepository(),
       _imageUploadService = imageUploadService ?? ImageUploadService();

  bool _isPermissionEnabled = false;
  bool _isLoading = false;
  String? _error;
  AlbumType? _selectedAlbumType;

  bool get isPermissionEnabled => _isPermissionEnabled;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AlbumType? get selectedAlbumType => _selectedAlbumType;

  bool isCreateButtonEnabled(String albumName) {
    final isAlbumNameValid =
        albumName.trim().isNotEmpty && albumName != '앨범 이름이 표시됩니다';
    final isAlbumTypeSelected = _selectedAlbumType != null;
    return isAlbumNameValid && isAlbumTypeSelected;
  }

  void togglePermission(bool value) {
    if (_selectedAlbumType == AlbumType.basic && value) {
      return;
    }
    _isPermissionEnabled = value;
    notifyListeners();
  }

  void setSelectedAlbumType(AlbumType? type) {
    _selectedAlbumType = type;
    if (type == AlbumType.basic) {
      _isPermissionEnabled = false;
    }
    notifyListeners();
  }

  // 무료 앨범 생성 (Basic만 여기서 처리)
  Future<bool> createFreeAlbum({
    required String albumName,
    Uint8List? coverImage,
  }) async {
    if (albumName.trim().isEmpty) {
      _error = '앨범 이름을 입력해주세요.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String? coverUrl;
      if (coverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(coverImage);
      }

      final requestDto = AlbumCreateRequestDto(
        title: albumName.trim(),
        coverUrl: coverUrl,
        type: 'BASIC', // 무료는 항상 BASIC
        paymentId: null, // 무료는 paymentId 없음
        permissionControl: false, // Basic은 항상 false
      );

      await _albumRepository.createAlbum(requestDto);

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
