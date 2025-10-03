import 'package:cherrypic/core/router/route_path.dart';
import 'package:cherrypic/data/album/dto/request/album_create_request_dto.dart';
import 'package:cherrypic/data/album/repositories/album_repository.dart';
import 'package:cherrypic/data/album/repositories/payment_repository.dart';
import 'package:cherrypic/data/album/services/album_cover_image_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_sub_app_bar.dart';

class PaymentCompleteScreen extends StatefulWidget {
  final String? subscriptionType;
  final Map<String, dynamic>? albumData;
  final String? impUid;
  final bool isSuccess;

  const PaymentCompleteScreen({
    super.key,
    this.subscriptionType,
    this.albumData,
    this.impUid,
    this.isSuccess = false,
  });

  @override
  State<PaymentCompleteScreen> createState() => _PaymentCompleteScreenState();
}

class _PaymentCompleteScreenState extends State<PaymentCompleteScreen> {
  final PaymentRepository _paymentRepository = PaymentRepository();
  final AlbumRepository _albumRepository = AlbumRepository();
  final ImageUploadService _imageUploadService = ImageUploadService();

  bool _isCreatingAlbum = false;
  String? _errorMessage;

  // 앨범 생성하기 버튼 클릭 시 호출 - mounted 체크 추가
  Future<void> _createAlbumWithPayment() async {
    if (_isCreatingAlbum) return;

    if (!mounted) return; // 초기 체크

    setState(() {
      _isCreatingAlbum = true;
      _errorMessage = null;
    });

    try {
      // 1. 결제 검증
      if (widget.impUid == null) {
        throw Exception('결제 정보가 없습니다.');
      }

      final verifyResponse = await _paymentRepository.verifyPayment(
        widget.impUid!,
      );

      if (!mounted) return; // API 응답 후 체크

      final paymentId = verifyResponse.paymentId;

      // 2. 앨범 데이터 준비
      final albumData = widget.albumData ?? {};
      final albumName = albumData['albumName'] as String? ?? '';
      final coverImage = albumData['coverImage']; // Uint8List?

      if (albumName.trim().isEmpty) {
        throw Exception('앨범 이름이 없습니다.');
      }

      // 3. 커버 이미지 업로드 (있는 경우)
      String? coverUrl;
      if (coverImage != null) {
        coverUrl = await _imageUploadService.uploadCoverImage(coverImage);
      }

      if (!mounted) return; // 이미지 업로드 후 체크

      // 4. 구독 타입을 API 값으로 변환
      String apiType;
      switch (widget.subscriptionType?.toLowerCase()) {
        case 'pro':
          apiType = 'PRO';
          break;
        case 'premium':
          apiType = 'PREMIUM';
          break;
        default:
          apiType = 'PRO';
      }

      // 5. 앨범 생성 요청
      final requestDto = AlbumCreateRequestDto(
        title: albumName.trim(),
        coverUrl: coverUrl,
        type: apiType,
        paymentId: paymentId,
        permissionControl: albumData['isPermissionEnabled'] as bool? ?? false,
      );

      await _albumRepository.createAlbum(requestDto);

      if (!mounted) return; // 앨범 생성 후 체크

      // 6. 성공 시 홈으로 이동
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return; // 에러 발생 시에도 체크

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      // finally에서도 mounted 체크 후 setState
      if (mounted) {
        setState(() {
          _isCreatingAlbum = false;
        });
      }
    }
  }

  // 성공 다이얼로그 - mounted 체크 추가
  void _showSuccessDialog() {
    if (!mounted) return; // 다이얼로그 표시 전 체크

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('성공'),
        content: const Text('앨범이 성공적으로 생성되었습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              // 홈 화면으로 이동 (모든 이전 화면들을 제거)
              context.go('/'); // 또는 적절한 홈 경로
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomSubAppBar(title: 'CherryPic 정기 구독'),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 앨범 구독 시작 로고
                  Image.asset(
                    'assets/images/payment_complete.png',
                    width: 240.61,
                    height: 197.75,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 51.75),

                  /// 에러 메시지 표시
                  if (_errorMessage != null) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _errorMessage = null;
                              });
                            },
                            child: const Text('닫기'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  /// 앨범 생성하기 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CustomButton(
                      onPressed: _isCreatingAlbum
                          ? null
                          : _createAlbumWithPayment,
                      variant: AppButtonVariant.filled,
                      type: CustomButtonType.createAlbum,
                      text: _isCreatingAlbum ? '앨범 생성 중...' : '앨범 생성하기',
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
