import 'dart:typed_data';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/repositories/payment_repository.dart';
import 'package:cherrypic/data/album/services/iamport_service.dart';
import 'package:cherrypic/data/album/services/image_upload_service.dart';
import 'package:cherrypic/presentation/screens/main/album/components/album_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';

class AlbumAddViewModel extends ChangeNotifier {
  final AlbumRepository _albumRepository;
  final PaymentRepository _paymentRepository;
  final ImageUploadService _imageUploadService;

  AlbumAddViewModel({
    AlbumRepository? albumRepository,
    PaymentRepository? paymentRepository,
    ImageUploadService? imageUploadService,
  }) : _albumRepository = albumRepository ?? AlbumRepository(),
       _paymentRepository = paymentRepository ?? PaymentRepository(),
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
    // 앨범 이름이 비어있지 않고, 초기 안내 문구가 아니며, 앨범 타입이 선택되었는지 확인
    final isAlbumNameValid =
        albumName.trim().isNotEmpty && albumName != '앨범 이름이 표시됩니다';
    final isAlbumTypeSelected = _selectedAlbumType != null;
    return isAlbumNameValid && isAlbumTypeSelected;
  }

  void togglePermission(bool value) {
    if (_selectedAlbumType == AlbumType.basic && value) {
      return; // 아무것도 하지 않고 종료
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

  // 무료 앨범 생성
  Future<bool> createFreeAlbum({
    required String albumName,
    Uint8List? coverImage,
  }) async {
    _selectedAlbumType = AlbumType.basic; // 무료는 BASIC
    return await _createAlbum(
      albumName: albumName,
      coverImage: coverImage,
      paymentId: null,
    );
  }

  // 유료 앨범 생성 (결제 포함)
  Future<bool> createPaidAlbumWithPayment(
    BuildContext context, {
    required String albumName,
    Uint8List? coverImage,
  }) async {
    if (_selectedAlbumType == null || _selectedAlbumType!.price == 0) {
      _error = '유료 앨범 타입을 선택해주세요.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final paymentId = await _processPaymentWithUI(context);
      if (paymentId == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final success = await _createAlbum(
        albumName: albumName,
        coverImage: coverImage,
        paymentId: paymentId,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 실제 앨범 생성 로직
  Future<bool> _createAlbum({
    required String albumName,
    Uint8List? coverImage,
    int? paymentId,
  }) async {
    if (_selectedAlbumType == null) {
      _error = '앨범 유형을 선택해주세요.';
      notifyListeners();
      return false;
    }

    if (albumName.trim().isEmpty) {
      _error = '앨범 이름을 입력해주세요.';
      notifyListeners();
      return false;
    }

    try {
      String? coverUrl;
      if (coverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(coverImage);
      }

      final requestDto = AlbumCreateRequestDto(
        title: albumName.trim(),
        coverUrl: coverUrl,
        type: _selectedAlbumType!.apiValue,
        paymentId: paymentId,
        permissionControl: _selectedAlbumType!.apiValue == 'BASIC'
            ? false
            : _isPermissionEnabled,
      );

      await _albumRepository.createAlbum(requestDto);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // UI에서 아임포트 결제를 실행하는 메서드
  Future<int?> _processPaymentWithUI(BuildContext context) async {
    try {
      final readyResponse = await _paymentRepository.readyPayment(
        type: _selectedAlbumType!.apiValue,
        albumId: null,
      );

      final paymentData = IamportService.createPaymentData(
        merchantUid: readyResponse.merchantUid,
        name: _selectedAlbumType!.displayName,
        amount: readyResponse.price,
        buyerName: readyResponse.buyerName,
      );

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IamportPayment(
            appBar: AppBar(
              title: const Text('결제'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            initialChild: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('결제 페이지를 불러오는 중입니다...'),
                ],
              ),
            ),
            userCode: IamportService.userCode,
            data: paymentData,
            callback: (result) => Navigator.pop(context, result),
          ),
        ),
      );

      if (result != null && IamportService.isPaymentSuccessful(result)) {
        final impUid = IamportService.getImpUid(result);
        if (impUid != null) {
          final verifyResponse = await _paymentRepository.verifyPayment(impUid);
          return verifyResponse.paymentId;
        }
      }

      _error = '결제가 취소되었거나 실패했습니다.';
      return null;
    } catch (e) {
      _error = '결제 중 오류가 발생했습니다: ${e.toString()}';
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
