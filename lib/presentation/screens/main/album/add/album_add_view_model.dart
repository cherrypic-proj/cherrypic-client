import 'dart:typed_data';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/dto/response/unlinked_payment_response_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/repositories/payment_repository.dart';
import 'package:cherrypic/data/album/services/album_cover_image_service.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:flutter/material.dart';

class AlbumAddViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;
  final PaymentRepository _paymentRepository;
  final ImageUploadService _imageUploadService;

  AlbumAddViewModel({
    AlbumRepository? albumRepository,
    PaymentRepository? paymentRepository,
    ImageUploadService? imageUploadService,
  })  : _albumRepository = albumRepository ?? AlbumRepository(),
        _paymentRepository = paymentRepository ?? PaymentRepository(),
        _imageUploadService = imageUploadService ?? ImageUploadService();

  bool _isPermissionEnabled = false;
  bool _isLoading = false;
  String? _error;
  AlbumType? _selectedAlbumType;
  UnlinkedPaymentResponseDto? _unlinkedPayment;
  bool _isRecovering = false;

  bool get isPermissionEnabled => _isPermissionEnabled;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AlbumType? get selectedAlbumType => _selectedAlbumType;
  UnlinkedPaymentResponseDto? get unlinkedPayment => _unlinkedPayment;
  bool get isRecovering => _isRecovering;

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

  bool _isValidAlbumTypeString(String typeString) {
    final upperTypeString = typeString.toUpperCase();
    return AlbumType.values
        .any((type) => type.name.toUpperCase() == upperTypeString);
  }

  Future<UnlinkedPaymentResponseDto?> checkForOrphanedPayment() async {
    try {
      final payment = await _paymentRepository.getUnlinkedPayment();

      // 결제 정보가 있고, 앨범 타입이 유효한 경우에만 복구 대상으로 간주
      if (payment != null && _isValidAlbumTypeString(payment.albumType)) {
        _unlinkedPayment = payment;
        return _unlinkedPayment;
      }
      // 결제 정보가 없거나, 앨범 타입을 인식할 수 없으면 null 반환 (일반 생성 흐름)
      return null;
    } catch (e) {
      // 이 API 호출 실패는 복구 흐름의 실패일 뿐, 전체 앱의 오류가 아님.
      // 조용히 실패하고 일반 생성 흐름으로 진행.
      print('Error checking for orphaned payment: $e');
      return null;
    }
  }

  void acceptRecovery() {
    if (_unlinkedPayment == null) return;

    _isRecovering = true;
    final recoveredTypeString = _unlinkedPayment!.albumType.toUpperCase();

    // 이 메서드는 유효한 타입이 보장된 경우에만 호출되므로 orElse가 필요 없음.
    final recoveredType = AlbumType.values.firstWhere(
      (type) => type.name.toUpperCase() == recoveredTypeString,
    );

    setSelectedAlbumType(recoveredType);
  }

  Future<bool> createAlbum({
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
        type: _isRecovering
            ? _unlinkedPayment!.albumType
            : _selectedAlbumType!.name.toUpperCase(),
        paymentId: _isRecovering ? _unlinkedPayment!.paymentId : null,
        permissionControl: _isPermissionEnabled,
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
