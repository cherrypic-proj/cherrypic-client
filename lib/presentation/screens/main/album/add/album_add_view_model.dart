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

  // 상태 변수들
  bool _isPermissionEnabled = false;
  bool _isLoading = false;
  String? _error;
  AlbumType? _selectedAlbumType;

  // Getters
  bool get isPermissionEnabled => _isPermissionEnabled;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AlbumType? get selectedAlbumType => _selectedAlbumType;

  void togglePermission(bool value) {
    _isPermissionEnabled = value;
    notifyListeners();
  }

  void setSelectedAlbumType(AlbumType? type) {
    _selectedAlbumType = type;
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
      // 결제 진행
      final paymentId = await _processPaymentWithUI(context);
      if (paymentId == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 앨범 생성
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

      // 이미지가 있으면 업로드
      if (coverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(coverImage);
      }

      final requestDto = AlbumCreateRequestDto(
        title: albumName.trim(),
        coverUrl: coverUrl,
        type: _selectedAlbumType!.apiValue,
        paymentId: paymentId,
        // BASIC 타입은 항상 권한 부여 비활성화
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
      // 1. 결제 준비
      final readyResponse = await _paymentRepository.readyPayment(
        type: _selectedAlbumType!.apiValue,
        albumId: null, // 첫 생성시 null
      );

      // 2. 결제 데이터 생성
      final paymentData = IamportService.createPaymentData(
        merchantUid: readyResponse.merchantUid,
        name: _selectedAlbumType!.displayName,
        amount: readyResponse.price,
        buyerName: readyResponse.buyerName,
      );

      // 3. 아임포트 결제 실행
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

      // 4. 결제 결과 확인
      if (result != null && IamportService.isPaymentSuccessful(result)) {
        final impUid = IamportService.getImpUid(result);
        if (impUid != null) {
          // 5. 결제 검증
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
